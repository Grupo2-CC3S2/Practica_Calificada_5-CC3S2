from fastapi import FastAPI

app = FastAPI(title="internal-backend")


@app.get("/health")
async def health():
    return {"status": "ok"}