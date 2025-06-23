#!/bin/bash

echo "Démarrage du serveur d'IA pour l'analyse de champignons..."
echo

# Se déplacer vers le dossier ia
cd "$(dirname "$0")/ia"

# Vérifier si Python est installé
if ! command -v python3 &> /dev/null; then
    echo "ERREUR: Python3 n'est pas installé ou n'est pas dans le PATH"
    echo "Veuillez installer Python depuis https://www.python.org/"
    exit 1
fi

# Vérifier si requirements.txt existe
if [ ! -f "requirements.txt" ]; then
    echo "ERREUR: requirements.txt non trouvé"
    exit 1
fi

echo "Installation/vérification des dépendances Python..."
pip3 install -r requirements.txt

echo
echo "Vérification du modèle..."
if [ ! -f "mushroom_classifier.pth" ]; then
    echo "ERREUR: Le fichier du modèle mushroom_classifier.pth n'a pas été trouvé!"
    echo "Assurez-vous que le modèle est dans le dossier ia/"
    exit 1
fi

echo
echo "========================================"
echo "DÉMARRAGE DU SERVEUR D'IA"
echo "========================================"
echo "Le serveur sera accessible sur http://127.0.0.1:8000"
echo "Appuyez sur Ctrl+C pour arrêter le serveur"
echo

python3 ai_api.py
