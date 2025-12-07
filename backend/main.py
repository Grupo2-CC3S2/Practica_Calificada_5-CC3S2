from fastapi import FastAPI

app = FastAPI(title="internal-backend")


@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/data")
async def get_data():
    return {"data": "Estos son datos públicos del backend"}
