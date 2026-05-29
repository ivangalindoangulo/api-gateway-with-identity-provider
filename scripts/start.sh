#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR=$( cd "$SCRIPT_DIR/.." &> /dev/null && pwd )

if [ ! -f "$BASE_DIR/.env" ]; then
    echo "Error: No se encontro el archivo .env en $BASE_DIR"
    echo "Por favor, mueve o crea el archivo .env en la raiz del proyecto."
    exit 1
fi

echo "Cargando variables de entorno desde .env..."
set -a
source "$BASE_DIR/.env"
set +a

echo "Iniciando contenedores de Docker..."
cd "$BASE_DIR"
docker compose -f "$BASE_DIR/deployment/docker/docker-compose.yml" up --build
