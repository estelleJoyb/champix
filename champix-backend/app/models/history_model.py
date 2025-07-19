from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base
from pydantic import BaseModel
from typing import Optional

class History(Base):
    __tablename__ = "history"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    image_path = Column(String, nullable=False)
    result = Column(String, nullable=False)
    analyse_detail = Column(Text)  # <-- ajouté ici
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("UserORM", back_populates="history")

class HistoryRead(BaseModel):
    id: int
    image_path: str
    result: str
    analyse_detail: Optional[str] 
    created_at: datetime

    class Config:
        orm_mode = True

class HistoryCreate(BaseModel):
    image_path: str
    result: str
    analyse_detail: Optional[str]