from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from .database import current_user_id, get_db
from .models import CheckInRecord
from .periodization import autoregulate
from .schemas import CheckIn

router = APIRouter(prefix="/api/v1/bioregulation", tags=["bioregulación"])

@router.post("/check-in")
def check_in_and_save(check: CheckIn, user_id: int = Depends(current_user_id), db: Session = Depends(get_db)):
    result = autoregulate(check)
    row = CheckInRecord(user_id=user_id, energia=check.nivel_energia, dolor=check.nivel_dolor, peso_original=check.peso_ejercicio_hoy, peso_ajustado=result["peso_ajustado_kg"], estado=check.estado_bio)
    db.add(row); db.commit(); db.refresh(row)
    return {"id": row.id, **result}
