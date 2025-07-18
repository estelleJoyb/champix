from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models.mushroom_model import MushroomCreate, MushroomOut
from app.controllers.mushroom_controller import get_mushrooms, get_mushrooms_by_id, create_mushroom, update_mushroom, delete_mushroom
from app.database import get_db
from app.auth.auth_controller import get_current_user

router = APIRouter()

@router.get("/", response_model=list[MushroomOut])
def list_mushrooms(db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    return get_mushrooms(db)

@router.get("/{mushroom_id}", response_model=MushroomOut)
def mushrooms_id_data(mushroom_id: int, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    mushroom = get_mushrooms_by_id(db, mushroom_id)
    if not mushroom:
        raise HTTPException(status_code=404, detail="Mushroom not found")
    return mushroom

@router.post("/", response_model=MushroomOut)
def add_mushroom(mushroom: MushroomCreate, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    return create_mushroom(mushroom, db)

@router.put("/{mushroom_id}", response_model=MushroomOut)
def modify_mushroom(mushroom_id: int, mushroom: MushroomCreate, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    updated = update_mushroom(mushroom_id, mushroom, db)
    if not updated:
        raise HTTPException(status_code=404, detail="Mushroom not found")
    return updated

@router.delete("/{mushroom_id}", response_model=dict)
def remove_mushroom(mushroom_id: int, db: Session = Depends(get_db), current_user: str = Depends(get_current_user)):
    deleted = delete_mushroom(mushroom_id, db)
    if not deleted:
        raise HTTPException(status_code=404, detail="Mushroom not found")
    return {"message": "Mushroom deleted successfully"}
