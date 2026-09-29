package com.gymtechai.app.data.api

import retrofit2.http.*

interface ApiService {
    @POST("api/v1/auth/register")
    suspend fun register(@Body request: RegisterRequest): UserInfo

    @POST("api/v1/auth/login")
    suspend fun login(@Body request: LoginRequest): LoginResponse

    @POST("api/v1/workouts/generate")
    suspend fun generateWorkout(@Body config: AthleteConfigRequest): WorkoutResponse

    @POST("api/v1/workouts/preview")
    suspend fun previewWorkout(@Body config: AthleteConfigRequest): WorkoutResponse

    @GET("api/v1/workouts")
    suspend fun listWorkouts(): Map<String, List<Any>>

    @GET("api/v1/workouts/{id}")
    suspend fun getWorkout(@Path("id") id: Int): WorkoutResponse

    @POST("api/v1/ai/coach")
    suspend fun askCoach(@Body request: CoachRequest): CoachResponse

    @GET("api/v1/tracking/stats")
    suspend fun getStats(): StatsResponse

    @POST("api/v1/bioregulation/check-in")
    suspend fun checkIn(@Body data: Map<String, Any>): Map<String, Any>
}
