from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.models.user_model import UserORM, UserCreate, UserUpdate
from passlib.hash import bcrypt


def get_password_hash(password: str) -> str:
    return bcrypt.hash(password)

def get_users(db: Session):
    return db.query(UserORM).all()

def get_user(user_id: int, db: Session) -> UserORM:
    user = db.query(UserORM).filter(UserORM.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return user

def create_user(user: UserCreate, db: Session):
    hashed_password = get_password_hash(user.password)
    db_user = UserORM(
        username=user.username,
        email=user.email,
        hashed_password=hashed_password,
        is_active=True
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def update_user(user_id: int, user_data: UserUpdate, db: Session) -> UserORM:
    user = get_user(user_id, db)

    if user_data.name is not None:
        user.name = user_data.name
    if user_data.email is not None:
        user.email = user_data.email
    if user_data.password is not None:
        user.hashed_password = bcrypt.hash(user_data.password)

    db.commit()
    db.refresh(user)
    return user


def delete_user(user_id: int, db: Session) -> None:
    user = get_user(user_id, db)
    db.delete(user)
    db.commit()
