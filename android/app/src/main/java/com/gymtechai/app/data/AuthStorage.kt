package com.gymtechai.app.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "gymtechai_prefs")

class AuthStorage(private val context: Context) {
    private val tokenKey = stringPreferencesKey("jwt_token")
    private val emailKey = stringPreferencesKey("user_email")

    val tokenFlow: Flow<String?> = context.dataStore.data.map { prefs -> prefs[tokenKey] }
    val emailFlow: Flow<String?> = context.dataStore.data.map { prefs -> prefs[emailKey] }

    suspend fun saveToken(token: String, email: String) {
        context.dataStore.edit { prefs ->
            prefs[tokenKey] = token
            prefs[emailKey] = email
        }
    }

    suspend fun getToken(): String? = tokenFlow.first()

    suspend fun clear() {
        context.dataStore.edit { prefs ->
            prefs.remove(tokenKey)
            prefs.remove(emailKey)
        }
    }
}
