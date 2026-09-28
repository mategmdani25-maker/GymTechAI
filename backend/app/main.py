from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from .schemas import AthleteConfig, CheckIn
from .periodization import generate_macrocycle, autoregulate

app = FastAPI(title="GymTechAI API", version="0.1.0", description="Motor de entrenamiento y biorregulación para GymTechAI")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=False, allow_methods=["*"], allow_headers=["*"])

@app.get("/health")
def health():
    return {"status": "healthy", "version": app.version}

@app.post("/api/v1/workouts/generate")
def generate(config: AthleteConfig):
    return generate_macrocycle(config)

@app.post("/api/v1/bioregulation/check-in")
def check_in(check: CheckIn):
    return autoregulate(check)

app.mount("/dashboard", StaticFiles(directory="dashboard", html=True), name="dashboard")

@app.get("/", include_in_schema=False)
def root():
    return FileResponse("dashboard/index.html")
