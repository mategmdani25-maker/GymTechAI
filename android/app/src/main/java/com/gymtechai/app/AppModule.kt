package com.gymtechai.app

import android.content.Context
import com.gymtechai.app.data.AuthStorage
import com.gymtechai.app.data.GymTechRepository
import com.gymtechai.app.data.api.ApiService
import com.gymtechai.app.data.api.AuthInterceptor
import com.gymtechai.app.ui.AuthViewModel
import com.gymtechai.app.ui.CheckInViewModel
import com.gymtechai.app.ui.CoachViewModel
import com.gymtechai.app.ui.RegisterViewModel
import com.gymtechai.app.ui.SessionViewModel
import com.gymtechai.app.ui.StatsViewModel
import com.gymtechai.app.ui.WorkoutViewModel
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object AppModule {
    private lateinit var repository: GymTechRepository
    private lateinit var authViewModel: AuthViewModel
    private lateinit var registerViewModel: RegisterViewModel
    private lateinit var workoutViewModel: WorkoutViewModel
    private lateinit var coachViewModel: CoachViewModel
    private lateinit var statsViewModel: StatsViewModel
    private lateinit var checkInViewModel: CheckInViewModel
    private lateinit var sessionViewModel: SessionViewModel

    fun initialize(context: Context) {
        val storage = AuthStorage(context.applicationContext)
        val client = OkHttpClient.Builder()
            .addInterceptor(HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BASIC))
            .addInterceptor(AuthInterceptor { kotlinx.coroutines.runBlocking { storage.getToken() } })
            .build()

        val retrofit = Retrofit.Builder()
            .baseUrl("http://10.0.2.2:8000/")
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        val api = retrofit.create(ApiService::class.java)
        repository = GymTechRepository(api, storage)
        authViewModel = AuthViewModel(repository)
        registerViewModel = RegisterViewModel(repository)
        workoutViewModel = WorkoutViewModel(repository)
        coachViewModel = CoachViewModel(repository)
        statsViewModel = StatsViewModel(repository)
        checkInViewModel = CheckInViewModel(repository)
        sessionViewModel = SessionViewModel(repository)
    }

    fun getAuthViewModel(): AuthViewModel = authViewModel
    fun getRegisterViewModel(): RegisterViewModel = registerViewModel
    fun getWorkoutViewModel(): WorkoutViewModel = workoutViewModel
    fun getCoachViewModel(): CoachViewModel = coachViewModel
    fun getStatsViewModel(): StatsViewModel = statsViewModel
    fun getCheckInViewModel(): CheckInViewModel = checkInViewModel
    fun getSessionViewModel(): SessionViewModel = sessionViewModel
}
