package com.gymtechai.app.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.gymtechai.app.data.Repository
import com.gymtechai.app.data.api.WorkoutResponse
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class AuthViewModel(private val repo: Repository) : ViewModel() {
    private val _email = MutableStateFlow("")
    val email: StateFlow<String> = _email
    private val _password = MutableStateFlow("")
    val password: StateFlow<String> = _password
    private val _isLoading = MutableStateFlow(true)
    val isLoading: StateFlow<Boolean> = _isLoading
    private val _error = MutableStateFlow<String?>(null)
    val error: StateFlow<String?> = _error
    private val _isLoggedIn = MutableStateFlow(false)
    val isLoggedIn: StateFlow<Boolean> = _isLoggedIn

    init {
        viewModelScope.launch {
            _isLoggedIn.value = repo.isLoggedIn()
            _isLoading.value = false
        }
    }

    fun setEmail(value: String) { _email.value = value; _error.value = null }
    fun setPassword(value: String) { _password.value = value; _error.value = null }

    fun login() {
        if (_email.value.isBlank() || _password.value.isBlank()) {
            _error.value = "Introduce email y contraseña"
            return
        }
        viewModelScope.launch {
            _isLoading.value = true
            _error.value = null
            val result = repo.login(_email.value.trim(), _password.value)
            _isLoading.value = false
            result.onSuccess { _isLoggedIn.value = true }
                .onFailure { _error.value = it.message ?: "No se pudo iniciar sesión" }
        }
    }

    fun logout() {
        viewModelScope.launch {
            repo.logout()
            _isLoggedIn.value = false
            _email.value = ""
            _password.value = ""
        }
    }
}

class WorkoutViewModel(private val repo: Repository) : ViewModel() {
    private val _squat = MutableStateFlow("140"); val squat: StateFlow<String> = _squat
    private val _bench = MutableStateFlow("100"); val bench: StateFlow<String> = _bench
    private val _rdl = MutableStateFlow("150"); val rdl: StateFlow<String> = _rdl
    private val _weeks = MutableStateFlow("12"); val weeks: StateFlow<String> = _weeks
    private val _workout = MutableStateFlow<WorkoutResponse?>(null); val workout: StateFlow<WorkoutResponse?> = _workout
    private val _isLoading = MutableStateFlow(false); val isLoading: StateFlow<Boolean> = _isLoading
    private val _error = MutableStateFlow<String?>(null); val error: StateFlow<String?> = _error

    fun setSquat(value: String) { _squat.value = value }
    fun setBench(value: String) { _bench.value = value }
    fun setRdl(value: String) { _rdl.value = value }
    fun setWeeks(value: String) { _weeks.value = value }
    fun generateWorkout() {
        viewModelScope.launch {
            _isLoading.value = true; _error.value = null
            val result = repo.generateWorkout(_squat.value.toFloatOrNull() ?: 140f, _bench.value.toFloatOrNull() ?: 100f, _rdl.value.toFloatOrNull() ?: 150f, _weeks.value.toIntOrNull() ?: 12)
            _isLoading.value = false
            result.onSuccess { _workout.value = it }.onFailure { _error.value = it.message ?: "No se pudo generar la rutina" }
        }
    }
}

class CoachViewModel(private val repo: Repository) : ViewModel() {
    private val _question = MutableStateFlow(""); val question: StateFlow<String> = _question
    private val _response = MutableStateFlow(""); val response: StateFlow<String> = _response
    private val _isLoading = MutableStateFlow(false); val isLoading: StateFlow<Boolean> = _isLoading
    private val _error = MutableStateFlow<String?>(null); val error: StateFlow<String?> = _error
    fun setQuestion(value: String) { _question.value = value; _error.value = null }
    fun askCoach() {
        if (_question.value.isBlank()) { _error.value = "Escribe una pregunta"; return }
        viewModelScope.launch {
            _isLoading.value = true; _error.value = null
            val result = repo.askCoach(_question.value.trim()); _isLoading.value = false
            result.onSuccess { _response.value = it.respuesta }.onFailure { _error.value = it.message ?: "No se pudo consultar el coach" }
        }
    }
}

class StatsViewModel(private val repo: Repository) : ViewModel() {
    private val _stats = MutableStateFlow<Map<String, Any>>(emptyMap()); val stats: StateFlow<Map<String, Any>> = _stats
    private val _isLoading = MutableStateFlow(false); val isLoading: StateFlow<Boolean> = _isLoading
    fun loadStats() {
        viewModelScope.launch {
            _isLoading.value = true
            repo.getStats().onSuccess { _stats.value = mapOf("sesiones" to it.sesiones_totales, "series" to it.series_totales, "volumen" to it.volumen_kg) }
            _isLoading.value = false
        }
    }
}
