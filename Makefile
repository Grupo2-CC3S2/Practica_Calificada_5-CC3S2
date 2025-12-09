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
	@echo "Construyendo imágenes..."
	docker compose build

run:
	@echo "Levantando contenedores..."
	docker compose up -d

stop:
	@echo "Deteniendo contenedores y eliminando imagenes"
	docker compose down --rmi all --volumes

requests: # Peticiones HTTPS
	@echo "Realizando petición HTTP al gateway para la data"
	for i in {1..7}; do curl -H "X-Internal-Token: 123456" http://localhost:8001/proxy/data; echo; done

check: # Verificar estado de contenedores
	@echo "Verificando estado de contenedores"
	docker ps -a 

delete: stop
	@echo "Eliminando servicio"


venv: ## Crea entorno virtual
	python -m venv .venv
ifeq ($(OS),Windows_NT)
	.venv\Scripts\pip.exe install -r requirements.txt
else
	.venv/bin/pip install -r requirements.txt
endif

del-env: ## Elimina entorno virtual
	rm -rf .venv

test: ## Ejecuta pruebas
ifeq ($(OS),Windows_NT)
	.venv\Scripts\python.exe -m pytest tests/
else
	.venv/bin/python -m pytest tests/
endif

clean: del-env ## Limpia todo el entorno
	@echo "Entorno completamente limpio"