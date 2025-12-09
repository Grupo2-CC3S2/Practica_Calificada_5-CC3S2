from fastapi import FastAPI, Request, HTTPException
import httpx

app = FastAPI(title="api-gateway")

INTERNAL_TOKEN = "123456"  # token de ejemplo
rate_limit = {}
MAX_REQ = 5


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
