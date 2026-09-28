from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, ConfigDict, EmailStr, Field

class AthleteConfig(BaseModel):
    model_config = ConfigDict(validate_assignment=True)
    tipo_usuario: str = Field("premium", pattern="^(gratis|premium|entrenador)$")
    semanas_totales: int = Field(12, ge=4, le=52)
    rm_snt: float = Field(..., gt=0); reps_snt: int = Field(1, ge=1, le=20)
    rm_bnc: float = Field(..., gt=0); reps_bnc: int = Field(1, ge=1, le=20)
    rm_rdl: float = Field(..., gt=0); reps_rdl: int = Field(1, ge=1, le=20)
    ej_snt: str = Field("Sentadilla", min_length=1, max_length=100)
    ej_bnc: str = Field("Press banca", min_length=1, max_length=100)
    ej_rdl: str = Field("Peso muerto rumano", min_length=1, max_length=100)
    accesorios: dict[str, str] = Field(default_factory=dict)
    salto_minimo_barra: float = Field(2.5, gt=0, le=20)
    usar_top_sets: bool = True
    usar_backoff: bool = True
    usar_singles: bool = False
    usar_amraps: bool = False
    usar_clusters: bool = False
    cluster_bloque_reps: int = Field(2, ge=1, le=5)

class CheckIn(BaseModel):
    peso_ejercicio_hoy: float = Field(..., gt=0)
    nivel_energia: int = Field(..., ge=1, le=5)
    nivel_dolor: int = Field(..., ge=0, le=5)
    estado_bio: str = Field("normal", min_length=1, max_length=40)
    salto_minimo: float = Field(2.5, gt=0, le=20)

class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8, max_length=128)
    nombre: str = Field(..., min_length=2, max_length=120)
    tipo_usuario: str = Field("gratis", pattern="^(gratis|premium|entrenador)$")

class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=1, max_length=128)

class SetRecord(BaseModel):
    ejercicio: str = Field(..., min_length=1, max_length=100)
    peso_kg: float = Field(..., ge=0)
    reps: int = Field(..., ge=0, le=100)
    rpe: Optional[float] = Field(None, ge=1, le=10)

class WorkoutSession(BaseModel):
    fecha: datetime
    sets: List[SetRecord] = Field(..., min_length=1)
