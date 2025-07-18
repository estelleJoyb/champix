from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models.mushroom_model import Mushroom, MushroomCreate
from app.controllers.mushroom_controller import get_mushrooms, create_mushroom, update_mushroom, delete_mushroom
from app.database import get_db
from app.auth.auth_controller import get_current_user

router = APIRouter()

@router.get("/", response_model=list[Mushroom])
def list_mushrooms(db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    return get_mushrooms(db)

@router.post("/", response_model=Mushroom)
def add_mushroom(mushroom: MushroomCreate, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    return create_mushroom(mushroom, db)

@router.put("/{mushroom_id}", response_model=Mushroom)
def modify_mushroom(mushroom_id: int, mushroom: MushroomCreate, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    updated_mushroom = update_mushroom(mushroom_id, mushroom, db)
    if not updated_mushroom:
        raise HTTPException(status_code=404, detail="Mushroom not found")
    return updated_mushroom

@router.delete("/{mushroom_id}", response_model=dict)
def remove_mushroom(mushroom_id: int, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    result = delete_mushroom(mushroom_id, db)
    if not result:
        raise HTTPException(status_code=404, detail="Mushroom not found")
    return {"message": "Mushroom deleted successfully"}