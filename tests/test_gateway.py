from fastapi.testclient import TestClient
from unittest.mock import patch
from gateway.main import app

client = TestClient(app)

def test_no_token():
    r = client.get("/proxy/data")
    assert r.status_code == 401

def test_bad_token():
    r = client.get("/proxy/data", headers={"X-Internal-Token": "malo"})
    assert r.status_code == 403

def test_good_token():
    with patch("httpx.AsyncClient.get") as mock_get:
        mock_get.return_value.json = lambda: {"data": "simulado"}
        r = client.get("/proxy/data", headers={"X-Internal-Token": "123456"})
        assert r.status_code == 200
        assert r.json() == {"data": "simulado"}
