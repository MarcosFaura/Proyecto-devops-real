import os
from datetime import datetime
from fastapi import FastAPI

app = FastAPI(title="Mi API DevOps")

@app.get("/")
def read_root():
    return {
        "status": "funcionando",
        "message": "Hola, este es mi proyecto DevOps real"
    }
