package com.gymtechai.app

import android.content.Context
import com.gymtechai.app.data.AuthStorage
import com.gymtechai.app.data.Repository
import com.gymtechai.app.data.api.ApiService
import com.gymtechai.app.data.api.AuthInterceptor
import com.gymtechai.app.ui.AuthViewModel
import com.gymtechai.app.ui.CoachViewModel
import com.gymtechai.app.ui.StatsViewModel
import com.gymtechai.app.ui.WorkoutViewModel
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.flow.first
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object AppModule {
    private lateinit var repo: Repository
    private lateinit var authVM: AuthViewModel
    private lateinit var workoutVM: WorkoutViewModel
    private lateinit var coachVM: CoachViewModel
    private lateinit var statsVM: StatsViewModel

    fun initialize(context: Context) {
        val storage = AuthStorage(context.applicationContext)
        val client = OkHttpClient.Builder()
            .addInterceptor(HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BASIC))
            .addInterceptor(AuthInterceptor { runBlocking { storage.token.first() } })
            .build()
        val retrofit = Retrofit.Builder()
            .baseUrl("http://10.0.2.2:8000/")
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        val api = retrofit.create(ApiService::class.java)
        repo = Repository(api, storage)
        authVM = AuthViewModel(repo)
        workoutVM = WorkoutViewModel(repo)
        coachVM = CoachViewModel(repo)
        statsVM = StatsViewModel(repo)
    }

    fun getAuthViewModel() = authVM
    fun getWorkoutViewModel() = workoutVM
    fun getCoachViewModel() = coachVM
    fun getStatsViewModel() = statsVM
}
