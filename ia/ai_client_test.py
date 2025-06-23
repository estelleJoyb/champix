# client.py
import requests
import os

# Mettez le chemin d'une image de champignon que vous voulez tester
# Exemple de chemin sous Windows :
IMAGE_PATH = r"C:\Users\oxifa\Downloads\Hedgehog_fungi2.jpg"
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