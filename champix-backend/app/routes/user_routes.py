from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.controllers import user_controller
from app.models.user_model import User, UserCreate, UserUpdate
from app.database import get_db
from app.auth.auth_controller import get_current_user

router = APIRouter()

@router.get("/", response_model=list[User])
def list_users(db: Session = Depends(get_db)):
    return user_controller.get_users(db)

@router.post("/", response_model=User)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    return user_controller.create_user(user, db)
    
@router.get("/{user_id}", response_model=User)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = user_controller.get_user(user_id, db)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.put("/{user_id}", response_model=User)
def update_user(user_id: int, user: UserUpdate, db: Session = Depends(get_db)):
    updated_user = user_controller.update_user(user_id, user, db)
    if updated_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return updated_user

@router.delete("/{user_id}", response_model=User)
def delete_user(user_id: int, db: Session = Depends(get_db)):
    deleted_user = user_controller.delete_user(user_id, db)
    if deleted_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return deleted_user