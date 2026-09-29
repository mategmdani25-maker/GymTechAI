package com.gymtechai.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import com.gymtechai.app.ui.AuthViewModel
import com.gymtechai.app.ui.CheckInViewModel
import com.gymtechai.app.ui.CoachViewModel
import com.gymtechai.app.ui.RegisterViewModel
import com.gymtechai.app.ui.SessionViewModel
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
    val checkInVm = AppModule.getCheckInViewModel()
    val sessionVm = AppModule.getSessionViewModel()

    val loggedIn by authVm.isLoggedIn.collectAsState()
    var selectedTab by remember { mutableStateOf("home") }
    var showRegister by remember { mutableStateOf(false) }

    MaterialTheme(colorScheme = darkColorScheme()) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("GymTechAI") },
                    colors = TopAppBarDefaults.topAppBarColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
                )
            },
            bottomBar = {
                if (loggedIn) {
                    NavigationBar {
                        listOf(
                            "home" to "Inicio",
                            "rutina" to "Rutina",
                            "checkin" to "Check-in",
                            "coach" to "Coach",
                            "stats" to "Stats"
                        ).forEach { (key, label) ->
                            NavigationBarItem(
                                selected = selectedTab == key,
                                onClick = { selectedTab = key },
                                icon = { },
                                label = { Text(label) }
                            )
                        }
                    }
                }
            }
        ) { padding ->
            Column(
                modifier = Modifier
                    .padding(padding)
                    .padding(16.dp)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                if (!loggedIn) {
                    if (showRegister) {
                        RegisterScreen(
                            vm = registerVm,
                            onRegistered = { showRegister = false },
                            onBackToLogin = { showRegister = false }
                        )
                    } else {
                        LoginScreen(
                            vm = authVm,
                            onLoginSuccess = { selectedTab = "home" },
                            onRegisterClick = { showRegister = true }
                        )
                    }
                } else {
                    when (selectedTab) {
                        "rutina" -> WorkoutScreen(workoutVm)
                        "checkin" -> CheckInScreen(checkInVm)
                        "coach" -> CoachScreen(coachVm)
                        "stats" -> StatsScreen(statsVm)
                        "home" -> DashboardScreen(sessionVm, statsVm)
                        else -> DashboardScreen(sessionVm, statsVm)
                    }

                    Spacer(modifier = Modifier.height(8.dp))
                    Button(
                        onClick = { authVm.logout(); selectedTab = "home" },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Cerrar sesión")
                    }
                }
            }
        }
    }
}

@Composable
fun LoginScreen(vm: AuthViewModel, onLoginSuccess: () -> Unit, onRegisterClick: () -> Unit) {
    val email by vm.email.collectAsState()
    val password by vm.password.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()
    val loggedIn by vm.isLoggedIn.collectAsState()

    LaunchedEffect(loggedIn) {
        if (loggedIn) onLoginSuccess()
    }

    Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text("Iniciar sesión", style = MaterialTheme.typography.headlineSmall)
            OutlinedTextField(value = email, onValueChange = { vm.setEmail(it) }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = password, onValueChange = { vm.setPassword(it) }, label = { Text("Contraseña") }, modifier = Modifier.fillMaxWidth(), visualTransformation = PasswordVisualTransformation())
            if (!error.isNullOrEmpty()) Text(error ?: "", color = MaterialTheme.colorScheme.error)
            Button(onClick = { vm.login() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                Text(if (isLoading) "Entrando..." else "Login")
            }
            TextButton(onClick = onRegisterClick, modifier = Modifier.align(Alignment.CenterHorizontally)) {
                Text("Crear cuenta")
            }
        }
    }
}

@Composable
fun RegisterScreen(vm: RegisterViewModel, onRegistered: () -> Unit, onBackToLogin: () -> Unit) {
    val nombre by vm.nombre.collectAsState()
    val email by vm.email.collectAsState()
    val password by vm.password.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()
    val registered by vm.registered.collectAsState()

    LaunchedEffect(registered) {
        if (registered) onRegistered()
    }

    Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text("Crear cuenta", style = MaterialTheme.typography.headlineSmall)
            OutlinedTextField(value = nombre, onValueChange = { vm.setNombre(it) }, label = { Text("Nombre") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = email, onValueChange = { vm.setEmail(it) }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = password, onValueChange = { vm.setPassword(it) }, label = { Text("Contraseña") }, modifier = Modifier.fillMaxWidth(), visualTransformation = PasswordVisualTransformation())
            if (!error.isNullOrEmpty()) Text(error ?: "", color = MaterialTheme.colorScheme.error)
            Button(onClick = { vm.register() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                Text(if (isLoading) "Creando..." else "Registrarse")
            }
            TextButton(onClick = onBackToLogin, modifier = Modifier.align(Alignment.CenterHorizontally)) {
                Text("Ya tengo cuenta")
            }
        }
    }
}

