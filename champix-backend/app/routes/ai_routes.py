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
import json

router = APIRouter()

UPLOAD_DIR = "/app/app/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def compress_and_save_image(image: Image.Image, upload_dir: str, max_size: int = 800) -> (str, str):
    original_size = image.size
    max_dimension = max(image.size)
    if max_dimension > max_size:
        scale_ratio = max_size / max_dimension
        new_size = (int(image.width * scale_ratio), int(image.height * scale_ratio))
        image = image.resize(new_size, Image.Resampling.LANCZOS)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"{uuid.uuid4().hex}_{timestamp}.jpg"
    save_path = os.path.join(upload_dir, filename)
    
    image.save(save_path, format='JPEG', quality=85, optimize=True)
    return save_path, filename

def analyze_image(image: Image.Image):
    image_tensor = transform(image).unsqueeze(0).to(device)
    with torch.no_grad():
        outputs = model(image_tensor)
        probabilities = torch.nn.functional.softmax(outputs, dim=1)
        top_prob, top_class_index = torch.max(probabilities, 1)

    predicted_class = CLASS_NAMES[top_class_index.item()]
    confidence = top_prob.item()
    all_probabilities = {CLASS_NAMES[i]: prob.item() for i, prob in enumerate(probabilities[0])}
    return predicted_class, confidence, all_probabilities


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
        raise HTTPException(status_code=400, detail=f"Unable to read image file. Error: {e}")

    predicted_class, confidence, all_probabilities = analyze_image(image)

    save_path, filename = compress_and_save_image(image, UPLOAD_DIR)

    new_history = History(
        user_id=current_user.id,
        image_path=f"http://localhost:8000/uploads/{filename}",
        result=predicted_class,
        analyse_detail=json.dumps({
            "prediction": predicted_class,
            "confidence": confidence,
            "all_probabilities": all_probabilities,
        }),
    )
    db.add(new_history)
    db.commit()
    db.refresh(new_history)

    response_data = {
        "prediction": predicted_class,
        "confidence": confidence,
        "all_probabilities": all_probabilities,
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