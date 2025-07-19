from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import relationship
from app.database import Base
from pydantic import BaseModel
from typing import Optional

class UserORM(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)

    bio = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)

    history = relationship("History", back_populates="user", cascade="all, delete-orphan")

class UserCreate(BaseModel):
    username: str
    email: str
    password: str

    bio: Optional[str] = None
    avatar_url: Optional[str] = None

class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None

    bio: Optional[str] = None
    avatar_url: Optional[str] = None

class User(BaseModel):
    id: int
    username: str
    email: str
    is_active: bool

    bio: Optional[str] = None
    avatar_url: Optional[str] = None

    class Config:
        orm_mode = True

class UserInDB(User):
    hashed_password: str

class UserRead(BaseModel):
    id: int
    username: str
    email: str

    bio: Optional[str] = None
    avatar_url: Optional[str] = None

    class Config:
        orm_mode = True
