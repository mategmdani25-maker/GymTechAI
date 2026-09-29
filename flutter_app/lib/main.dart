import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(ApiService())..restore(),
    child: const GymTechApp(),
  ));
}

class GymTechApp extends StatelessWidget {
  const GymTechApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GymTechAI',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    home: const RootScreen(),
  );
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return auth.isLoggedIn ? const DashboardScreen() : const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(); final password = TextEditingController();
  @override void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AuthScaffold(
    title: 'Iniciar sesión',
    children: [
      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock))),
      Consumer<AuthProvider>(builder: (_, auth, __) => Column(children: [
        if (auth.error != null) Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        FilledButton(onPressed: auth.loading ? null : () async { if (email.text.isEmpty || password.text.isEmpty) return; await auth.login(email.text, password.text); }, child: Text(auth.loading ? 'Entrando...' : 'Entrar')),
      ])),
      TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Crear cuenta')),
    ],
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController(); final email = TextEditingController(); final password = TextEditingController();
  @override void dispose() { name.dispose(); email.dispose(); password.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AuthScaffold(
    title: 'Crear cuenta',
    children: [
      TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person))),
      TextField(controller: email, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña (mínimo 8 caracteres)', prefixIcon: Icon(Icons.lock))),
      Consumer<AuthProvider>(builder: (_, auth, __) => Column(children: [
        if (auth.error != null) Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        FilledButton(onPressed: auth.loading ? null : () async { final ok = await auth.register(email.text, password.text, name.text); if (ok && mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta creada. Inicia sesión.'))); Navigator.pop(context); } }, child: Text(auth.loading ? 'Creando...' : 'Registrarse')),
      ])),
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Volver al login')),
    ],
  );
}

class AuthScaffold extends StatelessWidget {
  final String title; final List<Widget> children;
  const AuthScaffold({required this.title, required this.children, super.key});
  @override Widget build(BuildContext context) => Scaffold(body: Center(child: SingleChildScrollView(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Padding(padding: const EdgeInsets.all(24), child: Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('GymTechAI', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8), Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 24), ...children.map((w) => Padding(padding: const EdgeInsets.only(bottom: 14), child: w))])))))));
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;
  final pages = const [HomeTab(), WorkoutTab(), CheckInTab(), CoachTab(), StatsTab()];
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('GymTechAI'), actions: [IconButton(onPressed: () => context.read<AuthProvider>().logout(), icon: const Icon(Icons.logout))]),
    body: pages[index],
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: const [NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'), NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Rutina'), NavigationDestination(icon: Icon(Icons.favorite), label: 'Check-in'), NavigationDestination(icon: Icon(Icons.chat), label: 'Coach'), NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats')]),
  );
}

class HomeTab extends StatelessWidget { const HomeTab({super.key}); @override Widget build(BuildContext context) { final user = context.watch<AuthProvider>().user; return ListView(padding: const EdgeInsets.all(16), children: [Text('Hola, ${user?['nombre'] ?? 'atleta'}', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 12), const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('Entrena con planificación, seguimiento y un coach inteligente.'))), const SizedBox(height: 12), const Card(child: ListTile(leading: Icon(Icons.check_circle), title: Text('Consejo del día'), subtitle: Text('Prioriza técnica y deja 1–3 repeticiones en reserva.')))]); } }

class WorkoutTab extends StatefulWidget { const WorkoutTab({super.key}); @override State<WorkoutTab> createState() => _WorkoutTabState(); }
class _WorkoutTabState extends State<WorkoutTab> { final squat=TextEditingController(text:'140'); final bench=TextEditingController(text:'100'); final rdl=TextEditingController(text:'150'); final weeks=TextEditingController(text:'12'); Map<String,dynamic>? result; String? error; bool loading=false;
  @override void dispose(){squat.dispose();bench.dispose();rdl.dispose();weeks.dispose();super.dispose();}
  @override Widget build(BuildContext context){ return ListView(padding: const EdgeInsets.all(16), children:[Text('Generar rutina',style:Theme.of(context).textTheme.headlineSmall), for(final item in [('Sentadilla',squat),('Press banca',bench),('Peso muerto rumano',rdl),('Semanas',weeks)]) Padding(padding:const EdgeInsets.only(top:10),child:TextField(controller:item.$2,decoration:InputDecoration(labelText:item.$1))), const SizedBox(height:16), FilledButton(onPressed:loading?null() async {setState(()=>loading=true);try{result=await context.read<AuthProvider>().api.generateWorkout(context.read<AuthProvider>().token!,{'tipo_usuario':'premium','semanas_totales':int.tryParse(weeks.text)??12,'rm_snt':double.tryParse(squat.text)??140,'reps_snt':1,'rm_bnc':double.tryParse(bench.text)??100,'reps_bnc':1,'rm_rdl':double.tryParse(rdl.text)??150,'reps_rdl':1});error=null;}catch(e){error=e.toString();}finally{if(mounted)setState(()=>loading=false);}}, child:Text(loading?'Generando...':'Generar')), if(error!=null) Text(error!,style:TextStyle(color:Theme.of(context).colorScheme.error)), if(result!=null) Card(child:Padding(padding:const EdgeInsets.all(16),child:Text('Plan generado: ${result!['semanas_totales']} semanas')))]); }
}

