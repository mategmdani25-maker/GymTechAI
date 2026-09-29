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
import com.gymtechai.app.ui.CoachViewModel
import com.gymtechai.app.ui.RegisterViewModel
import com.gymtechai.app.ui.StatsViewModel
import com.gymtechai.app.ui.WorkoutViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppModule.initialize(this)
        setContent { GymTechApp() }
    }
}

@Composable
fun GymTechApp() {
    val authVm = AppModule.getAuthViewModel()
    val registerVm = AppModule.getRegisterViewModel()
    val workoutVm = AppModule.getWorkoutViewModel()
    val coachVm = AppModule.getCoachViewModel()
    val statsVm = AppModule.getStatsViewModel()

    val loggedIn by authVm.isLoggedIn.collectAsState()
    var currentScreen by remember { mutableStateOf(if (loggedIn) "home" else "login") }

    MaterialTheme(colorScheme = darkColorScheme()) {
        Scaffold(
            topBar = { TopAppBar(title = { Text("GymTechAI") }) }
        ) { padding ->
            Column(
                modifier = Modifier
                    .padding(padding)
                    .padding(16.dp)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                if (!loggedIn) {
                    if (currentScreen == "register") {
                        RegisterScreen(registerVm) {
                            currentScreen = "login"
                        }
                    } else {
                        LoginScreen(authVm) {
                            currentScreen = "home"
                        }
                    }
                } else {
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        listOf("home", "rutina", "coach", "stats").forEach { item ->
                            OutlinedButton(onClick = { currentScreen = item }) {
                                Text(item)
                            }
                        }
                        Button(onClick = { authVm.logout(); currentScreen = "login" }) {
                            Text("Logout")
                        }
                    }

                    when (currentScreen) {
                        "rutina" -> WorkoutScreen(workoutVm)
                        "coach" -> CoachScreen(coachVm)
                        "stats" -> StatsScreen(statsVm)
                        else -> HomeScreen()
                    }
                }
            }
        }
    }
}

@Composable
fun LoginScreen(vm: AuthViewModel, onLoginSuccess: () -> Unit) {
    val email by vm.email.collectAsState()
    val password by vm.password.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()
    val loggedIn by vm.isLoggedIn.collectAsState()

    LaunchedEffect(loggedIn) {
        if (loggedIn) onLoginSuccess()
    }

    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("Iniciar sesión", style = MaterialTheme.typography.headlineSmall)
        OutlinedTextField(value = email, onValueChange = { vm.setEmail(it) }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())
        OutlinedTextField(value = password, onValueChange = { vm.setPassword(it) }, label = { Text("Contraseña") }, modifier = Modifier.fillMaxWidth())
        if (!error.isNullOrEmpty()) {
            Text(error ?: "", color = MaterialTheme.colorScheme.error)
        }
        Button(onClick = { vm.login() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
            Text(if (isLoading) "Entrando..." else "Login")
        }
        TextButton(onClick = { /* navigation to register */ }) {
            Text("Crear cuenta")
        }
    }
}

@Composable
fun RegisterScreen(vm: RegisterViewModel, onRegistered: () -> Unit) {
    val nombre by vm.nombre.collectAsState()
    val email by vm.email.collectAsState()
    val password by vm.password.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()
    val registered by vm.registered.collectAsState()

    LaunchedEffect(registered) {
        if (registered) onRegistered()
    }

    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("Crear cuenta", style = MaterialTheme.typography.headlineSmall)
        OutlinedTextField(value = nombre, onValueChange = { vm.setNombre(it) }, label = { Text("Nombre") }, modifier = Modifier.fillMaxWidth())
        OutlinedTextField(value = email, onValueChange = { vm.setEmail(it) }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())
        OutlinedTextField(value = password, onValueChange = { vm.setPassword(it) }, label = { Text("Contraseña") }, modifier = Modifier.fillMaxWidth())
        if (!error.isNullOrEmpty()) {
            Text(error ?: "", color = MaterialTheme.colorScheme.error)
        }
        Button(onClick = { vm.register() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
            Text(if (isLoading) "Creando..." else "Registrarse")
        }
    }
}

@Composable
fun HomeScreen() {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("Bienvenido a GymTechAI", style = MaterialTheme.typography.headlineSmall)
        Text("Tu entrenador inteligente para fuerza, rutinas y progresión.")
        Text("• Genera rutinas")
        Text("• Consulta al Coach IA")
        Text("• Revisa tu progreso")
    }
}

@Composable
fun WorkoutScreen(vm: WorkoutViewModel) {
    val squat by vm.squat.collectAsState()
    val bench by vm.bench.collectAsState()
    val rdl by vm.rdl.collectAsState()
    val weeks by vm.weeks.collectAsState()
    val workout by vm.workout.collectAsState()
    val error by vm.error.collectAsState()
    val isLoading by vm.isLoading.collectAsState()

    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        item {
            Text("Generar macrociclo", style = MaterialTheme.typography.headlineSmall)
            OutlinedTextField(value = squat, onValueChange = { vm.setSquat(it) }, label = { Text("1RM Sentadilla") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = bench, onValueChange = { vm.setBench(it) }, label = { Text("1RM Press") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = rdl, onValueChange = { vm.setRdl(it) }, label = { Text("1RM RDL") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = weeks, onValueChange = { vm.setWeeks(it) }, label = { Text("Semanas") }, modifier = Modifier.fillMaxWidth())
            if (!error.isNullOrEmpty()) {
                Text(error ?: "", color = MaterialTheme.colorScheme.error)
            }
            Button(onClick = { vm.generateWorkout() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                Text(if (isLoading) "Generando..." else "Generar rutina")
            }
        }

        if (workout != null) {
            item {
                Text("Plan generado: ${workout!!.semanas_totales} semanas", style = MaterialTheme.typography.titleMedium)
            }
            items(workout!!.semanas) { item ->
                Card(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Text("Semana ${item.semana}: ${item.fase}")
                        Text("Porcentaje: ${item.porcentaje}%")
                        Text("Tonelaje: ${item.tonelaje_kg} kg")
                    }
                }
            }
        }
    }
}

@Composable
fun CoachScreen(vm: CoachViewModel) {
    val question by vm.question.collectAsState()
    val response by vm.response.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()

    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("Coach IA", style = MaterialTheme.typography.headlineSmall)
        OutlinedTextField(value = question, onValueChange = { vm.setQuestion(it) }, label = { Text("Pregunta") }, modifier = Modifier.fillMaxWidth())
        if (!error.isNullOrEmpty()) {
            Text(error ?: "", color = MaterialTheme.colorScheme.error)
        }
        Button(onClick = { vm.askCoach() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
            Text(if (isLoading) "Pensando..." else "Preguntar")
        }
        if (response.isNotEmpty()) {
            Card(modifier = Modifier.fillMaxWidth()) {
                Text(response, modifier = Modifier.padding(12.dp))
            }
        }
    }
}

@Composable
fun StatsScreen(vm: StatsViewModel) {
    val stats by vm.stats.collectAsState()
    val isLoading by vm.isLoading.collectAsState()

    LaunchedEffect(Unit) { vm.loadStats() }

    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("Estadísticas", style = MaterialTheme.typography.headlineSmall)
        if (isLoading) {
            Text("Cargando...")
        } else {
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text("Sesiones: ${stats["sesiones"] ?: 0}")
                    Text("Series: ${stats["series"] ?: 0}")
                    Text("Volumen: ${stats["volumen"] ?: 0} kg")
                }
            }
        }
    }
}