@Composable
fun DashboardScreen(sessionVm: SessionViewModel, statsVm: StatsViewModel) {
    val sessions by sessionVm.sessions.collectAsState()
    val stats by statsVm.stats.collectAsState()
    val isLoading by sessionVm.isLoading.collectAsState()

    LaunchedEffect(Unit) {
        sessionVm.loadSessions()
        statsVm.loadStats()
    }

    LazyColumn(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        item {
            Text("Resumen", style = MaterialTheme.typography.headlineSmall)
        }
        item {
            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                val cards = listOf(
                    "Sesiones" to (stats["sesiones"] ?: 0),
                    "Series" to (stats["series"] ?: 0),
                    "Volumen" to (stats["volumen"] ?: 0)
                )
                cards.forEach { (label, value) ->
                    Card(modifier = Modifier.weight(1f), shape = RoundedCornerShape(16.dp)) {
                        Column(modifier = Modifier.padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                            Text(label, style = MaterialTheme.typography.labelMedium)
                            Text(value.toString(), style = MaterialTheme.typography.titleMedium)
                        }
                    }
                }
            }
        }
        item {
            Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text("Últimas sesiones", style = MaterialTheme.typography.titleMedium)
                    if (isLoading) Text("Cargando...")
                    else if (sessions.isEmpty()) Text("Todavía no hay sesiones registradas")
                    else {
                        sessions.take(3).forEach { session ->
                            Text("• ${session.fecha} · ${session.sets.size} series")
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun CheckInScreen(vm: CheckInViewModel) {
    val peso by vm.peso.collectAsState()
    val energia by vm.energia.collectAsState()
    val dolor by vm.dolor.collectAsState()
    val estado by vm.estado.collectAsState()
    val isLoading by vm.isLoading.collectAsState()
    val error by vm.error.collectAsState()
    val success by vm.success.collectAsState()

    Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Text("Check-in diario", style = MaterialTheme.typography.headlineSmall)
            OutlinedTextField(value = peso, onValueChange = { vm.setPeso(it) }, label = { Text("Peso actual (kg)") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = energia, onValueChange = { vm.setEnergia(it) }, label = { Text("Energía (1-5)") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = dolor, onValueChange = { vm.setDolor(it) }, label = { Text("Dolor (0-5)") }, modifier = Modifier.fillMaxWidth())
            OutlinedTextField(value = estado, onValueChange = { vm.setEstado(it) }, label = { Text("Estado") }, modifier = Modifier.fillMaxWidth())
            if (!error.isNullOrEmpty()) Text(error ?: "", color = MaterialTheme.colorScheme.error)
            if (success) Text("Check-in registrado correctamente", color = MaterialTheme.colorScheme.primary)
            Button(onClick = { vm.submit() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                Text(if (isLoading) "Guardando..." else "Guardar check-in")
            }
        }
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

    LazyColumn(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        item {
            Text("Generar macrociclo", style = MaterialTheme.typography.headlineSmall)
        }
        item {
            Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    OutlinedTextField(value = squat, onValueChange = { vm.setSquat(it) }, label = { Text("1RM Sentadilla") }, modifier = Modifier.fillMaxWidth())
                    OutlinedTextField(value = bench, onValueChange = { vm.setBench(it) }, label = { Text("1RM Press") }, modifier = Modifier.fillMaxWidth())
                    OutlinedTextField(value = rdl, onValueChange = { vm.setRdl(it) }, label = { Text("1RM RDL") }, modifier = Modifier.fillMaxWidth())
                    OutlinedTextField(value = weeks, onValueChange = { vm.setWeeks(it) }, label = { Text("Semanas") }, modifier = Modifier.fillMaxWidth())
                    if (!error.isNullOrEmpty()) Text(error ?: "", color = MaterialTheme.colorScheme.error)
                    Button(onClick = { vm.generateWorkout() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                        Text(if (isLoading) "Generando..." else "Generar rutina")
                    }
                }
            }
        }

        if (workout != null) {
            item {
                Text("Plan generado: ${workout!!.semanas_totales} semanas", style = MaterialTheme.typography.titleMedium)
            }
            items(workout!!.semanas) { item ->
                Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
                    Column(modifier = Modifier.padding(12.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
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

    Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Text("Coach IA", style = MaterialTheme.typography.headlineSmall)
            OutlinedTextField(value = question, onValueChange = { vm.setQuestion(it) }, label = { Text("Pregunta") }, modifier = Modifier.fillMaxWidth())
            if (!error.isNullOrEmpty()) Text(error ?: "", color = MaterialTheme.colorScheme.error)
            Button(onClick = { vm.askCoach() }, enabled = !isLoading, modifier = Modifier.fillMaxWidth()) {
                Text(if (isLoading) "Pensando..." else "Preguntar")
            }
            if (response.isNotEmpty()) {
                Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(12.dp)) {
                    Text(response, modifier = Modifier.padding(12.dp))
                }
            }
        }
    }
}

@Composable
fun StatsScreen(vm: StatsViewModel) {
    val stats by vm.stats.collectAsState()
    val isLoading by vm.isLoading.collectAsState()

    LaunchedEffect(Unit) { vm.loadStats() }

    Card(modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(18.dp)) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Text("Estadísticas", style = MaterialTheme.typography.headlineSmall)
            if (isLoading) Text("Cargando...")
            else {
                Text("Sesiones: ${stats["sesiones"] ?: 0}")
                Text("Series: ${stats["series"] ?: 0}")
                Text("Volumen: ${stats["volumen"] ?: 0} kg")
            }
        }
    }
}
