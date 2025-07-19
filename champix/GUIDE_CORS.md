# Guide CORS - Résolution des erreurs de connexion serveur

## Problème CORS (Cross-Origin Resource Sharing)

### Symptôme
Erreur dans la console du navigateur :
```
Access to XMLHttpRequest at 'http://127.0.0.1:8000/' from origin 'http://localhost:52711' has been blocked by CORS policy
```

### Explication
Le navigateur bloque les requêtes entre différents domaines/ports par sécurité. Flutter Web (localhost:52711) ne peut pas appeler l'API Python (127.0.0.1:8000) sans configuration CORS.

## Solutions

### Solution 1: Correction du serveur Python (RECOMMANDÉE) ✅

Le fichier `ia/ai_api.py` a été mis à jour avec :
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Solution 2: Lancer Chrome sans sécurité (TEMPORAIRE)

Si la solution 1 ne fonctionne pas, lancez Chrome avec :
```powershell
# Windows
"C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-web-security --user-data-dir="C:\temp\chrome_dev"

# Ou depuis VS Code, modifiez la configuration de lancement
```

## Étapes pour tester

### 1. Installer les dépendances Python
```bash
cd ia
pip install fastapi uvicorn torch torchvision pillow
```

### 2. Démarrer le serveur IA
```bash
# Option A: Script automatique
cd ia
./start_server.bat    # Windows
./start_server.sh     # Linux/Mac

# Option B: Manuel
cd ia
python ai_api.py
```

### 3. Vérifier que le serveur fonctionne
Ouvrez http://127.0.0.1:8000 dans votre navigateur.
Vous devriez voir : `{"status":"ok","message":"API de classification de champignons en ligne."}`

### 4. Tester l'application Flutter
```bash
# Dans le dossier champix/
flutter run -d chrome
```

## Diagnostics

### Test manuel de l'API
```bash
# Tester avec curl
curl -X GET http://127.0.0.1:8000/

# Tester l'upload d'image
curl -X POST http://127.0.0.1:8000/predict/ -F "file=@path/to/image.jpg"
```

### Console navigateur
Ouvrez les DevTools (F12) pour voir les erreurs réseau et CORS.

## Sécurité en production

⚠️ **IMPORTANT**: En production, remplacez `allow_origins=["*"]` par les domaines spécifiques :
```python
allow_origins=["https://monapp.com", "https://www.monapp.com"]
```

## Dépannage

### Le serveur ne démarre pas
- Vérifiez que Python est installé
- Installez les dépendances : `pip install -r requirements.txt`
- Vérifiez le port 8000 : `netstat -an | findstr 8000`

### Erreur de modèle manquant
- Assurez-vous que `mushroom_classifier.pth` existe dans le dossier `ia/`
- Le modèle doit être entraîné avec les classes : ['conditionally_edible', 'deadly', 'edible', 'poisonous']

### L'image ne s'affiche pas sur Flutter Web
- ✅ Corrigé : Utilisation d'`Image.memory` au lieu d'`Image.file`
- ✅ Corrigé : Utilisation d'`XFile.readAsBytes()` sur toutes les plateformes