class CheckInTab extends StatefulWidget { const CheckInTab({super.key}); @override State<CheckInTab> createState()=>_CheckInTabState(); }
class _CheckInTabState extends State<CheckInTab>{ final weight=TextEditingController(text:'75'); final energy=TextEditingController(text:'4'); final pain=TextEditingController(text:'0'); bool loading=false; String? message; @override void dispose(){weight.dispose();energy.dispose();pain.dispose();super.dispose();} @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[Text('Check-in diario',style:Theme.of(context).textTheme.headlineSmall),TextField(controller:weight,decoration:const InputDecoration(labelText:'Peso del ejercicio (kg)')),TextField(controller:energy,decoration:const InputDecoration(labelText:'Energía (1-5)')),TextField(controller:pain,decoration:const InputDecoration(labelText:'Dolor (0-5)')),const SizedBox(height:16),FilledButton(onPressed:loading?null() async{setState(()=>loading=true);try{final a=context.read<AuthProvider>();final r=await a.api.checkIn(a.token!,{'peso_ejercicio_hoy':double.tryParse(weight.text)??75,'nivel_energia':int.tryParse(energy.text)??4,'nivel_dolor':int.tryParse(pain.text)??0,'estado_bio':'normal','salto_minimo':2.5});message='Peso ajustado: ${r['peso_ajustado_kg']} kg';}catch(e){message=e.toString();}finally{if(mounted)setState(()=>loading=false);}},child:Text(loading?'Guardando...':'Guardar check-in')),if(message!=null)Padding(padding:const EdgeInsets.only(top:12),child:Text(message!))]); }

class CoachTab extends StatefulWidget { const CoachTab({super.key}); @override State<CoachTab> createState()=>_CoachTabState(); }
class _CoachTabState extends State<CoachTab>{ final question=TextEditingController(); String? answer; bool loading=false; @override void dispose(){question.dispose();super.dispose();} @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[Text('Coach IA',style:Theme.of(context).textTheme.headlineSmall),TextField(controller:question,maxLines:3,decoration:const InputDecoration(labelText:'¿Qué quieres consultar?')),const SizedBox(height:16),FilledButton(onPressed:loading?null() async{setState(()=>loading=true);try{final a=context.read<AuthProvider>();final r=await a.api.askCoach(a.token!,question.text);answer=r['respuesta']?.toString();}catch(e){answer=e.toString();}finally{if(mounted)setState(()=>loading=false);}},child:Text(loading?'Pensando...':'Preguntar')),if(answer!=null)Card(child:Padding(padding:const EdgeInsets.all(16),child:Text(answer!)))]); }

class StatsTab extends StatefulWidget { const StatsTab({super.key}); @override State<StatsTab> createState()=>_StatsTabState(); }
class _StatsTabState extends State<StatsTab>{ Map<String,dynamic>? stats; bool loading=true; @override void initState(){super.initState();_load();} Future<void> _load()async{try{final a=context.read<AuthProvider>();stats=await a.api.stats(a.token!);}finally{if(mounted)setState(()=>loading=false);}} @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[Text('Progreso',style:Theme.of(context).textTheme.headlineSmall),if(loading)const CircularProgressIndicator() else if(stats!=null) ...[StatCard('Sesiones',stats!['sesiones_totales']),StatCard('Series',stats!['series_totales']),StatCard('Volumen (kg)',stats!['volumen_kg'])]]); }
class StatCard extends StatelessWidget{final String label;final dynamic value;const StatCard(this.label,this.value,{super.key});@override Widget build(BuildContext context)=>Card(child:ListTile(title:Text(label),trailing:Text('$value',style:Theme.of(context).textTheme.titleLarge)));}
