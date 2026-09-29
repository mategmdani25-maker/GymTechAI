from typing import Any, Optional

from pydantic import BaseModel, Field

class ExerciseExplanationRequest(BaseModel):
    nombre_ejercicio: str = Field(..., min_length=2, max_length=100)
    nivel_usuario: str = Field("intermedio", min_length=2, max_length=30)
    objetivo: str = Field("fuerza e hipertrofia", min_length=2, max_length=100)

class CoachRequest(BaseModel):
    pregunta: str = Field(..., min_length=2, max_length=2000)
    contexto_entrenamiento: Optional[dict[str, Any]] = None

class AIResponse(BaseModel):
    respuesta: str
    fuente: str
    advertencia: Optional[str] = None
