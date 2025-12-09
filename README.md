# Practica_Calificada_5-CC3S2

## Ejecución
Crear una red de Docker para que el gateway se comunique con el backend
```bash
docker network create api-network
```
En este caso nos da como respuesta:
- **8896e6f374f04d97af18bf704644ce7c2095ed0ce128f47e768f4e9ef1497f4a**

Luego coonstruimos nuestro contenedor y lo corremos:
```bash
docker build -f Dockerfile.backend -t backend .
docker run -d --name backend --network api-network -p 8000:8000 backend
```
Dandonos como respuesta del levantado del servidor:
- **09d4a523b3293bceed0f2da738ba293f5be7dfe499db2ef376edd9fa08b46052**

Para probar que funciona, realizamos una petición HTTP con el comando **curl**
```bash
curl http://localhost:8000/health
{"status":"ok"}
```

#### Respuesta completa
```bash
StatusCode        : 200
StatusDescription : OK
Content           : {"status":"ok"}
RawContent        : HTTP/1.1 200 OK
                    Content-Length: 15
                    Content-Type: application/json
                    Date: Sun, 07 Dec 2025 20:35:53 GMT
                    Server: uvicorn

                    {"status":"ok"}
Forms             : {}
Headers           : {[Content-Length, 15], [Content-Type, application/json], [Date, Sun, 07 Dec 2025 20:35:53 GMT], [Server, uvicorn]}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 15
```

Ahora levantamos el gateway:
```bash
docker build -f Dockerfile.gateway -t gateway .
docker run -d --name gateway --network api-network -p 8001:8001 gateway
```
Dandonos su identificador como respuesta:
- **06ed265970c669463090389d46794833523fe6d2c8b24b46d1917e22dd195ca9**

Luego ejecutamos la petición HTTP con curl para verificar el levantamiento del gateway:
```bash
# curl -H "X-Internal-Token: 123456" http://localhost:8001/proxy/data
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2794  100  2794    0     0  51390      0 --:--:-- --:--:-- --:--:-- 51740
```
#### Respuesta completa
```bash
{"data":[{"id":1,"value":"Item 1"},{"id":2,"value":"Item 2"},{"id":3,"value":"Item 3"},{"id":4,"value":"Item 4"},{"id":5,"value":"Item 5"},{"id":6,"value":"Item 6"},{"id":7,"value":"Item 7"},{"id":8,"value":"Item 8"},{"id":9,"value":"Item 9"},{"id":10,"value":"Item 10"},{"id":11,"value":"Item 11"},{"id":12,"value":"Item 12"},{"id":13,"value":"Item 13"},{"id":14,"value":"Item 14"},{"id":15,"value":"Item 15"},{"id":16,"value":"Item 16"},{"id":17,"value":"Item 17"},{"id":18,"value":"Item 18"},{"id":19,"value":"Item 19"},{"id":20,"value":"Item 20"},{"id":21,"value":"Item 21"},{"id":22,"value":"Item 22"},{"id":23,"value":"Item 23"},{"id":24,"value":"Item 24"},{"id":25,"value":"Item 25"},{"id":26,"value":"Item 26"},{"id":27,"value":"Item 27"},{"id":28,"value":"Item 28"},{"id":29,"value":"Item 29"},{"id":30,"value":"Item 30"},{"id":31,"value":"Item 31"},{"id":32,"value":"Item 32"},{"id":33,"value":"Item 33"},{"id":34,"value":"Item 34"},{"id":35,"value":"Item 35"},{"id":36,"value":"Item 36"},{"id":37,"value":"Item 37"},{"id":38,"value":"Item 38"},{"id":39,"value":"Item 39"},{"id":40,"value":"Item 40"},{"id":41,"value":"Item 41"},{"id":42,"value":"Item 42"},{"id":43,"value":"Item 43"},{"id":44,"value":"Item 44"},{"id":45,"value":"Item 45"},{"id":46,"value":"Item 46"},{"id":47,"value":"Item 47"},{"id":48,"value":"Item 48"},{"id":49,"value":"Item 49"},{"id":50,"value":"Item 50"},{"id":51,"value":"Item 51"},{"id":52,"value":"Item 52"},{"id":53,"value":"Item 53"},{"id":54,"value":"Item 54"},{"id":55,"value":"Item 55"},{"id":56,"value":"Item 56"},{"id":57,"value":"Item 57"},{"id":58,"value":"Item 58"},{"id":59,"value":"Item 59"},{"id":60,"value":"Item 60"},{"id":61,"value":"Item 61"},{"id":62,"value":"Item 62"},{"id":63,"value":"Item 63"},{"id":64,"value":"Item 64"},{"id":65,"value":"Item 65"},{"id":66,"value":"Item 66"},{"id":67,"value":"Item 67"},{"id":68,"value":"Item 68"},{"id":69,"value":"Item 69"},{"id":70,"value":"Item 70"},{"id":71,"value":"Item 71"},{"id":72,"value":"Item 72"},{"id":73,"value":"Item 73"},{"id":74,"value":"Item 74"},{"id":75,"value":"Item 75"},{"id":76,"value":"Item 76"},{"id":77,"value":"Item 77"},{"id":78,"value":"Item 78"},{"id":79,"value":"Item 79"},{"id":80,"value":"Item 80"},{"id":81,"value":"Item 81"},{"id":82,"value":"Item 82"},{"id":83,"value":"Item 83"},{"id":84,"value":"Item 84"},{"id":85,"value":"Item 85"},{"id":86,"value":"Item 86"},{"id":87,"value":"Item 87"},{"id":88,"value":"Item 88"},{"id":89,"value":"Item 89"},{"id":90,"value":"Item 90"},{"id":91,"value":"Item 91"},{"id":92,"value":"Item 92"},{"id":93,"value":"Item 93"},{"id":94,"value":"Item 94"},{"id":95,"value":"Item 95"},{"id":96,"value":"Item 96"},{"id":97,"value":"Item 97"},{"id":98,"value":"Item 98"},{"id":99,"value":"Item 99"},{"id":100,"value":"Item 100"}]}
```

