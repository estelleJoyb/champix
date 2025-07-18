from pydantic import BaseModel
from typing import Optional

class UserCredentials(BaseModel):
    email: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: str
    username: Optional[str] = None

class UserCreate(BaseModel):
    username: str
    email: str
    password: str

class UserInDB(BaseModel):
    id: int
    username: str
    email: str
    hashed_password: str