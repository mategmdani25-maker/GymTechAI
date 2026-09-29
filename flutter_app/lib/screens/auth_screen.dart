import 'package:flutter/material.dart';
import 'questionnaire_screen.dart'; // Enlazado para el siguiente paso

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool esRegistro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo de GymTechAI
              const Text(
                "🏋️ GymTechAI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFFCCFF00)),
              ),
              const SizedBox(height: 8),
              Text(
                esRegistro ? "Crea tu cuenta inteligente" : "Bienvenido de nuevo a tus entrenamientos",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // Campo de Correo Electrónico
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Contraseña
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              
              // Botón de "¿Olvidaste tu contraseña?" (Solo visible si no es registro)
              if (!esRegistro)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Acción simulada para recuperar contraseña
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              
              SizedBox(height: esRegistro ? 32 : 16),

              // Botón Principal
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
                    );
                  },
                  child: Text(
                    esRegistro ? "Registrarse" : "Iniciar Sesión",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Alternar entre Login y Registro
              TextButton(
                onPressed: () {
                  setState(() {
                    esRegistro = !esRegistro;
                  });
                },
                child: Text(
                  esRegistro ? "¿Ya tienes cuenta? Inicia Sesión" : "¿No tienes cuenta? Regístrate aquí",
                  style: const TextStyle(color: Color(0xFFCCFF00)),
                ),
              ),
              const SizedBox(height: 24),

              // Divisor visual "O continuar con"
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("O continuar con", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                ],
              ),
              const SizedBox(height: 24),

              // Botones de Redes Sociales (Google y Apple)
              Row(
                children: [
                  // Botón Google
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),
                        label: const Text("Google", style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botón Apple
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        icon: const Icon(Icons.apple, size: 24, color: Colors.white),
                        label: const Text("Apple", style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
