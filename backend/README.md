# GymTechAI backend

## Nuevas funciones

- SQLite por defecto y PostgreSQL mediante `DATABASE_URL`.
- Registro e inicio de sesión con tokens JWT.
- Macrociclos persistidos por usuario.
- Registro e historial de sesiones.
- Check-ins de biorregulación guardados.
- Endpoints `preview` sin autenticación para probar el cálculo en Swagger/dashboard.

```bash
cd backend
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

- Dashboard: http://localhost:8000/
- Swagger: http://localhost:8000/docs
- Tests: `pytest tests -q`

Para producción define una clave secreta real:

```bash
export SECRET_KEY='una-clave-larga-y-aleatoria'
```
