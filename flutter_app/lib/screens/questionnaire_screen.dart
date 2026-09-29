import 'package:flutter/material.dart';
import 'payment_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int pasoActual = 0;
  bool estaCargandoIA = false;
  String mensajeCargaIA = "Procesando respuestas...";

  // Variables de respuestas
  int diasEntrenamiento = 4;
  String tiempoSesion = '1 a 2 horas';
  String genero = 'Hombre';
  String optimizarMenstruacion = 'No';
  String experiencia = 'Intermedio';
  String prioridadMuscular = 'Equilibrado';
  String tieneLesiones = 'Ninguna, estoy 100% sano';

  void _iniciarProcesamientoIA() async {
    setState(() {
      estaCargandoIA = true;
      mensajeCargaIA = "🧠 Analizando tu capacidad de recuperación...";
    });
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() => mensajeCargaIA = "📊 Calculando volumen total y series de Back-Off...");
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() => mensajeCargaIA = "🏋️ Estructurando bloques de periodización matemática...");
    
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pasos = [];

    pasos.add(_buildSlider(
      titulo: "¿Cuántos días vas a entrenar a la semana?",
      subtitulo: "La IA distribuirá tus grupos musculares según tu disponibilidad.",
      min: 2,
      max: 6,
      valorActual: diasEntrenamiento.toDouble(),
      onCambio: (val) => setState(() => diasEntrenamiento = val.toInt()),
    ));

    pasos.add(_buildSeleccionUnica(
      titulo: "¿Cuánto tiempo tienes por sesión?",
      subtitulo: "Ajustaremos el número total de ejercicios para optimizar tu tiempo.",
      opciones: ['Menos de 1 hora', '1 a 2 horas', 'Más de 2 horas'],
      seleccionado: tiempoSesion,
      onCambio: (val) => setState(() => tiempoSesion = val),
    ));

    pasos.add(_buildSeleccionUnica(
      titulo: "¿Cuál es tu género?",
      subtitulo: "Utilizamos esto para calibrar parámetros fisiológicos y metabólicos.",
      opciones: ['Hombre', 'Mujer'],
      seleccionado: genero,
      onCambio: (val) => setState(() => genero = val),
    ));

    if (genero == 'Mujer') {
      pasos.add(_buildSeleccionUnica(
        titulo: "¿Deseas adaptar el plan a tu ciclo menstrual?",
        subtitulo: "La IA regulará la intensidad y volumen en tus semanas de mayor fatiga.",
        opciones: ['Sí, optimizar con mi ciclo', 'No, prefiero una periodización fija'],
        seleccionado: optimizarMenstruacion,
        onCambio: (val) => setState(() => optimizarMenstruacion = val),
      ));
    }

    pasos.add(_buildSeleccionUnica(
      titulo: "¿Cuál es tu nivel de conocimiento en el entrenamiento?",
      subtitulo: "Esto definirá si necesitas guías básicas o herramientas de periodización avanzada.",
      opciones: [
        'Básico (Necesito que me guíen en ejercicios)',
        'Intermedio (Busco estructurar mis semanas)',
        'Avanzado (Domino RPE/RIR y optimización matemática)'
      ],
      seleccionado: experiencia,
      onCambio: (val) => setState(() => experiencia = val),
    ));

    pasos.add(_buildSeleccionUnica(
      titulo: "¿Qué grupo muscular deseas priorizar?",
      subtitulo: "La IA añadirá volumen estratégico al inicio de tus rutinas.",
      opciones: ['Equilibrado', 'Pecho / Torso superior', 'Espalda / Tracción', 'Piernas / Tren inferior', 'Brazos y Hombros'],
      seleccionado: prioridadMuscular,
      onCambio: (val) => setState(() => prioridadMuscular = val),
    ));

    pasos.add(_buildSeleccionUnica(
      titulo: "¿Tienes alguna lesión o molestia?",
      subtitulo: "El algoritmo evitará o sustituirá patrones de movimiento dolorosos.",
      opciones: ['Ninguna, estoy 100% sano', 'Espalda baja', 'Rodillas', 'Hombros'],
      seleccionado: tieneLesiones,
      onCambio: (val) => setState(() => tieneLesiones = val),
    ));

    double progreso = (pasoActual + 1) / pasos.length;

    if (estaCargandoIA) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Color(0xFFCCFF00), strokeWidth: 5),
                ),
                const SizedBox(height: 32),
                const Text("GymTechAI Motor", style: TextStyle(fontSize: 14, color: Color(0xFFCCFF00), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(mensajeCargaIA, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: pasoActual > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => pasoActual--))
            : null,
        title: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progreso,
                backgroundColor: Colors.white10,
                color: const Color(0xFFCCFF00),
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "${pasoActual + 1}/${pasos.length}",
              style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: pasos[pasoActual]),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF00),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  if (pasoActual < pasos.length - 1) {
                    setState(() => pasoActual++);
                  } else {
                    _iniciarProcesamientoIA();
                  }
                },
                child: Text(pasoActual == pasos.length - 1 ? "Analizar Perfil con IA" : "Siguiente", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeleccionUnica({required String titulo, required String subtitulo, required List<String> opciones, required String seleccionado, required ValueChanged<String> onCambio}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitulo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        ...opciones.map((opcion) {
          final esEste = seleccionado == opcion;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 58,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: esEste ? const Color(0xFFCCFF00).withOpacity(0.1) : const Color(0xFF1E1E1E),
                side: BorderSide(color: esEste ? const Color(0xFFCCFF00) : Colors.transparent, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => onCambio(opcion),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(opcion, style: TextStyle(color: esEste ? const Color(0xFFCCFF00) : Colors.white, fontSize: 14, fontWeight: esEste ? FontWeight.bold : FontWeight.normal)),
                  ),
                  if (esEste)
                    const Icon(Icons.check_circle, color: Color(0xFFCCFF00), size: 22)
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSlider({required String titulo, required String subtitulo, required double min, required double max, required double valorActual, required ValueChanged<double> onCambio}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitulo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 48),
        Center(child: Text("${valorActual.toInt()} días a la semana", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFCCFF00)))),
        const SizedBox(height: 16),
        Slider(value: valorActual, min: min, max: max, divisions: (max - min).toInt(), activeColor: const Color(0xFFCCFF00), inactiveColor: Colors.white10, onChanged: onCambio),
      ],
    );
  }
}
