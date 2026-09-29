import os
from typing import Any

import httpx

SYSTEM_PROMPT = (
    "Eres GymTechAI Coach, un asistente educativo de entrenamiento de fuerza. "
    "Responde en español, sé claro y didáctico. No diagnostiques lesiones ni sustituyas "
    "a un médico o entrenador cualificado. Si aparece dolor agudo, recomienda detenerse "
    "y consultar a un profesional."
)

async def ask_ai(user_prompt: str, context: dict[str, Any] | None = None) -> tuple[str, str]:
    """Consulta un proveedor opcional; devuelve una respuesta local si no hay API key."""
    api_key = os.getenv("OPENAI_API_KEY")
    model = os.getenv("AI_MODEL", "gpt-4o-mini")
    if not api_key:
        return local_response(user_prompt), "local"

    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"Contexto: {context or {}}\nPregunta: {user_prompt}"},
        ],
        "temperature": 0.3,
        "max_tokens": 700,
    }
    headers = {"Authorization": f"Bearer {api_key}"}
    try:
        async with httpx.AsyncClient(timeout=20) as client:
            response = await client.post("https://api.openai.com/v1/chat/completions", json=payload, headers=headers)
            response.raise_for_status()
            content = response.json()["choices"][0]["message"]["content"]
            return content, "openai"
    except (httpx.HTTPError, KeyError, IndexError, TypeError):
        return local_response(user_prompt), "local-fallback"

def local_response(prompt: str) -> str:
    return (
        "Puedo ayudarte con técnica, calentamiento, progresión y recuperación. "
        f"Sobre tu consulta ({prompt[:120]}), empieza con una carga controlable, "
        "mantén 1–3 repeticiones en reserva y registra peso, repeticiones y RPE. "
        "Si notas dolor agudo o pérdida de técnica, detén la serie."
    )

async def explain_exercise(name: str, level: str, goal: str) -> tuple[str, str]:
    prompt = f"Explica {name} para nivel {level} y objetivo {goal}. Incluye pasos, respiración, errores comunes y regresiones."
    return await ask_ai(prompt)
