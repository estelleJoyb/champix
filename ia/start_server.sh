#!/bin/bash
echo "Démarrage du serveur d'IA pour l'analyse de champignons..."
echo ""
echo "ATTENTION: Assurez-vous d'avoir installé les dépendances Python:"
echo "  pip install -r requirements.txt"
echo ""
echo "Le serveur sera accessible sur: http://127.0.0.1:8000"
echo "Pour arrêter le serveur, appuyez sur Ctrl+C"
echo ""
python3 ai_api.py
