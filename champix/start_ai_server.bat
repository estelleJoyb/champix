@echo off
echo Demarrage du serveur d'IA pour l'analyse de champignons...
echo.

cd /d "%~dp0ia"

echo Verification de Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Python n'est pas installe ou n'est pas dans le PATH
    echo Veuillez installer Python depuis https://www.python.org/
    pause
    exit /b 1
)

echo Verification des dependances...
if not exist "requirements.txt" (
    echo ERREUR: requirements.txt non trouve
    pause
    exit /b 1
)

echo Installation/verification des dependances Python...
pip install -r requirements.txt

echo.
echo Verification du modele...
if not exist "mushroom_classifier.pth" (
    echo ERREUR: Le fichier du modele mushroom_classifier.pth n'a pas ete trouve!
    echo Assurez-vous que le modele est dans le dossier ia/
    pause
    exit /b 1
)

echo.
echo ========================================
echo DEMARRAGE DU SERVEUR D'IA
echo ========================================
echo Le serveur sera accessible sur http://127.0.0.1:8000
echo Appuyez sur Ctrl+C pour arreter le serveur
echo.

python ai_api.py

pause
