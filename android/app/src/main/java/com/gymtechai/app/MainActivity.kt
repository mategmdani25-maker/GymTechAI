package com.gymtechai.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { GymTechAIApp() }
    }
}

@Composable
private fun GymTechAIApp() {
    var screen by remember { mutableStateOf("Inicio") }
    MaterialTheme(colorScheme = darkColorScheme()) {
        Scaffold(topBar = { TopAppBar(title = { Text("🏋️ GymTechAI") }) }) { padding ->
            Column(Modifier.padding(padding).padding(16.dp)) {
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf("Inicio", "Rutina", "Coach IA").forEach { item ->
                        OutlinedButton(onClick = { screen = item }) { Text(item) }
                    }
                }
                Spacer(Modifier.height(20.dp))
                when (screen) {
                    "Rutina" -> WorkoutScreen()
                    "Coach IA" -> CoachScreen()
                    else -> HomeScreen()
                }
            }
        }
    }
}

@Composable private fun HomeScreen() {
    Text("Tu entrenamiento inteligente", style = MaterialTheme.typography.headlineSmall)
    Spacer(Modifier.height(12.dp))
    Text("Conecta esta app con el backend para generar macrociclos, registrar sesiones y adaptar tus cargas.")
}

@Composable private fun WorkoutScreen() {
    var squat by remember { mutableStateOf("140") }
    var weeks by remember { mutableStateOf("12") }
    Text("Generar macrociclo", style = MaterialTheme.typography.headlineSmall)
    OutlinedTextField(squat, { squat = it }, label = { Text("1RM sentadilla") })
    OutlinedTextField(weeks, { weeks = it }, label = { Text("Semanas") })
    Spacer(Modifier.height(8.dp))
    Button(onClick = { }) { Text("Generar rutina") }
    Spacer(Modifier.height(16.dp))
    Text("La generación se conectará a POST /api/v1/workouts/preview.")
}

@Composable private fun CoachScreen() {
    var question by remember { mutableStateOf("") }
    Text("Coach IA", style = MaterialTheme.typography.headlineSmall)
    OutlinedTextField(question, { question = it }, label = { Text("¿Qué quieres aprender?") }, modifier = Modifier.fillMaxWidth())
    Spacer(Modifier.height(8.dp))
    Button(onClick = { }) { Text("Preguntar") }
    Spacer(Modifier.height(12.dp))
    Text("El coach responderá mediante POST /api/v1/ai/coach.")
}
