package com.gymtechai.app.data.api

import com.google.gson.annotations.SerializedName

data class RegisterRequest(
    val email: String,
    val password: String,
    val nombre: String,
    val tipo_usuario: String = "gratis"
)

data class LoginRequest(
    val email: String,
    val password: String
)

data class LoginResponse(
    val access_token: String,
    val token_type: String,
    val user: UserInfo?
)

data class UserInfo(
    val id: Int,
    val email: String,
    val nombre: String,
    val tipo_usuario: String
)

data class WorkoutConfigRequest(
    val tipo_usuario: String = "premium",
    val semanas_totales: Int = 12,
    val rm_snt: Float,
    val reps_snt: Int = 1,
    val rm_bnc: Float,
    val reps_bnc: Int = 1,
    val rm_rdl: Float,
    val reps_rdl: Int = 1,
    val ej_snt: String = "Sentadilla",
    val ej_bnc: String = "Press banca",
    val ej_rdl: String = "Peso muerto rumano"
)

data class WeekData(
    val semana: Int,
    val fase: String,
    val porcentaje: Float,
    val tonelaje_kg: Int,
    val lunes: DayData,
    val miercoles: DayData
)

data class DayData(
    val dia_nombre: String,
    val nota_general: String,
    val ejercicios: List<ExerciseData> = emptyList()
)

data class ExerciseData(
    val nombre: String,
    val peso_kg: Float,
    val estrategia: String,
    val discos_por_lado: String,
    val calentamiento: String
)

data class WorkoutResponse(
    val id: Int = 0,
    val semanas_totales: Int,
    @SerializedName("1rm_estimados") val estimados1RM: Map<String, Float>,
    val semanas: List<WeekData>
)

data class CoachRequest(
    val pregunta: String
)

data class CoachResponse(
    val respuesta: String,
    val fuente: String,
    val advertencia: String? = null
)

data class StatsResponse(
    val sesiones_totales: Int,
    val series_totales: Int,
    val volumen_kg: Float,
    val ultima_sesion: String? = null
)

data class CheckInRequest(
    val peso_ejercicio_hoy: Float,
    val nivel_energia: Int,
    val nivel_dolor: Int,
    val estado_bio: String,
    val salto_minimo: Float = 2.5f
)

data class CheckInResponse(
    val id: Int,
    val peso_ajustado_kg: Float,
    val estado: String,
    val energia: Int,
    val dolor: Int
)

data class SessionSetRequest(
    val ejercicio: String,
    val peso_kg: Float,
    val reps: Int,
    val rpe: Float? = null
)

data class SessionRequest(
    val fecha: String,
    val sets: List<SessionSetRequest>
)

data class SessionItem(
    val id: Int,
    val fecha: String,
    val sets: List<SessionSetRequest>
)

data class SessionResponse(
    val items: List<SessionItem>
)
