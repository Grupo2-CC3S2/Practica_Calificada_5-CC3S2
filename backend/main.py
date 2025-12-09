from fastapi import FastAPI, Request
import time
import json

app = FastAPI(title="internal-backend")

def log_request(ip, endpoint, status):
    log = {
        "service": "backend",
        "ip": ip,
        "endpoint": endpoint,
        "status": status,
        "timestamp": int(time.time())
    }
    # imprimir como JSON puro
    print(json.dumps(log))


@app.middleware("http")
async def json_logger(request: Request, call_next):
    response = await call_next(request)

    try:
        ip = request.client.host
    except:
        ip = "unknown"

    log_request(ip, request.url.path, response.status_code)

    return response


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.get("/data")
async def get_data():
    return {"data": "This is public data from backend"}


@app.get("/admin")
async def get_admin():
    return {"admin": "admin-only secret info"}
