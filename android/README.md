# Cliente Android completamente integrado

## Características

- ✅ Login/Logout con JWT
- ✅ Almacenamiento de token en DataStore
- ✅ Generación de macrociclos con persistencia
- ✅ Coach IA con respuestas en tiempo real
- ✅ Estadísticas de progreso
- ✅ Retrofit + OkHttp para HTTP
- ✅ MVVM con ViewModels
- ✅ Jetpack Compose UI moderna

## Configuración

### URL del backend

Edita `AppModule.kt`:

```kotlin
.baseUrl("http://10.0.2.2:8000/")  // Emulador
// o
.baseUrl("http://TU_IP:8000/")     // Dispositivo físico
```

### Compilar y ejecutar

```bash
cd android
./gradlew assembleDebug
./gradlew installDebug
```

O desde Android Studio:

1. Sincroniza Gradle.
2. Haz clic en **Run** > **Run 'app'**.

## Flujo de usuario

1. **Login**: Email y contraseña (crea cuenta si no existe).
2. **Home**: Menú con Rutina, Coach IA y Estadísticas.
3. **Rutina**: Ingresa 1RM y genera macrociclo de 4-52 semanas.
4. **Coach**: Haz preguntas sobre técnica y recuperación.
5. **Stats**: Ve sesiones, series y volumen total.

## Backend requerido

Asegúrate de que el backend está ejecutándose:

```bash
cd backend
uvicorn app.main:app --reload
```

La app se conectará automáticamente.
