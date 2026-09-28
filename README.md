# GymTechAI

MVP del backend y dashboard visual para probar la progresión del motor de periodización.

## Ejecutar

```bash
cd backend
python -m venv .venv
# Linux/macOS: source .venv/bin/activate
# Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

- Dashboard: http://localhost:8000/
- Swagger: http://localhost:8000/docs
- Health: http://localhost:8000/health

El dashboard genera un macrociclo, muestra intensidad y tonelaje por semana y permite inspeccionar cada día. Esta primera iteración no guarda datos todavía; después añadiremos autenticación y base de datos.
