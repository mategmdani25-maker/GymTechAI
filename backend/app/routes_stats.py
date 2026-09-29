from fastapi import APIRouter, Depends
from sqlalchemy import desc, func, select
from sqlalchemy.orm import Session

from .database import current_user_id, get_db
from .models import TrainingSession

router = APIRouter(prefix="/api/v1/tracking", tags=["progreso"])

@router.get("/stats")
def stats(user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    sessions = db.scalars(select(TrainingSession).where(TrainingSession.user_id == user_id).order_by(desc(TrainingSession.fecha))).all()
    total_sets = sum(len(session.sets or []) for session in sessions)
    volume = sum(float(item.get("peso_kg", 0)) * int(item.get("reps", 0)) for session in sessions for item in (session.sets or []))
    return {"sesiones_totales": len(sessions), "series_totales": total_sets, "volumen_kg": round(volume, 2), "ultima_sesion": sessions[0].fecha if sessions else None}
