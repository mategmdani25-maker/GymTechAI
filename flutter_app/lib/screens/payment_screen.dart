import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Enlazado para el Paso 4 (La Pantalla Principal)

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _codigoController = TextEditingController();
  bool codigoAplicado = false;
  String precioPremium = "24,99€";

  void _aplicarCodigo() {
    if (_codigoController.text.isNotEmpty) {
      setState(() {
        codigoAplicado = true;
        precioPremium = "19,99€"; // Aplica el 20% de descuento (5€ menos)
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Código aplicado con éxito! Has ahorrado un 20% (5€)."),
          backgroundColor: Color(0xFFCCFF00),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suscripción", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Desbloquea GymTechAI",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Únete al entrenamiento inteligente con periodización matemática.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // CAMPO DE CÓDIGO DE REFERIDO / DESCUENTO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: codigoAplicado ? const Color(0xFFCCFF00) : Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("¿Tienes un código de referido o descuento?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codigoController,
                          enabled: !codigoAplicado,
                          decoration: InputDecoration(
                            hintText: "Ej. MATE25",
                            filled: true,
                            fillColor: Colors.black25,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: codigoAplicado ? Colors.grey : const Color(0xFFCCFF00),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: codigoAplicado ? null : _aplicarCodigo,
                        child: Text(codigoAplicado ? "Aplicado" : "Aplicar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // PLAN 1: GRATIS
            _buildPlanCard(
              titulo: "Plan Básico Gratis",
              precio: "0€",
              periodo: "/ siempre",
              colorBorde: Colors.white12,
              beneficios: [
                "Rutinas base (Top-Set / Back-Off)",
                "Intercambio manual de ejercicios",
                "Calculadora de 1RM integrada",
                "Registro de marcas e historial básico"
              ],
              textoBoton: "Continuar Gratis",
              esDestacado: false,
            ),
            const SizedBox(height: 16),

            // PLAN 2: PREMIUM (ATLETAS) - PRECIO DINÁMICO
            _buildPlanCard(
              titulo: "Premium AI Athlete 🧠⚡",
              precio: precioPremium,
              periodo: "/ mes",
              colorBorde: const Color(0xFFCCFF00),
              beneficios: [
                "Todo lo del Plan Gratis",
                "Check-In Diario de Fatiga (Sueño/Estrés)",
                "Autorregulación por IA en tiempo real",
                "Optimización por Ciclo Menstrual",
                "Gráficos avanzados de Volumen y Tonelaje",
                if (codigoAplicado) "Descuento del 20% activo de por vida"
              ],
              textoBoton: "Probar Premium AI",
              esDestacado: true,
            ),
            const SizedBox(height: 16),

            // PLAN 3: PLAN COACH (ENTRENADORES)
            _buildPlanCard(
              titulo: "GymTech Coach Pro 📋👨‍🏋️",
              precio: "49,99€",
              periodo: "/ mes",
              colorBorde: Colors.cyan,
              beneficios: [
                "Panel Multi-Cliente (Gestión de atletas)",
                "Asignación de rutinas con IA a tus alumnos",
                "Monitorización de fatiga y tonelaje del equipo",
                "Exportación de datos e informes de rendimiento"
              ],
              textoBoton: "Activar Cuenta Coach",
              esDestacado: false,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String titulo,
    required String precio,
    required String periodo,
    required Color colorBorde,
    required List<String> beneficios,
    required String textoBoton,
    required bool esDestacado,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorBorde, width: esDestacado ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (esDestacado)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFCCFF00), borderRadius: BorderRadius.circular(8)),
                child: const Text("RECOMENDADO", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          Text(titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: esDestacado ? const Color(0xFFCCFF00) : Colors.white)),
          const SizedBox(height: 8),
          Row(
            alignment: PlaceholderAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(precio, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text(periodo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const Divider(height: 24, color: Colors.white10),
          ...beneficios.map((beneficio) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 18, color: esDestacado ? const Color(0xFFCCFF00) : Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(beneficio, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: esDestacado ? const Color(0xFFCCFF00) : Colors.white10,
                foregroundColor: esDestacado ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: Text(textoBoton, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
