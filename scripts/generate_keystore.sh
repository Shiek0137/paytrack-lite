#!/usr/bin/env bash
set -euo pipefail

# Helper script to create a test keystore for local builds.
# WARNING: Do NOT commit the generated keystore or passwords to version control.
# Usage: ./scripts/generate_keystore.sh --keystore android/key.jks --alias key

KEYSTORE="android/key.jks"
ALIAS="key"
STOREPASS="changeit"
KEYPASS="changeit"
DNAME="CN=Your Name, OU=Dev, O=YourCompany, L=City, ST=State, C=US"
VALIDITY=10000

while [[ $# -gt 0 ]]; do
  case $1 in
    --keystore) KEYSTORE="$2"; shift 2;;
    --alias) ALIAS="$2"; shift 2;;
    --storepass) STOREPASS="$2"; shift 2;;
    --keypass) KEYPASS="$2"; shift 2;;
    --dname) DNAME="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

mkdir -p "$(dirname "$KEYSTORE")"

keytool -genkeypair \
  -alias "$ALIAS" \
  -keyalg RSA -keysize 2048 \
  -validity $VALIDITY \
  -dname "$DNAME" \
  -keystore "$KEYSTORE" \
  -storepass "$STOREPASS" \
  -keypass "$KEYPASS"

echo "Keystore created at $KEYSTORE"

echo "Remember to:"
echo " - move this keystore to a safe place"
echo " - copy android/key.properties.sample -> android/key.properties and update values"
echo " - do NOT commit your real keystore or key.properties to git"