Notamos que nos da los valores que pusimos como prueba para [main.py](backend/main.py)

Para correr los tests:
```bash
# python -m pytest
============================= test session starts =============================
platform win32 -- Python 3.12.5, pytest-9.0.2, pluggy-1.6.0
rootdir: H:\PC5-DS\Practica_Calificada_5-CC3S2
plugins: anyio-4.12.0
collected 3 items

tests\test_gateway.py ...                                                [100%]

============================== 3 passed in 0.83s ==============================
```



## Sprint2 
Para ahora levantar los servicios, debemos de hacer
```bash
docker compose up --build
```

Y con esto, notaremos que ahora la respuesta a la llamada curl directo al backend, no responderá, y esto se debe a la red puente que estamos creando para la comunicación entre backend y gateway
```bash
# curl http://localhost:8000/data
curl: (7) Failed to connect to localhost port 8000 after 2259 ms: Could not connect to server
```
Pero si hacemos una petición apuntando a la red gateway si tendremos respuesta
```bash
# curl -H "X-Internal-Token: 123456" http://localhost:8001/proxy/data
{"data":"This is public data from backend"}
```

Y como hemos puesto un rate limiting, lo que va a pasar es el que hacer demasiadas consultas en un corto periodo de tiempo, ahora la respuesta nos señalará ese caso:
```bash
# curl -H "X-Internal-Token: 123456" http://localhost:8001/proxy/data
{"detail":"Too Many Requests"}
```

Para verificar este cambio o exclusión de permisos para solicitar datos, podemos verificar los logs de gateway que va a ser el encargado de verificar este spam de solicitudes http desde dispositivos según la ip
```bash
# docker logs gateway
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": true, "status": 200, "timestamp": 1765264524}
INFO:     172.18.0.1:57540 - "GET /proxy/data HTTP/1.1" 200 OK
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": true, "status": 200, "timestamp": 1765264545}
INFO:     172.18.0.1:36480 - "GET /proxy/data HTTP/1.1" 200 OK
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": true, "status": 429, "timestamp": 1765264553}
INFO:     172.18.0.1:34842 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765264557}
INFO:     172.18.0.1:36274 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765264888}
INFO:     172.18.0.1:59514 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265035}
INFO:     172.18.0.1:50760 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265035}
INFO:     172.18.0.1:50764 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265035}
INFO:     172.18.0.1:50778 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265035}
INFO:     172.18.0.1:50790 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265035}
INFO:     172.18.0.1:50800 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265035}
INFO:     172.18.0.1:50808 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
{"service": "gateway", "ip": "172.18.0.1", "endpoint": "/proxy/data", "allowed": false, "status": 429, "timestamp": 1765265036}
INFO:     172.18.0.1:50816 - "GET /proxy/data HTTP/1.1" 429 Too Many Requests
```

Donde podemos ver que en los primeros 3 tenemos permitido el acceso pero luego será falso y no obtendremos respuesta.