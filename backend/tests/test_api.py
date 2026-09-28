import os
from fastapi.testclient import TestClient

os.environ["DATABASE_URL"] = "sqlite:///./test_gymai.db"
from app.main import app

client = TestClient(app)

CONFIG = {"tipo_usuario":"premium","semanas_totales":12,"rm_snt":140,"reps_snt":1,"rm_bnc":100,"reps_bnc":1,"rm_rdl":150,"reps_rdl":1}

def auth_headers():
    email = "test@example.com"
    client.post("/api/v1/auth/register", json={"email":email,"password":"password123","nombre":"Test User"})
    response = client.post("/api/v1/auth/login", json={"email":email,"password":"password123"})
    return {"Authorization": f"Bearer {response.json()['access_token']}"}

def test_preview_generates_12_weeks():
    response = client.post("/api/v1/workouts/preview", json=CONFIG)
    assert response.status_code == 200
    assert len(response.json()["semanas"]) == 12

def test_authenticated_workout_is_persisted():
    headers = auth_headers()
    response = client.post("/api/v1/workouts/generate", json=CONFIG, headers=headers)
    assert response.status_code == 200
    assert response.json()["id"] > 0
    listing = client.get("/api/v1/workouts", headers=headers)
    assert len(listing.json()["items"]) >= 1
