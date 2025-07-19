# Champix - Application d'Identification de Champignons

## 🍄 Nouvelle Fonctionnalité : Analyse par Intelligence Artificielle

L'application Champix inclut désormais une fonctionnalité d'analyse automatique des champignons grâce à l'intelligence artificielle !

### Fonctionnalités

- **Prise de photo** : Utilisez l'appareil photo de votre appareil pour capturer un champignon
- **Sélection depuis la galerie** : Choisissez une photo existante depuis votre galerie
- **Analyse IA** : L'intelligence artificielle analyse l'image et détermine si le champignon est :
  - ✅ **Comestible** : Sûr à consommer
  - ⚠️ **Conditionnellement comestible** : Consommable sous certaines conditions
  - ⚠️ **Toxique** : Dangereux à consommer
  - 🚫 **Mortel** : Extrêmement dangereux

### Comment utiliser la fonctionnalité d'analyse

1. **Démarrer le serveur d'IA** :
   - Sur Windows : Double-cliquez sur `start_ai_server.bat`
   - Sur Mac/Linux : Exécutez `./start_ai_server.sh`
   - Ou manuellement : `cd ia && python ai_api.py`

2. **Dans l'application** :
   - Allez dans l'onglet "Détecter"
   - Prenez une photo ou sélectionnez une image
   - Appuyez sur "Analyser"
   - Consultez les résultats détaillés

### Résultats de l'analyse

L'analyse fournit :
- **Prédiction principale** avec niveau de confiance
- **Détails des probabilités** pour chaque catégorie
- **Message de sécurité** adapté au résultat
- **Avertissement important** sur les limites de l'IA

## ⚠️ Avertissement Important

**Cette analyse par IA est un outil d'aide à l'identification uniquement et NE DOIT JAMAIS remplacer l'expertise d'un mycologue professionnel.**

**Ne jamais consommer un champignon sans être absolument certain de son identification par un expert qualifié.**

## Configuration Technique

### Prérequis pour l'IA
- Python 3.8+
- Dépendances Python (voir `ia/requirements.txt`)
- Modèle pré-entraîné (`mushroom_classifier.pth`)

### Dépendances Flutter ajoutées
- `http`: Pour la communication avec l'API d'IA
- `image_picker`: Pour sélectionner des images depuis la galerie

## Utilisation

1. **Démarrer le serveur d'IA** (requis)
2. **Lancer l'application Flutter**
3. **Naviguer vers l'onglet "Détecter"**
4. **Prendre ou sélectionner une photo**
5. **Analyser et consulter les résultats**

## Architecture

```
lib/
├── src/
│   ├── services/
│   │   └── mushroom_ai_service.dart    # Service de communication avec l'IA
│   ├── widgets/
│   │   ├── take_picture.dart           # Widget de capture/sélection d'image
│   │   └── analysis_result_widget.dart # Widget d'affichage des résultats
│   └── screens/
│       └── champignon_detect.dart      # Écran principal de détection
```

## Sécurité et Responsabilité

- L'IA peut faire des erreurs
- Toujours consulter un expert pour une identification définitive
- En cas de doute, ne pas consommer
- L'application décline toute responsabilité en cas d'intoxication

## Support

En cas de problème avec l'analyse IA :
1. Vérifiez que le serveur Python est en cours d'exécution
2. Vérifiez votre connexion réseau
3. Consultez les logs du serveur pour les erreurs
4. Redémarrez le serveur si nécessaire
