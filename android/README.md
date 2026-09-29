# Cliente Android inicial

Abre `android/` con Android Studio Hedgehog o posterior.

La app incluye una primera navegación Compose con las pantallas Inicio, Rutina y Coach IA. El backend local puede apuntarse desde el cliente Retrofit usando:

- Emulador Android: `http://10.0.2.2:8000/`
- Dispositivo físico: `http://IP_DE_TU_PC:8000/`

Siguiente integración: Retrofit, almacenamiento del JWT y conexión real de los botones con `/api/v1/auth`, `/api/v1/workouts/preview` y `/api/v1/ai/coach`.
