from fastapi import APIRouter, Depends

from .ai_service import ask_ai, explain_exercise
from .database import current_user_id
from .schemas_ai import AIResponse, CoachRequest, ExerciseExplanationRequest

router = APIRouter(prefix="/api/v1/ai", tags=["IA Coach"])

@router.post("/explicar-ejercicio", response_model=AIResponse)
async def explain(request: ExerciseExplanationRequest, _: int = Depends(current_user_id)):
    response, source = await explain_exercise(request.nombre_ejercicio, request.nivel_usuario, request.objetivo)
    return {"respuesta": response, "fuente": source, "advertencia": "La información es educativa y no sustituye valoración profesional."}

@router.post("/coach", response_model=AIResponse)
async def coach(request: CoachRequest, user_id: int = Depends(current_user_id)):
    response, source = await ask_ai(request.pregunta, request.contexto_entrenamiento)
    return {"respuesta": response, "fuente": source, "advertencia": "Ante dolor agudo, detén el ejercicio y consulta a un profesional."}
