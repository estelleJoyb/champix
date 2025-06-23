# api.py

# ===================================================================
# 1. Imports
# ===================================================================
import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import io
import logging

# Imports pour l'API
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn

# ===================================================================
# 2. Configuration et Chargement du Modèle
# ===================================================================

# Configuration du logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Définir le device : il basculera automatiquement sur 'cpu' sur votre machine
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
logger.info(f"Utilisation du device: {device}")

# Définir les noms des classes (CRUCIAL : même ordre que l'entraînement)
CLASS_NAMES = ['conditionally_edible', 'deadly', 'edible', 'poisonous']
NUM_CLASSES = len(CLASS_NAMES)

# Utiliser le chemin absolu pour le modèle
import os
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(SCRIPT_DIR, "mushroom_classifier.pth")

# Fonction pour charger le modèle
def load_model(model_path, num_classes):
    try:
        logger.info(f"Tentative de chargement du modèle depuis : {model_path}")
        logger.info(f"Nombre de classes : {num_classes}")
        logger.info(f"Device utilisé : {device}")
        
        # Vérifier que le fichier existe
        import os
        if not os.path.exists(model_path):
            logger.error(f"Le fichier du modèle n'existe pas : {model_path}")
            return None
            
        logger.info("Fichier du modèle trouvé, chargement en cours...")
        
        # map_location='cpu' force le chargement du modèle sur le CPU.
        # C'est utile si le modèle a été sauvegardé sur un GPU.
        model = models.resnet50(weights=None)
        logger.info("Architecture ResNet50 créée")
        
        model.fc = nn.Linear(model.fc.in_features, num_classes)
        logger.info(f"Couche finale modifiée pour {num_classes} classes")
        
        model.load_state_dict(torch.load(model_path, map_location=device))
        logger.info("État du modèle chargé avec succès")
        
        model.to(device)
        model.eval() # Mettre en mode évaluation
        logger.info(f"Modèle chargé avec succès sur {device}")
        return model
    except FileNotFoundError:
        logger.error(f"Erreur: Le fichier du modèle '{model_path}' n'a pas été trouvé.")
        return None
    except Exception as e:
        logger.error(f"Une erreur est survenue lors du chargement du modèle : {e}")
        logger.error(f"Type d'erreur : {type(e).__name__}")
        import traceback
        logger.error(f"Traceback complet : {traceback.format_exc()}")
        return None

# Charger le modèle au démarrage de l'API
model = load_model(MODEL_PATH, NUM_CLASSES)

# Définir les transformations pour l'image d'entrée
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

def is_image_file(contents: bytes) -> bool:
    """
    Vérifie si le contenu du fichier correspond à un format d'image supporté
    en analysant les premiers bytes (signature du fichier).
    """
    # Log pour debugging
    logger.info(f"Vérification du type de fichier. Taille: {len(contents)} bytes")
    if len(contents) > 0:
        logger.info(f"Premiers 16 bytes: {contents[:16]}")
    
    # Signatures des formats d'images courantes
    image_signatures = [
        b'\xff\xd8\xff',      # JPEG
        b'\x89PNG\r\n\x1a\n', # PNG
        b'GIF87a',            # GIF87a
        b'GIF89a',            # GIF89a
        b'RIFF',              # WebP (commence par RIFF)
        b'BM',                # BMP
        b'II*\x00',           # TIFF (little endian)
        b'MM\x00*',           # TIFF (big endian)
    ]
    
    for signature in image_signatures:
        if contents.startswith(signature):
            logger.info(f"Signature d'image détectée: {signature}")
            return True
    
    # Vérification spéciale pour WebP (RIFF + WEBP)
    if len(contents) >= 12 and contents.startswith(b'RIFF') and contents[8:12] == b'WEBP':
        logger.info("Format WebP détecté")
        return True
    
    # Vérification alternative pour JPEG (parfois la signature peut varier)
    if contents.startswith(b'\xff\xd8'):
        logger.info("Format JPEG détecté (signature alternative)")
        return True
    
    logger.warning(f"Type de fichier non reconnu. Premiers bytes: {contents[:20] if len(contents) >= 20 else contents}")
    return False

