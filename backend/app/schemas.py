from typing import Dict, Optional
from pydantic import BaseModel, Field, field_validator

class AthleteConfig(BaseModel):
    tipo_usuario: str = Field("premium", pattern="^(gratis|premium|entrenador)$")
    semanas_totales: int = Field(12, ge=4, le=52)
    rm_snt: float = Field(..., gt=0); reps_snt: int = Field(1, ge=1, le=20)
    rm_bnc: float = Field(..., gt=0); reps_bnc: int = Field(1, ge=1, le=20)
    rm_rdl: float = Field(..., gt=0); reps_rdl: int = Field(1, ge=1, le=20)
    ej_snt: str = "Sentadilla"
    ej_bnc: str = "Press banca"
    ej_rdl: str = "Peso muerto rumano"
    accesorios: Dict[str, str] = {}
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
    estado_bio: str = "normal"
    salto_minimo: float = Field(2.5, gt=0, le=20)
