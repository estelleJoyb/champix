from pydantic import BaseModel

class MushroomCreate(BaseModel):
    name: str
    description: str
    edible: bool

class Mushroom(MushroomCreate):
    id: int

class MushroomUpdate(BaseModel):
    name: str = None
    description: str = None
    edible: bool = None