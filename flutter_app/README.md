# GymTechAI Flutter

Cliente multiplataforma para Android, iOS y web. Usa el backend FastAPI existente.

## Preparar el proyecto

Si Flutter aún no ha generado las carpetas de plataforma, ejecuta desde `flutter_app/`:

```bash
flutter create .
flutter pub get
flutter config --enable-web
```

## Ejecutar

Con el backend arrancado en `backend/`:

```bash
flutter run -d chrome
```

Para Android emulator:

```bash
flutter run -d emulator
```

La aplicación usa automáticamente:

- Web/Chrome: `http://localhost:8000`
- Android emulator: `http://10.0.2.2:8000`

Para un teléfono físico, cambia `baseUrl` en `lib/services/api_service.dart` por la IP local del ordenador, por ejemplo `http://192.168.1.20:8000`.

## Funciones incluidas

- Login y registro
- Persistencia del JWT
- Dashboard
- Generación de rutinas
- Check-in diario
- Coach IA
- Estadísticas

El backend debe permitir el origen del navegador. El backend actual ya configura CORS para desarrollo.
