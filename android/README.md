# GymTechAI Android

Este proyecto Android se conecta con el backend en:

```txt
http://10.0.2.2:8000/
```

## Requisitos

- Android Studio
- Java 17
- Android SDK 35

## Ejecutar

1. Abre la carpeta `android/` en Android Studio.
2. Sincroniza Gradle.
3. Ejecuta la app en un emulador.

## Backend requerido

Debe estar arrancado antes de usar la app:

```bash
cd backend
source .venv/bin/activate
uvicorn app.main:app --reload
```

## Funcionalidades

- Login y registro
- Persistencia del JWT
- Generación de la rutina
- Coach IA
- Estadísticas de progreso
