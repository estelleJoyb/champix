from fastapi import APIRouter, UploadFile, File, HTTPException, Depends
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from app.ai_api_logic import model, transform, CLASS_NAMES, device
from app.auth.auth_controller import get_current_user
from app.database import get_db
from app.models.user_model import UserORM
from app.models.history_model import History
import io
from PIL import Image
import torch
import os
from datetime import datetime
import uuid

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/predict/", tags=["AI"])
async def predict_image(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: UserORM = Depends(get_current_user)
):
    contents = await file.read()
    
    try:
        image = Image.open(io.BytesIO(contents)).convert('RGB')
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Impossible de lire le fichier image. Erreur: {e}")

    image_tensor = transform(image).unsqueeze(0).to(device)
    with torch.no_grad():
        outputs = model(image_tensor)
        probabilities = torch.nn.functional.softmax(outputs, dim=1)
        top_prob, top_class_index = torch.max(probabilities, 1)

    predicted_class = CLASS_NAMES[top_class_index.item()]
    confidence = top_prob.item()

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"{uuid.uuid4().hex}_{timestamp}.png"
    image_path = os.path.join(UPLOAD_DIR, filename)
    image.save(image_path)

    new_history = History(
        user_id=current_user.id,
        image_path=image_path,
        result=predicted_class,
    )
    db.add(new_history)
    db.commit()
    db.refresh(new_history)

    response_data = {
        "prediction": predicted_class,
        "confidence": confidence,
        "all_probabilities": {CLASS_NAMES[i]: prob.item() for i, prob in enumerate(probabilities[0])},
        "saved_history": {
            "id": new_history.id,
            "image_path": new_history.image_path,
            "created_at": new_history.created_at.isoformat()
        }
    }
    return JSONResponse(content=response_data)

@router.get("/", tags=["AI"])
def health_check():
    return {"status": "AI service is running", "model": "mushroom_classifier", "classes": CLASS_NAMES}