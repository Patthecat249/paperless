#!/usr/bin/env bash

SERVER="http://paperless.home.local"
TOKEN="fc8f357a2f6d617a88454319c74c67f584519644"

KATEGORIEN="
Rechnung
Steuer
Versicherung
Bank
Vertrag
Gesundheit
Miete
Haushalt
Auto
Sonstiges
"

for name in $KATEGORIEN; do
  echo "→ Erzeuge Kategorie: $name"
  curl -s -X POST "$SERVER/api/document_types/" \
    -H "Authorization: Token $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$name\"}"
  echo
done
