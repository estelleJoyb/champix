from fastapi import APIRouter, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from app.ai_api_logic import model, transform, CLASS_NAMES, device
import io
from PIL import Image
import torch

router = APIRouter()

@router.post("/predict/", tags=["AI"])
async def predict_image(file: UploadFile = File(...)):
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
    response_data = {
        "prediction": predicted_class,
        "confidence": confidence,
        "all_probabilities": {CLASS_NAMES[i]: prob.item() for i, prob in enumerate(probabilities[0])}
    }
    return JSONResponse(content=response_data)