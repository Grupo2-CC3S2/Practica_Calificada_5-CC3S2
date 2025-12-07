from fastapi import FastAPI

app = FastAPI(title="internal-backend")

# Generar data de ejemplo
data = [{"id": i, "value": f"Item {i}"} for i in range(1, 101)]

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/data")
async def get_data():
    return {"data": data}  

@app.get("/admin")
async def get_admin():
    return {"admin": "Administración interna"}


