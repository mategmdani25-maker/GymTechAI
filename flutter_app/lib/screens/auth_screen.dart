import 'package:flutter/material.dart';
import 'questionnaire_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AlphaScreenState extends State<AuthScreen> {
  bool esRegistro = false;
  bool ocultarContrasena = true;

  // Controladores para leer el texto de las cajas
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Mensajes de error en rojo
  String? errorEmail;
  String? errorPassword;

  // FUNCIÓN INTELIGENTE: Calcula el saludo de bienvenida según la hora real del dispositivo
  String _obtenerSaludoDinamico() {
    final hora = DateTime.now().hour;
    if (hora >= 6 && hora < 12) {
      return "¡Buenos días, atleta! 🌅";
    } else if (hora >= 12 && hora < 20) {
      return "¡Buenas tardes! A por el entrenamiento 🏋️";
    } else {
      return "¡Buenas noches! Cerremos el día con fuerza 🌙";
    }
  }

  // Función que valida el correo y la contraseña antes de avanzar
  void _validarYEntrar() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      if (email.isEmpty) {
        errorEmail = "El correo electrónico es obligatorio";
      } else if (!emailRegex.hasMatch(email)) {
        errorEmail = "Introduce un formato de correo válido (ej. nombre@web.com)";
      } else {
        errorEmail = null;
      }

      if (password.isEmpty) {
        errorPassword = "La contraseña es obligatoria";
      } else if (password.length < 6) {
        errorPassword = "La contraseña debe tener al menos 6 caracteres";
      } else {
        errorPassword = null;
      }
    });

    if (errorEmail == null && errorPassword == null && email.isNotEmpty && password.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              // LOGO DE GYMTECHAI
              const Text(
                "🏋️ GymTechAI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFFCCFF00)),
              ),
              const SizedBox(height: 12),
              // MEJORA: TEXTO DINÁMICO QUE CAMBIA SEGÚN EL MOMENTO DEL DÍA
              Text(
                esRegistro ? "Crea tu cuenta inteligente" : _obtenerSaludoDinamico(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              // CAMPO DE EMAIL CON VALIDADOR DE FORMATO AUTOMÁTICO
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  errorText: errorEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // CAMPO DE CONTRASEÑA CON CONTROL DE LONGITUD MÍNIMA (6 CARACTERES)
              TextField(
                controller: _passwordController,
                obscureText: ocultarContrasena,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  errorText: errorPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(ocultarContrasena ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => ocultarContrasena = !ocultarContrasena),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              
              if (!esRegistro)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("¿Olvidaste tu contraseña?", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ),
              
              SizedBox(height: esRegistro ? 32 : 16),

              // BOTÓN DE ACCIÓN QUE ACTIVA LA VERIFICACIÓN SEGURA
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _validarYEntrar,
                  child: Text(
                    esRegistro ? "Registrarse" : "Iniciar Sesión",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () => setState(() => esRegistro = !esRegistro),
                child: Text(
                  esRegistro ? "¿Ya tienes cuenta? Inicia Sesión" : "¿No tienes cuenta? Regístrate aquí",
                  style: const TextStyle(color: Color(0xFFCCFF00)),
                ),
              ),
              const SizedBox(height: 16),

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("O continuar con", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                ],
              ),
              const SizedBox(height: 16),

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

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
                },
                child: const Text(
                  "Saltar registro y continuar como invitado ➔",
                  style: TextStyle(color: Colors.white54, fontSize: 13, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
