package com.gymtechai.app.data

import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.map

private val Context.dataStore by preferencesDataStore(name = "auth_prefs")

class AuthStorage(private val context: Context) {
    companion object {
        private val TOKEN_KEY = stringPreferencesKey("access_token")
        private val EMAIL_KEY = stringPreferencesKey("email")
    }

    val token = context.dataStore.data.map { it[TOKEN_KEY] }
    val email = context.dataStore.data.map { it[EMAIL_KEY] }

    suspend fun saveToken(token: String, email: String) {
        context.dataStore.edit {
            it[TOKEN_KEY] = token
            it[EMAIL_KEY] = email
        }
    }

    suspend fun clear() {
        context.dataStore.edit { it.clear() }
    }
}
