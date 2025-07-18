from pydantic import BaseModel
from typing import Optional
from sqlalchemy import Column, Integer, String, Boolean
from app.database import Base

class Mushroom(Base):
    __tablename__ = "mushrooms"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(String)
    edible = Column(Boolean)
    country = Column(String)
    imageurl = Column(String)

# Pydantic schemas
class MushroomCreate(BaseModel):
    name: str
    description: str
    edible: bool
    country: Optional[str] = None
    imageurl: Optional[str] = None

class MushroomUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    edible: Optional[bool] = None
    country: Optional[str] = None
    imageurl: Optional[str] = None

class MushroomOut(MushroomCreate):
    id: int

    class Config:
        orm_mode = True
