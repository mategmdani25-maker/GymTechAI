package com.gymtechai.app.data

import android.util.Log
import com.gymtechai.app.data.api.*
import kotlinx.coroutines.flow.first

class Repository(private val api: ApiService, private val storage: AuthStorage) {
    suspend fun register(email: String, password: String, nombre: String): Result<UserInfo> = try {
        Result.success(api.register(RegisterRequest(email, password, nombre)))
    } catch (e: Exception) {
        Log.e("Register", e.message ?: "Error")
        Result.failure(e)
    }

    suspend fun login(email: String, password: String): Result<UserInfo> = try {
        val response = api.login(LoginRequest(email, password))
        storage.saveToken(response.access_token, email)
        Result.success(UserInfo(1, email, "", "premium"))
    } catch (e: Exception) {
        Log.e("Login", e.message ?: "Error")
        Result.failure(e)
    }

    suspend fun logout() {
        storage.clear()
    }

    suspend fun generateWorkout(squat: Float, bench: Float, rdl: Float, weeks: Int): Result<WorkoutResponse> = try {
        val config = AthleteConfigRequest(rm_snt = squat, rm_bnc = bench, rm_rdl = rdl, semanas_totales = weeks)
        Result.success(api.generateWorkout(config))
    } catch (e: Exception) {
        Log.e("Workout", e.message ?: "Error")
        Result.failure(e)
    }

    suspend fun previewWorkout(squat: Float, bench: Float, rdl: Float, weeks: Int): Result<WorkoutResponse> = try {
        val config = AthleteConfigRequest(rm_snt = squat, rm_bnc = bench, rm_rdl = rdl, semanas_totales = weeks)
        Result.success(api.previewWorkout(config))
    } catch (e: Exception) {
        Log.e("Preview", e.message ?: "Error")
        Result.failure(e)
    }

    suspend fun askCoach(question: String): Result<CoachResponse> = try {
        Result.success(api.askCoach(CoachRequest(question)))
    } catch (e: Exception) {
        Log.e("Coach", e.message ?: "Error")
        Result.failure(e)
    }

    suspend fun getStats(): Result<StatsResponse> = try {
        Result.success(api.getStats())
    } catch (e: Exception) {
        Log.e("Stats", e.message ?: "Error")
        Result.failure(e)
    }

    suspend fun isLoggedIn(): Boolean = storage.token.first() != null
}
