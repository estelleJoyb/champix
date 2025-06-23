@echo off
echo Demarrage du serveur d'IA pour l'analyse de champignons...
echo.
echo ATTENTION: Assurez-vous d'avoir installe les dependances Python:
echo   pip install -r requirements.txt
echo.
echo Le serveur sera accessible sur: http://127.0.0.1:8000
echo Pour arreter le serveur, appuyez sur Ctrl+C
echo.
python ai_api.py
pause
