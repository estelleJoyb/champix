import os

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./test.db")
DEBUG = os.getenv("DEBUG", True)
SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30)