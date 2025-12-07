# Definiendo default target a help
.DEFAULT_GOAL := help

.PHONY: help
help: ## Muestra este mensaje de ayuda
	@echo "make build	- Construye las imagenes de docker"
	@echo "make run	- Levanta los contenedores de docker"
	@echo "make stop	- Detiene los contenedores de docker"
	@echo "make requests	- Realiza peticiones HTTP a los contenedores"
	@echo "make check	- Verifica contenedores levantados"
	@echo "make delete	- Elimina contenedores y red de docker"
	@echo "make venv	- Crea entorno virtual"
	@echo "make del-env	- Elimina entorno virtual"
	@echo "make test	- Ejecuta pruebas"
	@echo "make clean	- Limpia todo el entorno"


build:
	@echo "Contruye red"
	docker network create api-network
	@echo "Contruye la imagen de backend"
	docker build -f Dockerfile.backend -t backend .
	@echo "Contruye la imagen de gateway"
	docker build -f Dockerfile.gateway -t gateway .
	@echo "Imagenes creadas"

run: build
	@echo "Levanta imagenes"
	docker run -d --name backend --network api-network -p 8000:8000 backend
	docker run -d --name gateway --network api-network -p 8001:8001 gateway
	@echo "Contenedores corriendo en los puertos 8000 (backend) y 8001 (gateway)"

stop:
	@echo "Deteniendo contenedores"
	docker stop gateway backend
	@echo "Contenedores detenidos"

requests: # Peticiones HTTP
	@echo "Realizando petición HTTP al gateway para la data"
	curl -H "X-Internal-Token: 123456" http://localhost:8001/proxy/data
	@echo "Realizando petición HTTP al gateway para admin"
	curl -H "X-Internal-Token: 123456" http://localhost:8001/proxy/admin
	@echo "Petición realizada"
	@echo "Realizando petición HTTP al backend directamente"
	@echo "Realizando petición /health"
	curl http://localhost:8000/health
	@echo "Realizando petición /data"
	curl http://localhost:8000/data
	@echo "Realizando petición para admin"
	curl http://localhost:8000/admin
	@echo "Peticiones realizadas"

check: # Verificar estado de contenedores
	@echo "Verificando estado de contenedores"
	docker ps -a 

delete: stop
	@echo "Eliminando contenedores"
	docker rm gateway backend
	@echo "Eliminando red"
	docker network rm api-network
	@echo "Entrono limpio"
	@make check

venv: ## Crea entorno virtual
	python -m venv .venv
	source .venv/Scripts/activate && pip install -r requirements.txt

del-env: ## Elimina entorno virtual
	rm -rf .venv

test:
	@echo "Ejecuta pruebas"
	source .venv/Scripts/activate && python -m pytest tests/

clean: del-env ## Limpia todo el entorno
	@echo "Entorno completamente limpio"