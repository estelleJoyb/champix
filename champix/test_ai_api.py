"""
Script de test pour vérifier que l'API d'IA fonctionne correctement
"""
import requests
import os

def test_ai_server():
    base_url = "http://127.0.0.1:8000"
    
    # Test 1: Vérifier que le serveur répond
    print("🔍 Test 1: Vérification de l'état du serveur...")
    try:
        response = requests.get(f"{base_url}/", timeout=5)
        if response.status_code == 200:
            print("✅ Serveur en ligne!")
            print(f"   Réponse: {response.json()}")
        else:
            print(f"❌ Erreur: {response.status_code}")
            return False
    except requests.ConnectionError:
        print("❌ Erreur: Impossible de se connecter au serveur")
        print("   Assurez-vous que le serveur d'IA est démarré avec: python ai_api.py")
        return False
    except Exception as e:
        print(f"❌ Erreur inattendue: {e}")
        return False
    
    # Test 2: Tester l'endpoint de prédiction sans image
    print("\n🔍 Test 2: Test de l'endpoint de prédiction...")
    try:
        response = requests.post(f"{base_url}/predict/", timeout=5)
        if response.status_code == 422:  # Expected error for missing file
            print("✅ Endpoint de prédiction accessible (erreur attendue sans image)")
        else:
            print(f"⚠️ Réponse inattendue: {response.status_code}")
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False
    
    print("\n🎉 Tests de base réussis!")
    print("\n📝 Pour tester avec une vraie image:")
    print("   1. Démarrez l'application Flutter")
    print("   2. Allez dans l'onglet 'Détecter'")
    print("   3. Prenez ou sélectionnez une photo")
    print("   4. Appuyez sur 'Analyser'")
    
    return True

if __name__ == "__main__":
    print("🚀 Test de l'API d'Intelligence Artificielle pour Champix")
    print("=" * 50)
    
    test_ai_server()
