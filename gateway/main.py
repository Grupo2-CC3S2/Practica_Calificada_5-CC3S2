import time
import json
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import httpx

app = FastAPI(title="api-gateway")

INTERNAL_TOKEN = "123456"  # token de ejemplo
rate_limit = {}
MAX_REQ = 5

def log_request(ip, endpoint, allowed, status):
    log = {
        "service": "gateway",
        "ip": ip,
        "endpoint": endpoint,
        "allowed": allowed,
        "status": status,
        "timestamp": int(time.time())
    }
    print(json.dumps(log))

@app.middleware("http")
async def json_logger(request: Request, call_next):
    ip = request.client.host
    endpoint = request.url.path

    # Verificación previa (rate limit y token)
    try:
        check_rate_limit(request)
        await check_token(request)
        allowed = True
    except HTTPException as e:
        # bloqueado → log y return inmediato
        log_request(ip, endpoint, False, e.status_code)
        return JSONResponse(status_code=e.status_code, content={"detail": e.detail})

    # Request válido → continuar
    response = await call_next(request)
    log_request(ip, endpoint, True, response.status_code)
    return response


def check_rate_limit(request: Request):
    ip = request.client.host
    count = rate_limit.get(ip, 0)

    if count >= MAX_REQ:
        raise HTTPException(status_code=429, detail="Too Many Requests")

    rate_limit[ip] = count + 1

async def check_token(request: Request):
    token = request.headers.get("X-Internal-Token")
    if token is None:
        raise HTTPException(status_code=401, detail="Header faltante")
    if token != INTERNAL_TOKEN:
        raise HTTPException(status_code=403, detail="Token incorrecto")

@app.get("/proxy/data")
async def proxy_data(request: Request):
    check_rate_limit(request)
    await check_token(request)
    async with httpx.AsyncClient() as client:
        resp = await client.get("http://backend:8000/data")
        return resp.json()

@app.get("/proxy/admin")
async def proxy_admin(request: Request):
    check_rate_limit(request)
    await check_token(request)
    async with httpx.AsyncClient() as client:
        resp = await client.get("http://backend:8000/admin")
        return resp.json()