# ===================================================================
# 3. Création de l'Application FastAPI
# ===================================================================
app = FastAPI(
    title="Mushroom Classifier API",
    description="Une API pour classifier des images de champignons en utilisant un modèle ResNet50 sur CPU.",
    version="1.0.0"
)

# Configuration CORS pour permettre les requêtes depuis le navigateur
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En production, remplacer par les domaines spécifiques
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Endpoint pour vérifier si l'API est en ligne
@app.get("/", tags=["Status"])
def read_root():
    """Endpoint racine pour vérifier que l'API est fonctionnelle."""
    return {"status": "ok", "message": "API de classification de champignons en ligne."}

# Endpoint pour vérifier l'état du modèle
@app.get("/health", tags=["Status"])
def health_check():
    """Endpoint pour vérifier l'état de santé de l'API et du modèle."""
    import os
    model_exists = os.path.exists(MODEL_PATH)
    model_loaded = model is not None
    
    return {
        "status": "healthy" if model_loaded else "unhealthy",
        "model_file_exists": model_exists,
        "model_loaded": model_loaded,
        "model_path": MODEL_PATH,
        "device": str(device),
        "num_classes": NUM_CLASSES,
        "class_names": CLASS_NAMES
    }

# Endpoint principal pour la classification d'image
@app.post("/predict/", tags=["Classification"])
async def predict_image(file: UploadFile = File(...)):
    """
    Reçoit une image, la traite et retourne la prédiction du modèle.
    - **file**: Le fichier image (JPG, PNG, etc.) à classifier.
    """
    if not model:
        logger.error("Tentative de prédiction avec un modèle non chargé")
        raise HTTPException(
            status_code=503, 
            detail="Le modèle n'est pas disponible. Vérifiez les logs du serveur et l'endpoint /health pour plus d'informations."
        )
      # Vérification plus flexible du type de fichier
    logger.info(f"Fichier reçu: {file.filename}, Content-Type: {file.content_type}")
    
    contents = await file.read()
    
    # Première vérification : tenter d'ouvrir l'image avec PIL
    try:
        # Essayer d'ouvrir l'image directement pour vérifier si c'est valide
        test_image = Image.open(io.BytesIO(contents))
        test_image.verify()  # Vérifier l'intégrité de l'image
        logger.info(f"Image valide détectée: format={test_image.format}, mode={test_image.mode}, taille={test_image.size}")
        
        # Recharger l'image car verify() peut la corrompre
        image = Image.open(io.BytesIO(contents)).convert('RGB')
        
    except Exception as e:
        logger.error(f"Erreur lors de la validation de l'image: {e}")
        
        # Fallback: vérifier les signatures de fichiers
        if not is_image_file(contents):
            raise HTTPException(status_code=400, detail="Type de fichier invalide. Veuillez envoyer une image valide (JPEG, PNG, GIF, WebP, BMP, TIFF).")
        
        # Si la signature est valide mais PIL ne peut pas l'ouvrir
        try:
            image = Image.open(io.BytesIO(contents)).convert('RGB')
        except Exception as e2:
            raise HTTPException(status_code=400, detail=f"Impossible de lire le fichier image. Erreur: {e2}")
    
    # Ancienne tentative de lecture - supprimée car redondante
    # try:
    #     image = Image.open(io.BytesIO(contents)).convert('RGB')
    # except Exception as e:
    #     raise HTTPException(status_code=400, detail=f"Impossible de lire le fichier image. Erreur: {e}")

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
    
    logger.info(f"Image '{file.filename}' classifiée comme '{predicted_class}' avec une confiance de {confidence:.2f}")

    return JSONResponse(content=response_data)

# ===================================================================
# 4. Lancement de l'API (si le script est exécuté directement)
# ===================================================================
if __name__ == "__main__":
    # Lance le serveur web Uvicorn
    # 'host="0.0.0.0"' rend l'API accessible depuis d'autres appareils sur votre réseau local.
    # Utilisez 'host="127.0.0.1"' pour n'y accéder que depuis votre propre machine.
    uvicorn.run(app, host="127.0.0.1", port=8000)