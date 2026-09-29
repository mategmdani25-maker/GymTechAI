package com.gymtechai.app.data

import android.util.Log
import com.gymtechai.app.data.api.*
import kotlinx.coroutines.flow.first

class GymTechRepository(
    private val api: ApiService,
    private val authStorage: AuthStorage
) {
    suspend fun register(email: String, password: String, nombre: String): Result<UserInfo> = try {
        val response = api.register(RegisterRequest(email, password, nombre, "gratis"))
        Result.success(response)
    } catch (e: Exception) {
        Log.e("Repository", "register error", e)
        Result.failure(e)
    }

    suspend fun login(email: String, password: String): Result<LoginResponse> = try {
        val response = api.login(LoginRequest(email, password))
        authStorage.saveToken(response.access_token, email)
        Result.success(response)
    } catch (e: Exception) {
        Log.e("Repository", "login error", e)
        Result.failure(e)
    }

    suspend fun logout() {
        authStorage.clear()
    }

    suspend fun isLoggedIn(): Boolean {
        return !authStorage.getToken().isNullOrBlank()
    }

    suspend fun generateWorkout(
        squat: Float,
        bench: Float,
        rdl: Float,
        weeks: Int
    ): Result<WorkoutResponse> = try {
        val config = WorkoutConfigRequest(
            tipo_usuario = "premium",
            semanas_totales = weeks,
            rm_snt = squat,
            rm_bnc = bench,
            rm_rdl = rdl
        )
        Result.success(api.generateWorkout(config))
    } catch (e: Exception) {
        Log.e("Repository", "generateWorkout error", e)
        Result.failure(e)
    }

    suspend fun askCoach(question: String): Result<CoachResponse> = try {
        Result.success(api.askCoach(CoachRequest(question)))
    } catch (e: Exception) {
        Log.e("Repository", "askCoach error", e)
        Result.failure(e)
    }

    suspend fun getStats(): Result<StatsResponse> = try {
        Result.success(api.getStats())
    } catch (e: Exception) {
        Log.e("Repository", "getStats error", e)
        Result.failure(e)
    }
}
