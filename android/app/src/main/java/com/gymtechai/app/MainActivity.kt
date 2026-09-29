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
import com.gymtechai.app.ui.AuthViewModel
import com.gymtechai.app.ui.WorkoutViewModel
import com.gymtechai.app.ui.CoachViewModel
import com.gymtechai.app.ui.StatsViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppModule.initialize(this)
        setContent { GymTechAIApp() }
    }
}

@Composable
private fun GymTechAIApp() {
    val authVM = AppModule.getAuthViewModel()
    val isLoggedIn by authVM.isLoggedIn.collectAsState()
    val screen = remember { mutableStateOf(if (isLoggedIn) "Home" else "Login") }

    MaterialTheme(colorScheme = darkColorScheme()) {
        Scaffold(topBar = { TopAppBar(title = { Text("🏋️ GymTechAI") }) }) { padding ->
            Column(Modifier.padding(padding).padding(16.dp)) {
                when {
                    !isLoggedIn -> LoginScreen(authVM) { screen.value = "Home" }
                    else -> {
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            listOf("Home", "Rutina", "Coach IA", "Stats").forEach { item ->
                                OutlinedButton(onClick = { screen.value = item }) { Text(item) }
                            }
                            Button(onClick = { authVM.logout(); screen.value = "Login" }) { Text("Logout") }
                        }
                        Spacer(Modifier.height(20.dp))
                        when (screen.value) {
                            "Rutina" -> WorkoutScreen(AppModule.getWorkoutViewModel())
                            "Coach IA" -> CoachScreen(AppModule.getCoachViewModel())
                            "Stats" -> StatsScreen(AppModule.getStatsViewModel())
                            else -> HomeScreen()
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun LoginScreen(vm: AuthViewModel, onLoginSuccess: () -> Unit) {
    val email by vm.email.collectAsState()
    val password by vm.password.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()
    val isLoggedIn by vm.isLoggedIn.collectAsState()

    LaunchedEffect(isLoggedIn) { if (isLoggedIn) onLoginSuccess() }

    Column(Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("Iniciar sesión", style = MaterialTheme.typography.headlineSmall)
        OutlinedTextField(email, { vm.setEmail(it) }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())
        OutlinedTextField(password, { vm.setPassword(it) }, label = { Text("Contraseña") }, modifier = Modifier.fillMaxWidth())
        if (error != null) Text(error ?: "", color = MaterialTheme.colorScheme.error)
        Button(onClick = { vm.login() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
            Text(if (isLoading) "Cargando..." else "Login")
        }
    }
}

@Composable
private fun HomeScreen() {
    Text("Bienvenido a GymTechAI", style = MaterialTheme.typography.headlineSmall)
    Spacer(Modifier.height(12.dp))
    Text("✓ Autenticación conectada")
    Text("✓ Generación de rutinas")
    Text("✓ Coach IA")
    Text("✓ Seguimiento de progreso")
}

@Composable
private fun WorkoutScreen(vm: WorkoutViewModel) {
    val squat by vm.squat.collectAsState()
    val bench by vm.bench.collectAsState()
    val rdl by vm.rdl.collectAsState()
    val weeks by vm.weeks.collectAsState()
    val workout by vm.workout.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()

    LazyColumn(Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
        item {
            Text("Generar Macrociclo", style = MaterialTheme.typography.headlineSmall)
            OutlinedTextField(squat, { vm.setSquat(it) }, label = { Text("1RM Sentadilla (kg)") })
            OutlinedTextField(bench, { vm.setBench(it) }, label = { Text("1RM Banca (kg)") })
            OutlinedTextField(rdl, { vm.setRdl(it) }, label = { Text("1RM RDL (kg)") })
            OutlinedTextField(weeks, { vm.setWeeks(it) }, label = { Text("Semanas") })
            Button(onClick = { vm.generateWorkout() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                Text(if (isLoading) "Generando..." else "Generar")
            }
            if (error != null) Text(error ?: "", color = MaterialTheme.colorScheme.error)
        }
        if (workout != null) {
            item {
                Text("${workout!!.semanas_totales} semanas | Tonelaje variable", style = MaterialTheme.typography.bodySmall)
            }
            items(workout!!.semanas) { week ->
                Card(Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(12.dp)) {
                        Text("Semana ${week.semana}: ${week.fase}", style = MaterialTheme.typography.bodyMedium)
                        Text("${week.porcentaje.toInt()}% | ${week.tonelaje_kg} kg movidos", style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
        }
    }
}

@Composable
private fun CoachScreen(vm: CoachViewModel) {
    val question by vm.question.collectAsState()
    val response by vm.response.collectAsState()
    val isLoading by vm.isLoading.collectAsState()

    Column(Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("Coach IA", style = MaterialTheme.typography.headlineSmall)
        OutlinedTextField(question, { vm.setQuestion(it) }, label = { Text("¿Qué quieres aprender?") }, modifier = Modifier.fillMaxWidth())
        Button(onClick = { vm.askCoach() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
            Text(if (isLoading) "Pensando..." else "Preguntar")
        }
        if (response.isNotEmpty()) {
            Card(Modifier.fillMaxWidth()) {
                Text(response, Modifier.padding(12.dp), style = MaterialTheme.typography.bodySmall)
            }
        }
    }
}

@Composable
private fun StatsScreen(vm: StatsViewModel) {
    val stats by vm.stats.collectAsState()
    val isLoading by vm.isLoading.collectAsState()

    LaunchedEffect(Unit) { vm.loadStats() }

    if (isLoading) {
        Text("Cargando...")
    } else {
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Text("Tu Progreso", style = MaterialTheme.typography.headlineSmall)
            Card(Modifier.fillMaxWidth()) {
                Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text("Sesiones: ${stats["sesiones"] ?: 0}")
                    Text("Series totales: ${stats["series"] ?: 0}")
                    Text("Volumen: ${stats["volumen"] ?: 0} kg")
                }
            }
        }
    }
}
