import hashlib
import hmac
import os

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..database import create_token, get_db
from ..models import User
from ..schemas import LoginRequest, RegisterRequest

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])

def hash_password(password: str) -> str:
    salt = os.urandom(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 120_000)
    return f"{salt.hex()}${digest.hex()}"

def verify_password(password: str, encoded: str) -> bool:
    try:
        salt_hex, digest_hex = encoded.split("$", 1)
        digest = hashlib.pbkdf2_hmac("sha256", password.encode(), bytes.fromhex(salt_hex), 120_000)
        return hmac.compare_digest(digest.hex(), digest_hex)
    except (ValueError, TypeError):
        return False

@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(data: RegisterRequest, db: Session = Depends(get_db)):
    if db.scalar(select(User).where(User.email == data.email.lower())):
        raise HTTPException(status_code=409, detail="El email ya está registrado")
    user = User(email=data.email.lower(), nombre=data.nombre, tipo_usuario=data.tipo_usuario, password_hash=hash_password(data.password))
    db.add(user); db.commit(); db.refresh(user)
    return {"id": user.id, "email": user.email, "nombre": user.nombre, "tipo_usuario": user.tipo_usuario}

@router.post("/login")
def login(data: LoginRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == data.email.lower()))
    if not user or not verify_password(data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Credenciales incorrectas")
    return {"access_token": create_token(user.id), "token_type": "bearer", "user": {"id": user.id, "email": user.email, "nombre": user.nombre, "tipo_usuario": user.tipo_usuario}}
