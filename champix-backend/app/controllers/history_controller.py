from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.models.history_model import History, HistoryCreate
from app.models.user_model import UserORM

def create_history(user_id: int, data: HistoryCreate, db: Session) -> History:
    user = db.query(UserORM).filter(UserORM.id == user_id).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    history_entry = History(
        user_id=user_id,
        image_path=data.image_path,
        result=data.result
    )
    db.add(history_entry)
    db.commit()
    db.refresh(history_entry)
    return history_entry


def get_user_history(user_id: int, db: Session) -> list[History]:
    return db.query(History).filter(History.user_id == user_id).order_by(History.created_at.desc()).all()


def get_history_entry(entry_id: int, db: Session) -> History:
    history = db.query(History).filter(History.id == entry_id).first()
    if not history:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="History entry not found")
    return history


def delete_history_entry(entry_id: int, db: Session) -> None:
    history = get_history_entry(entry_id, db)
    db.delete(history)
    db.commit()
