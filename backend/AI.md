## Iteración 0.3

- Coach IA protegido por JWT.
- Integración opcional con OpenAI mediante `OPENAI_API_KEY` y `AI_MODEL`.
- Fallback local para desarrollo sin exponer secretos ni bloquear la aplicación.
- Explicación didáctica de ejercicios.
- Estadísticas de sesiones, series y volumen.

Variables opcionales:

```bash
export OPENAI_API_KEY='...'
export AI_MODEL='gpt-4o-mini'
export SECRET_KEY='cambia-esta-clave'
```

Sin `OPENAI_API_KEY`, el endpoint funciona con una respuesta educativa local.
