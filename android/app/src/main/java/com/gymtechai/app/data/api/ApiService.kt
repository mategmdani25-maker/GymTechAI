package com.gymtechai.app.data.api

import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST

interface ApiService {
    @POST("api/v1/auth/register")
    suspend fun register(@Body request: RegisterRequest): UserInfo

    @POST("api/v1/auth/login")
    suspend fun login(@Body request: LoginRequest): LoginResponse

    @POST("api/v1/workouts/generate")
    suspend fun generateWorkout(@Body request: WorkoutConfigRequest): WorkoutResponse

    @POST("api/v1/ai/coach")
    suspend fun askCoach(@Body request: CoachRequest): CoachResponse

    @GET("api/v1/tracking/stats")
    suspend fun getStats(): StatsResponse

    @POST("api/v1/bioregulation/check-in")
    suspend fun submitCheckIn(@Body request: CheckInRequest): Map<String, Any>

    @POST("api/v1/tracking/sessions")
    suspend fun saveSession(@Body request: SessionRequest): Map<String, Any>

    @GET("api/v1/tracking/sessions")
    suspend fun getSessions(): SessionResponse
}
