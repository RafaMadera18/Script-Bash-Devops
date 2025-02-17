#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No se proporcionó un argumento."
  exit 1
fi

POKEMON=$1
API="https://pokeapi.co/api/v2/pokemon/$POKEMON"
CSV="pokemon.csv"

touch "$CSV"

RESPONSE=$(curl -s "$API")


if [ -z "$RESPONSE" ] || [ "$(echo "$RESPONSE" | jq -r '.id // empty')" = "" ]; then
  echo "El Pokémon '$POKEMON' no existe."
  exit 1
fi

ID=$(echo "$RESPONSE" | jq -r '.id')
NAME=$(echo "$RESPONSE" | jq -r '.name')
WEIGHT=$(echo "$RESPONSE" | jq -r '.weight')
HEIGHT=$(echo "$RESPONSE" | jq -r '.height')
ORDER=$(echo "$RESPONSE" | jq -r '.order')

echo "${NAME^} (No. $ID)"
echo "Id = $ID"
echo "Weight = $WEIGHT"
echo "Height = $HEIGHT"
echo "Order = $ORDER"

echo "Guardando en $CSV..."

if [ ! -s "$CSV" ]; then
  echo "id,name,weight,height,order" > "$CSV"
fi

echo "$ID,$NAME,$WEIGHT,$HEIGHT,$ORDER" >> "$CSV"

echo "Datos guardados correctamente."
