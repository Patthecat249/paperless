#!/usr/bin/env bash

SERVER="http://paperless.home.local"
TOKEN="fc8f357a2f6d617a88454319c74c67f584519644"

CORRESPONDENTS="
Finanzamt
Stadtkasse
Stadtwerke
Krankenkasse
Hausarzt
Zahnarzt
Versicherung
Telekom
O2
Vodafone
Sparkasse
Volksbank
DKB
ING
Amazon
IKEA
Bauhaus
Lidl
Aldi
Rewe
"

for name in $CORRESPONDENTS; do
  echo "→ Erzeuge Korrespondent: $name"
  curl -s -X POST "$SERVER/api/correspondents/" \
    -H "Authorization: Token $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$name\"}"
  echo
done
