from fastapi.testclient import TestClient
from main import app  # Importamos la app de tu archivo main.py

client = TestClient(app)

def test_read_main():
    # 1. Hacemos una petición simulada GET a la raíz de tu API
    response = client.get("/")

    # 2. Verificamos que el código de respuesta HTTP sea 200 (Éxito)
    assert response.status_code == 200

    # 3. Verificamos que el JSON devuelto contenga el estado correcto
    data = response.json()
    assert data["status"] == "funcionando"
