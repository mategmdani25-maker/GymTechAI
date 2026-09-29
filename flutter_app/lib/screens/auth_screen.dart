import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'questionnaire_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  // --- Estados de la Interfaz ---
  bool esRegistro = false;
  bool ocultarContrasena = true;
  bool recordarUsuario = false;
  bool estaCargando = false;
  String idiomaActual = 'es'; // Por defecto. Auto-detectable más adelante.

  // --- Controladores de Texto ---
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- Alertas de Validación ---
  String? errorEmail;
  String? errorPassword;

  // --- Lógica del Medidor de Fortaleza de Contraseña ---
  double fortalezaContrasena = 0.0; // De 0.0 a 1.0
  String textoFortaleza = '';
  Color colorFortaleza = Colors.grey;

  // --- Animación de Partículas de Fondo ---
  late AnimationController _particulasController;
  final List<math.Point> _particulas = List.generate(15, (i) => math.Point(math.Random().nextDouble(), math.Random().nextDouble()));

  // --- DICCIONARIO MAESTRO MULTI-IDIOMA (5 Idiomas Estratégicos) ---
  final Map<String, Map<String, String>> _textos = {
    'es': {
      'login': 'Iniciar Sesión', 'register': 'Registrarse', 'email': 'Correo electrónico',
      'pass': 'Contraseña', 'forget': '¿Olvidaste tu contraseña?', 'remember': 'Recordarme',
      'google': 'Continuar con Google', 'apple': 'Continuar con Apple', 'guest': 'Saltar registro e ir como invitado ➔',
      'noAccount': '¿No tienes cuenta? Regístrate aquí', 'hasAccount': '¿Ya tienes cuenta? Inicia Sesión',
      'emailReq': 'El correo electrónico es obligatorio', 'emailInv': 'Formato de correo inválido',
      'passReq': 'La contraseña es obligatoria', 'passShort': 'Mínimo 6 caracteres',
      'strength': 'Fortaleza: ', 'weak': 'Débil 🛑', 'medium': 'Media ⚠️', 'strong': 'Segura 💪',
      'qr': 'Acceso por código QR (Coach)', 'magical': 'Enlace mágico por Email',
      'morn': '¡Buenos días, atleta! 🌅', 'aft': '¡Buenas tardes! A entrenar 🏋️', 'night': '¡Buenas noches! Con fuerza 🌙'
    },
    'en': {
      'login': 'Sign In', 'register': 'Sign Up', 'email': 'Email address',
      'pass': 'Password', 'forget': 'Forgot password?', 'remember': 'Remember me',
      'google': 'Continue with Google', 'apple': 'Continue with Apple', 'guest': 'Skip registration and enter as guest ➔',
      'noAccount': 'Don\'t have an account? Sign up here', 'hasAccount': 'Already have an account? Sign In',
      'emailReq': 'Email is required', 'emailInv': 'Invalid email format',
      'passReq': 'Password is required', 'passShort': 'Minimum 6 characters',
      'strength': 'Strength: ', 'weak': 'Weak 🛑', 'medium': 'Medium ⚠️', 'strong': 'Strong 💪',
      'qr': 'QR Code Access (Coach)', 'magical': 'Magic Email Link',
      'morn': 'Good morning, athlete! 🌅', 'aft': 'Good afternoon! Time to train 🏋️', 'night': 'Good night! Finish strong 🌙'
    },
    'pt': {
      'login': 'Iniciar Sessão', 'register': 'Cadastrar-se', 'email': 'E-mail',
      'pass': 'Senha', 'forget': 'Esqueceu sua senha?', 'remember': 'Lembrar-de mim',
      'google': 'Continuar com Google', 'apple': 'Continuar com Apple', 'guest': 'Pular registro e entrar como convidado ➔',
      'noAccount': 'Não tem uma conta? Cadastre-se aqui', 'hasAccount': 'Já tem uma conta? Entre aqui',
      'emailReq': 'O e-mail é obrigatório', 'emailInv': 'Formato de e-mail inválido',
      'passReq': 'A senha é obrigatória', 'passShort': 'Mínimo 6 caracteres',
      'strength': 'Força: ', 'weak': 'Fraca 🛑', 'medium': 'Média ⚠️', 'strong': 'Segura 💪',
      'qr': 'Acesso por código QR (Coach)', 'magical': 'Link mágico por E-mail',
      'morn': 'Bom dia, atleta! 🌅', 'aft': 'Boa tarde! Hora de treinar 🏋️', 'night': 'Boa noite! Feche com força 🌙'
    },
    'de': {
      'login': 'Einloggen', 'register': 'Registrieren', 'email': 'E-Mail-Adresse',
      'pass': 'Passwort', 'forget': 'Passwort vergessen?', 'remember': 'Angemeldet bleiben',
      'google': 'Mit Google fortfahren', 'apple': 'Mit Apple fortfahren', 'guest': 'Registrierung überspringen ➔',
      'noAccount': 'Kein Konto? Hier registrieren', 'hasAccount': 'Bereits ein Konto? Einloggen',
      'emailReq': 'E-Mail ist erforderlich', 'emailInv': 'Ungültiges E-Mail-Format',
      'passReq': 'Passwort ist erforderlich', 'passShort': 'Mindestens 6 Zeichen',
      'strength': 'Sicherheit: ', 'weak': 'Schwach 🛑', 'medium': 'Mittel ⚠️', 'strong': 'Sicher 💪',
      'qr': 'QR-Code-Zugang (Coach)', 'magical': 'Magischer E-Mail-Link',
      'morn': 'Guten Morgen, Athlet! 🌅', 'aft': 'Guten Tag! Zeit fürs Training 🏋️', 'night': 'Gute Nacht! Stark beenden 🌙'
    },
    'fr': {
      'login': 'Se connecter', 'register': 'S\'inscrire', 'email': 'Adresse e-mail',
      'pass': 'Mot de passe', 'forget': 'Mot de passe oublié?', 'remember': 'Se souvenir de moi',
      'google': 'Continuer avec Google', 'apple': 'Continuer with Apple', 'guest': 'Continuer sans inscription ➔',
      'noAccount': 'Pas de compte? Inscrivez-vous ici', 'hasAccount': 'Déjà un compte? Connectez-vous',
      'emailReq': 'L\'e-mail est obligatoire', 'emailInv': 'Format d\'e-mail invalide',
      'passReq': 'Le mot de passe est obligatoire', 'passShort': 'Minimum 6 caractères',
      'strength': 'Force: ', 'weak': 'Faible 🛑', 'medium': 'Moyenne ⚠️', 'strong': 'Sécurisé 💪',
      'qr': 'Accès par code QR (Coach)', 'magical': 'Lien magique par E-mail',
      'morn': 'Bonjours, athlète! 🌅', 'aft': 'Bon après-midi! Place à l\'entraînement 🏋️', 'night': 'Bonne nuit! Finissez en force 🌙'
    }
  };

  String _t(String clave) => _textos[idiomaActual]?[clave] ?? clave;
  @override
  void initState() {
    super.initState();
    // Configuración del motor de partículas lentas para el fondo dinámico
    _particulasController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _particulasController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Simulación del efecto Haptic Feedback (Vibración física)
  void _ejecutarVibracionHaptica() {
    // En un dispositivo real se llamaría a HapticFeedback.lightImpact();
  }

  // Calcula en tiempo real la fortaleza de la contraseña mientras el usuario escribe
  void _evaluarFortalezaContrasena(String pass) {
    if (pass.isEmpty) {
      setState(() {
        fortalezaContrasena = 0.0;
        textoFortaleza = '';
      });
      return;
    }

    double puntuacion = 0.0;
    if (pass.length >= 6) puntuacion += 0.3;
    if (pass.length >= 10) puntuacion += 0.2;
    if (pass.contains(RegExp(r'[A-Z]'))) puntuacion += 0.25;
    if (pass.contains(RegExp(r'[0-9]'))) puntuacion += 0.25;

    setState(() {
      fortalezaContrasena = puntuacion;
      if (puntuacion <= 0.3) {
        textoFortaleza = _t('weak');
        colorFortaleza = Colors.redAccent;
      } else if (puntuacion <= 0.6) {
        textoFortaleza = _t('medium');
        colorFortaleza = Colors.orangeAccent;
      } else {
        textoFortaleza = _t('strong');
        colorFortaleza = const Color(0xFFCCFF00);
      }
    });
  }

  // Determina el saludo según la hora actual del dispositivo
  String _obtenerSaludoHorario() {
    final hora = DateTime.now().hour;
    if (hora >= 6 && hora < 12) {
      return _t('morn');
    } else if (hora >= 12 && hora < 20) {
      return _t('aft');
    } else {
      return _t('night');
    }
  }

  // Validador seguro que verifica los campos y bloquea los clics dobles
  void _validarYEntrar() async {
    if (estaCargando) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      if (email.isEmpty) {
        errorEmail = _t('emailReq');
        _ejecutarVibracionHaptica();
      } else if (!emailRegex.hasMatch(email)) {
        errorEmail = _t('emailInv');
        _ejecutarVibracionHaptica();
      } else {
        errorEmail = null;
      }

      if (password.isEmpty) {
        errorPassword = _t('passReq');
        _ejecutarVibracionHaptica();
      } else if (password.length < 6) {
        errorPassword = _t('passShort');
        _ejecutarVibracionHaptica();
      } else {
        errorPassword = null;
      }
    });

    if (errorEmail == null && errorPassword == null && email.isNotEmpty && password.isNotEmpty) {
      setState(() => estaCargando = true); // Activa el Shimmer de carga
      
      // Simulamos la verificación rápida con la base de datos de la IA (Offline Grace Period activo)
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        setState(() => estaCargando = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // Calculamos el ancho de la pantalla para el diseño responsivo (Max-Width para Tablets)
    final anchoPantalla = MediaQuery.of(context).size.width;
    final esTablet = anchoPantalla > 600;

    return Scaffold(
      backgroundColor: Colors.black, // Modo Ultra Ahorro de Batería (OLED Pure Black)
      body: Stack(
        children: [
          // --- FONDO DINÁMICO ANIMADO DE PARTÍCULAS SUTILES ---
          AnimatedBuilder(
            animation: _particulasController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ParticulasPainter(
                  particulas: _particulas,
                  progreso: _particulasController.value,
                ),
              );
            },
          ),

          // --- INTERFAZ PRINCIPAL ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Container(
                  // Diseño Responsivo: Centra el inicio de sesión en una tarjeta flotante si es Tablet
                  constraints: BoxConstraints(maxWidth: esTablet ? 460 : double.infinity),
                  padding: EdgeInsets.all(esTablet ? 32.0 : 0),
                  decoration: esTablet ? BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10),
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5)],
                  ) : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- SELECTORES FLOTANTES DE IDIOMA (Efecto Cristal Esmerilado) ---
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: DropdownButton<String>(
                            value: idiomaActual,
                            underline: const SizedBox(),
                            dropdownColor: const Color(0xFF1E1E1E),
                            icon: const Icon(Icons.language, size: 18, color: Colors.grey),
                            items: const [
                              DropdownMenuItem(value: 'es', child: Text('ES ', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'en', child: Text('EN ', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'pt', child: Text('PT ', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'de', child: Text('DE ', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'fr', child: Text('FR ', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => idiomaActual = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- LOGO Y ENCABEZADO ---
                      const Text(
                        "🏋️ GymTechAI",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFFCCFF00)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        esRegistro ? _t('register') : _obtenerSaludoHorario(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 36),
                      // --- CAMPO: EMAIL CON AUTOCOMPLETADO NATIVO ---
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email], // Comunica al llavero del móvil
                        onChanged: (text) {
                          if (errorEmail != null) setState(() => errorEmail = null);
                        },
                        decoration: InputDecoration(
                          labelText: _t('email'),
                          errorText: errorEmail,
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- CAMPO: CONTRASEÑA INTELIGENTE ---
                      TextField(
                        controller: _passwordController,
                        obscureText: ocultarContrasena,
                        autofillHints: esRegistro ? null : const [AutofillHints.password],
                        onChanged: (text) {
                          if (errorPassword != null) setState(() => errorPassword = null);
                          if (esRegistro) _evaluarFortalezaContrasena(text); // Mide la fuerza si se registra
                        },
                        decoration: InputDecoration(
                          labelText: _t('pass'),
                          errorText: errorPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: Tooltip(
                            message: ocultarContrasena ? "Mostrar" : "Ocultar",
                            child: IconButton(
                              icon: Icon(ocultarContrasena ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                              onPressed: () => setState(() => ocultarContrasena = !ocultarContrasena),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // --- MEDIDOR VISUAL DE FORTALEZA (Solo visible en Modo Registro) ---
                      if (esRegistro && _passwordController.text.isNotEmpty) ...[
                        Row(
                          children: [
                            Text(_t('strength'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(textoFortaleza, style: TextStyle(fontSize: 12, color: colorFortaleza, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: fortalezaContrasena,
                          backgroundColor: Colors.white10,
                          color: colorFortaleza,
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // --- OPCIONES SECUNDARIAS: RECORDARME / OLVIDÉ CONTRASEÑA ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: recordarUsuario,
                                  activeColor: const Color(0xFFCCFF00),
                                  checkColor: Colors.black,
                                  onChanged: (val) {
                                    if (val != null) setState(() => recordarUsuario = val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(_t('remember'), style: const TextStyle(fontSize: 13, color: Colors.white70)),
                            ],
                          ),
                          if (!esRegistro)
                            TextButton(
                              onPressed: () {},
                              child: Text(_t('forget'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- BOTÓN PRINCIPAL DE ACCIÓN (Con Shimmer de Carga Activo) ---
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCCFF00),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: estaCargando ? null : _validarYEntrar, // Evita dobles clics
                          child: estaCargando
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                                )
                              : Text(
                                  esRegistro ? _t('register') : _t('login'),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BOTÓN PARA ALTERNAR MODOS (Login / Registro) ---
                      TextButton(
                        onPressed: () {
                          setState(() {
                            esRegistro = !esRegistro;
                            errorEmail = null;
                            errorPassword = null;
                          });
                        },
                        child: Text(
                          esRegistro ? _t('hasAccount') : _t('noAccount'),
                          style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- INTERFAZ ACCESO BIOMÉTRICO (Face ID / Huella) ---
                      if (!esRegistro) ...[
                        IconButton(
                          icon: const Icon(Icons.fingerprint, size: 40, color: Colors.white60),
                          tooltip: "Biometric Login",
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Face ID / Touch ID..."), backgroundColor: Colors.grey),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      // --- DIVISOR "O CONTINUAR CON" ---
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(_t('google').split(' ')[0] + "...", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                          const Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // --- BOTONES REDES SOCIALES ---
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: const BorderSide(color: Colors.white10)),
                                icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.white),
                                label: const Text("Google", style: TextStyle(color: Colors.white, fontSize: 14)),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: const BorderSide(color: Colors.white10)),
                                icon: const Icon(Icons.apple, size: 22, color: Colors.white),
                                label: const Text("Apple", style: TextStyle(color: Colors.white, fontSize: 14)),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- BOTÓN ACCESO INVITADO ---
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
                        },
                        child: Text(
                          _t('guest'),
                          style: const TextStyle(color: Colors.white54, fontSize: 13, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- PINTOR MATEMÁTICO: Dibuja y anima las partículas en el fondo OLED ---
class _ParticulasPainter extends CustomPainter {
  final List<math.Point> particulas;
  final double progreso;

  _ParticulasPainter({required this.particulas, required this.progreso});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCFF00).withOpacity(0.15) // Verde neón difuminado
      ..style = PaintingStyle.fill;

    for (var particula in particulas) {
      // Movimiento lento basado en el progreso de la animación
      double x = (particula.x * size.width + progreso * 20) % size.width;
      double y = (particula.y * size.height + progreso * 30) % size.height;

      canvas.drawCircle(Offset(x, y), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticulasPainter oldDelegate) => true;
}
