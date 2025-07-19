# 🚀 Guide de Démarrage Rapide - Analyse IA de Champignons

## Installation

### 1. Prérequis
- **Flutter SDK** installé
- **Python 3.8+** installé
- **Modèle d'IA** (`mushroom_classifier.pth`) dans le dossier `ia/`

### 2. Installation des dépendances Flutter
```bash
cd champix
flutter pub get
```

### 3. Installation des dépendances Python
```bash
cd ia
pip install -r requirements.txt
```

## Utilisation

### Étape 1 : Démarrer le serveur d'IA

**Windows :**
```cmd
# Double-cliquez sur le fichier ou exécutez :
start_ai_server.bat
```

**Mac/Linux :**
```bash
./start_ai_server.sh
# ou
chmod +x start_ai_server.sh && ./start_ai_server.sh
```

**Manuel :**
```bash
cd ia
python ai_api.py
```

### Étape 2 : Lancer l'application Flutter

```bash
flutter run
```

### Étape 3 : Utiliser l'analyse

1. Ouvrez l'application Champix
2. Allez dans l'onglet **"Détecter"**
3. **Prenez une photo** ou **sélectionnez depuis la galerie**
4. Appuyez sur **"Analyser"**
5. Consultez les **résultats détaillés**

## Fonctionnalités

### 📸 Capture d'image
- **Appareil photo** : Prise de photo en temps réel
- **Galerie** : Sélection d'images existantes

### 🤖 Analyse IA
- **Classification automatique** en 4 catégories
- **Niveau de confiance** pour chaque prédiction
- **Probabilités détaillées** pour toutes les catégories

### 📊 Résultats
- ✅ **Comestible**
- ⚠️ **Conditionnellement comestible**
- 🚫 **Toxique**
- ☠️ **Mortel**

## Dépannage

### ❌ "Serveur non disponible"
```bash
# Vérifiez que le serveur est démarré :
http://127.0.0.1:8000
```

### ❌ "Timeout d'analyse"
- Vérifiez votre connexion réseau
- Redémarrez le serveur d'IA
- Utilisez une image de plus petite taille

### ❌ "Erreur de modèle"
- Vérifiez que `mushroom_classifier.pth` est présent
- Vérifiez les permissions du fichier

## ⚠️ Important

**Cette IA est un outil d'aide uniquement !**

- ❌ Ne jamais se fier uniquement à l'IA
- ✅ Toujours consulter un expert mycologue
- 🚨 En cas de doute, ne pas consommer
- ⚖️ L'application décline toute responsabilité

## Architecture Technique

```
champix/
├── lib/src/
│   ├── services/
│   │   └── mushroom_ai_service.dart     # API IA
│   ├── widgets/
│   │   ├── take_picture.dart            # Capture
│   │   └── analysis_result_widget.dart  # Résultats
│   └── screens/
│       └── champignon_detect.dart       # Interface
├── ia/
│   ├── ai_api.py                        # Serveur Python
│   ├── mushroom_classifier.pth          # Modèle IA
│   └── requirements.txt                 # Dépendances
└── scripts/
    ├── start_ai_server.bat              # Windows
    └── start_ai_server.sh               # Unix/Mac
```

---

**Bon champignonnage ! 🍄**
