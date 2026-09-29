from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

from .database import Base, engine
from .routes_auth import router as auth_router
from .routes_data import router as data_router
from .routes_bio import router as bio_router
from .routes_ai import router as ai_router
from .routes_stats import router as stats_router
from .schemas import AthleteConfig, CheckIn
from .periodization import generate_macrocycle, autoregulate

Base.metadata.create_all(bind=engine)
app = FastAPI(title="GymTechAI API", version="0.3.0", description="Entrenamiento, IA, progreso y biorregulación para GymTechAI")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=False, allow_methods=["*"], allow_headers=["*"])
app.include_router(auth_router)
app.include_router(data_router)
app.include_router(bio_router)
app.include_router(ai_router)
app.include_router(stats_router)

@app.get("/health")
def health():
    return {"status": "healthy", "version": app.version, "database": "sqlite/postgresql", "ai": "openai-or-local-fallback"}

@app.post("/api/v1/workouts/preview", tags=["workouts"])
def preview(config: AthleteConfig):
    return generate_macrocycle(config)

@app.post("/api/v1/bioregulation/preview", tags=["bioregulación"])
def preview_check_in(check: CheckIn):
    return autoregulate(check)

app.mount("/dashboard", StaticFiles(directory="dashboard", html=True), name="dashboard")

@app.get("/", include_in_schema=False)
def root():
    return FileResponse("dashboard/index.html")
