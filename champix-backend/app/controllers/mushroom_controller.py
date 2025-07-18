from app.models.mushroom_model import Mushroom, MushroomCreate

db = []

def get_mushrooms() -> list[Mushroom]:
    return db

def create_mushroom(mushroom: MushroomCreate) -> Mushroom:
    new_mushroom = Mushroom(id=len(db)+1, **mushroom.dict())
    db.append(new_mushroom)
    return new_mushroom

def get_mushroom(mushroom_id: int) -> Mushroom:
    for mushroom in db:
        if mushroom.id == mushroom_id:
            return mushroom
    return None

def update_mushroom(mushroom_id: int, mushroom: MushroomCreate) -> Mushroom:
    for index, existing_mushroom in enumerate(db):
        if existing_mushroom.id == mushroom_id:
            updated_mushroom = Mushroom(id=mushroom_id, **mushroom.dict())
            db[index] = updated_mushroom
            return updated_mushroom
    return None

def delete_mushroom(mushroom_id: int) -> bool:
    global db
    db = [mushroom for mushroom in db if mushroom.id != mushroom_id]
    return True if len(db) < len(db) else False