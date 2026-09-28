from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import desc, select
from sqlalchemy.orm import Session

from .database import current_user_id, get_db
from .models import TrainingSession, Workout
from .periodization import generate_macrocycle
from .schemas import AthleteConfig, WorkoutSession

router = APIRouter(prefix="/api/v1", tags=["persistencia"])

@router.post("/workouts/generate")
def generate_and_save(config: AthleteConfig, user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    result = generate_macrocycle(config)
    workout = Workout(user_id=user_id, name=f"Macrociclo de {result['semanas_totales']} semanas", payload=result)
    db.add(workout); db.commit(); db.refresh(workout)
    return {"id": workout.id, **result}

@router.get("/workouts")
def list_workouts(user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    rows = db.scalars(select(Workout).where(Workout.user_id == user_id).order_by(desc(Workout.created_at))).all()
    return {"items": [{"id": w.id, "name": w.name, "created_at": w.created_at, "semanas_totales": w.payload.get("semanas_totales")} for w in rows]}

@router.get("/workouts/{workout_id}")
def get_workout(workout_id: int, user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    workout = db.scalar(select(Workout).where(Workout.id == workout_id, Workout.user_id == user_id))
    if not workout: raise HTTPException(status_code=404, detail="Rutina no encontrada")
    return {"id": workout.id, **workout.payload}

@router.post("/tracking/sessions", status_code=201)
def record_session(data: WorkoutSession, user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    session = TrainingSession(user_id=user_id, fecha=data.fecha, sets=[s.model_dump() for s in data.sets])
    db.add(session); db.commit(); db.refresh(session)
    return {"id": session.id, "message": "Sesión registrada", "fecha": session.fecha}

@router.get("/tracking/sessions")
def list_sessions(user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    rows = db.scalars(select(TrainingSession).where(TrainingSession.user_id == user_id).order_by(desc(TrainingSession.fecha))).all()
    return {"items": [{"id": s.id, "fecha": s.fecha, "sets": s.sets} for s in rows]}
