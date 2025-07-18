from fastapi import FastAPI
from app.routes import user_routes, mushroom_routes
from app.auth.auth_routes import auth_router
from app.routes.ai_routes import router as ai_router
from app.database import Base, engine

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Champix_backend")

app.include_router(auth_router, prefix="/auth", tags=["Authentication"])
app.include_router(user_routes.router, prefix="/users", tags=["Users"])
app.include_router(mushroom_routes.router, prefix="/mushrooms", tags=["Mushrooms"])
app.include_router(ai_router, prefix="/ai", tags=["AI"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)