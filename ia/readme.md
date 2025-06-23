### Étape 1 : Préparation de l'environnement sur Windows

1.  **Installer Python** : Si ce n'est pas déjà fait, téléchargez et installez Python depuis le [site officiel](https://www.python.org/downloads/windows/). Assurez-vous de cocher la case **"Add Python to PATH"** pendant l'installation.

2.  **Créer un environnement virtuel (Recommandé)** : C'est une bonne pratique pour isoler les dépendances de votre projet. Ouvrez une invite de commandes (`cmd`) ou PowerShell.
    ```bash
    # Naviguez vers le dossier de votre projet
    cd C:\chemin\vers\mon_projet_ia

    # Créez un environnement virtuel nommé 'venv'
    python -m venv venv

    # Activez l'environnement virtuel
    venv\Scripts\activate
    ```
    Votre invite de commandes devrait maintenant commencer par `(venv)`.

3.  **Installer les bibliothèques Python** : Avec l'environnement activé, installez toutes les dépendances nécessaires.
    ```bash
    # Installez PyTorch (version CPU), FastAPI, Uvicorn, etc.
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    pip install fastapi "uvicorn[standard]" python-multipart Pillow requests
    ```

---

### Étape 2 : Le Code de l'API (adapté pour CPU)

Le code est presque identique. La seule chose qui change, c'est que `torch.device("cuda"...)` va automatiquement basculer sur `"cpu"` car `torch.cuda.is_available()` sera `False`.

Créez un fichier `api.py` dans le dossier de votre projet. Assurez-vous que votre fichier de modèle `mushroom_classifier.pth` se trouve dans le même dossier.

```python
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
MODEL_PATH = "mushroom_classifier.pth"

# Fonction pour charger le modèle
def load_model(model_path, num_classes):
    try:
        # map_location='cpu' force le chargement du modèle sur le CPU.
        # C'est utile si le modèle a été sauvegardé sur un GPU.
        model = models.resnet50(weights=None)
        model.fc = nn.Linear(model.fc.in_features, num_classes)
        model.load_state_dict(torch.load(model_path, map_location=device))
        model.to(device)
        model.eval() # Mettre en mode évaluation
        logger.info("Modèle chargé avec succès sur le CPU.")
        return model
    except FileNotFoundError:
        logger.error(f"Erreur: Le fichier du modèle '{model_path}' n'a pas été trouvé.")
        return None
    except Exception as e:
        logger.error(f"Une erreur est survenue lors du chargement du modèle : {e}")
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

# ===================================================================
# 3. Création de l'Application FastAPI
# ===================================================================
app = FastAPI(
    title="Mushroom Classifier API",
    description="Une API pour classifier des images de champignons en utilisant un modèle ResNet50 sur CPU.",
    version="1.0.0"
)

# Endpoint pour vérifier si l'API est en ligne
@app.get("/", tags=["Status"])
def read_root():
    """Endpoint racine pour vérifier que l'API est fonctionnelle."""
    return {"status": "ok", "message": "API de classification de champignons en ligne."}

# Endpoint principal pour la classification d'image
@app.post("/predict/", tags=["Classification"])
async def predict_image(file: UploadFile = File(...)):
    """
    Reçoit une image, la traite et retourne la prédiction du modèle.
    - **file**: Le fichier image (JPG, PNG, etc.) à classifier.
    """
    if not model:
        raise HTTPException(status_code=503, detail="Le modèle n'est pas disponible. Vérifiez les logs du serveur.")

    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Type de fichier invalide. Veuillez envoyer une image.")

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
```

---

### Étape 3 : Lancement et Utilisation de l'API sur Windows

1.  **Activez votre environnement virtuel** si ce n'est pas déjà fait :
    ```bash
    venv\Scripts\activate
    ```

2.  **Lancez le serveur API** depuis votre terminal, en étant dans le dossier qui contient `api.py` :
    ```bash
    python api.py
    ```
    Vous verrez des messages de log, incluant `Utilisation du device: cpu` et `Modèle chargé avec succès sur le CPU.`.

3.  **Testez l'API** :
    *   **Dans votre navigateur** : Ouvrez Chrome, Firefox ou autre et allez à l'adresse **`http://127.0.0.1:8000/docs`**. Vous y trouverez l'interface de test Swagger UI qui vous permettra d'uploader une image et de voir la réponse JSON directement.

    *   **Avec un script client** : Utilisez le même script `client.py` que dans la réponse précédente. Il fonctionnera sans aucune modification. Assurez-vous juste d'avoir une image de test sur votre disque et de mettre le bon chemin.

    ```python
    # client.py
    import requests
    import os

    # Mettez le chemin d'une image de champignon que vous voulez tester
    # Exemple de chemin sous Windows :
    IMAGE_PATH = r"C:\Users\VotreNom\Pictures\champignon_test.jpg"
    API_URL = "http://127.0.0.1:8000/predict/"

    if not os.path.exists(IMAGE_PATH):
        print(f"Erreur: Le fichier image '{IMAGE_PATH}' n'existe pas.")
    else:
        with open(IMAGE_PATH, "rb") as image_file:
            files = {"file": (os.path.basename(IMAGE_PATH), image_file, "image/jpeg")}
            try:
                response = requests.post(API_URL, files=files)
                if response.status_code == 200:
                    data = response.json()
                    print(f"Prédiction : {data['prediction']} (Confiance : {data['confidence'] * 100:.2f}%)")
                else:
                    print(f"Erreur de l'API (Code: {response.status_code}): {response.text}")
            except requests.exceptions.RequestException as e:
                print(f"Erreur de connexion à l'API: {e}")
    ```
    Exécutez-le dans un autre terminal (après avoir activé l'environnement virtuel) : `python client.py`.