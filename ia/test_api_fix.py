#!/usr/bin/env python3
"""
Script de test pour vérifier que l'API accepte maintenant les images
avec les corrections apportées.
"""

import requests
import io
from PIL import Image

def create_test_image():
    """Crée une image de test simple."""
    # Créer une image RGB simple de 100x100 pixels
    img = Image.new('RGB', (100, 100), color='red')
    
    # Convertir en bytes
    img_byte_arr = io.BytesIO()
    img.save(img_byte_arr, format='JPEG')
    img_byte_arr.seek(0)
    
    return img_byte_arr.getvalue()

def test_api():
    """Teste l'API avec une image générée."""
    url = "http://127.0.0.1:8000/predict/"
    
    # Créer une image de test
    image_bytes = create_test_image()
    
    # Préparer la requête
    files = {
        'file': ('test_image.jpg', image_bytes, 'image/jpeg')
    }
    
    try:
        print("🧪 Test de l'API avec une image générée...")
        response = requests.post(url, files=files, timeout=10)
        
        print(f"📊 Status Code: {response.status_code}")
        print(f"📋 Response: {response.text}")
        
        if response.status_code == 200:
            print("✅ SUCCESS: L'API accepte maintenant les images !")
            data = response.json()
            print(f"🍄 Prédiction: {data.get('prediction', 'N/A')}")
            print(f"🎯 Confiance: {data.get('confidence', 'N/A'):.2%}")
        else:
            print("❌ FAILED: L'API retourne encore une erreur")
            
    except requests.exceptions.RequestException as e:
        print(f"🚫 Erreur de connexion: {e}")
        print("💡 Assurez-vous que le serveur Python est démarré avec: python ai_api.py")

def test_health():
    """Teste l'endpoint de santé de l'API."""
    url = "http://127.0.0.1:8000/health"
    
    try:
        print("\n🏥 Test de l'endpoint de santé...")
        response = requests.get(url, timeout=5)
        
        if response.status_code == 200:
            data = response.json()
            print("✅ API Health Check:")
            print(f"   Status: {data.get('status', 'N/A')}")
            print(f"   Model Loaded: {data.get('model_loaded', 'N/A')}")
            print(f"   Device: {data.get('device', 'N/A')}")
        else:
            print(f"❌ Health check failed: {response.status_code}")
            
    except requests.exceptions.RequestException as e:
        print(f"🚫 Erreur de connexion: {e}")

if __name__ == "__main__":
    print("🔧 Test des corrections de l'API d'analyse d'images")
    print("=" * 50)
    
    test_health()
    test_api()
    
    print("\n" + "=" * 50)
    print("📝 Si le test réussit, votre application Flutter devrait maintenant")
    print("   pouvoir analyser les images sans erreur 400!")
