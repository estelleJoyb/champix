from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.models.user_model import UserORM, UserCreate, UserUpdate
from passlib.hash import bcrypt
import re

def is_valid_email(email: str) -> bool:
    email_regex = r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$'
    return re.match(email_regex, email) is not None

def is_strong_password(password: str) -> bool:
    length_check = len(password) >= 8
    upper_check = re.search(r'[A-Z]', password) is not None
    digit_check = re.search(r'\d', password) is not None
    special_check = re.search(r'[!@#$%^&*(),.?":{}|<>]', password) is not None
    return length_check and upper_check and digit_check and special_check

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
    if not is_valid_email(user.email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid email format"
        )

    if not is_strong_password(user.password):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Password must be at least 8 characters long, include uppercase letters, digits and special characters"
        )

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
