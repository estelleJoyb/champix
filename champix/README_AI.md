# Service d'Analyse de Champignons avec IA

Ce service utilise l'intelligence artificielle pour analyser des images de champignons et déterminer s'ils sont comestibles.

## Installation et lancement du serveur d'IA

### Prérequis
- Python 3.8 ou plus récent
- pip (gestionnaire de paquets Python)

### Installation des dépendances

1. Ouvrez un terminal dans le dossier `ia/`
2. Installez les dépendances requises :

```bash
pip install -r requirements.txt
```

### Lancement du serveur

1. Dans le dossier `ia/`, lancez le serveur :

```bash
python ai_api.py
```

2. Le serveur démarrera sur `http://127.0.0.1:8000`
3. Vous pouvez tester que le serveur fonctionne en visitant cette URL dans votre navigateur

### Utilisation dans l'application Flutter

1. Assurez-vous que le serveur d'IA est en cours d'exécution
2. Dans l'application Champix, allez dans l'onglet "Détecter"
3. Prenez une photo ou sélectionnez une image depuis la galerie
4. Appuyez sur "Analyser" pour obtenir les résultats de l'IA

## Classification des champignons

L'IA peut classifier les champignons dans les catégories suivantes :
- **Comestible** : Sûr à consommer
- **Conditionnellement comestible** : Peut être consommé sous certaines conditions
- **Toxique** : Dangereux à consommer
- **Mortel** : Extrêmement dangereux, peut être fatal

## ⚠️ Avertissement important

Cette analyse par IA est un outil d'aide à l'identification, mais **NE DOIT JAMAIS** remplacer l'expertise d'un mycologue professionnel. Ne jamais consommer un champignon sans être absolument certain de son identification par un expert.

## Dépannage

### Le serveur ne démarre pas
- Vérifiez que Python est installé et dans le PATH
- Vérifiez que toutes les dépendances sont installées
- Assurez-vous que le fichier `mushroom_classifier.pth` est présent

### L'application ne peut pas se connecter au serveur
- Vérifiez que le serveur est en cours d'exécution
- Vérifiez que l'URL dans `mushroom_ai_service.dart` correspond à votre configuration
- Assurez-vous qu'aucun pare-feu ne bloque la connexion

### Erreur de timeout
- L'analyse peut prendre du temps, soyez patient
- Vérifiez votre connexion réseau
- Redémarrez le serveur si nécessaire
