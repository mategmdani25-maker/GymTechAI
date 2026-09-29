from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)

def test_ai_requires_authentication():
    response = client.post("/api/v1/ai/coach", json={"pregunta": "¿Cómo mejoro mi sentadilla?"})
    assert response.status_code == 401

def test_ai_local_fallback_with_auth():
    email = "ai-test@example.com"
    client.post("/api/v1/auth/register", json={"email": email, "password": "password123", "nombre": "AI Test"})
    token = client.post("/api/v1/auth/login", json={"email": email, "password": "password123"}).json()["access_token"]
    response = client.post("/api/v1/ai/coach", headers={"Authorization": f"Bearer {token}"}, json={"pregunta": "¿Cómo mejoro mi sentadilla?"})
    assert response.status_code == 200
    assert response.json()["fuente"] in {"local", "local-fallback", "openai"}
