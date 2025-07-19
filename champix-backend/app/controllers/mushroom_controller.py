from sqlalchemy.orm import Session
from app.models.mushroom_model import Mushroom as MushroomModel, MushroomCreate

def get_mushrooms(db: Session):
    return db.query(MushroomModel).all()

def get_mushrooms_by_id(db: Session, id):
    return db.query(MushroomModel).filter(MushroomModel.id == id).first()

def create_mushroom(mushroom: MushroomCreate, db: Session):
    db_mushroom = MushroomModel(**mushroom.dict())
    db.add(db_mushroom)
    db.commit()
    db.refresh(db_mushroom)
    return db_mushroom

def update_mushroom(mushroom_id: int, mushroom: MushroomCreate, db: Session):
    db_mushroom = db.query(MushroomModel).filter(MushroomModel.id == mushroom_id).first()
    if not db_mushroom:
        return None
    for field, value in mushroom.dict().items():
        setattr(db_mushroom, field, value)
    db.commit()
    db.refresh(db_mushroom)
    return db_mushroom

def delete_mushroom(mushroom_id: int, db: Session):
    db_mushroom = db.query(MushroomModel).filter(MushroomModel.id == mushroom_id).first()
    if not db_mushroom:
        return False
    db.delete(db_mushroom)
    db.commit()
    return True
