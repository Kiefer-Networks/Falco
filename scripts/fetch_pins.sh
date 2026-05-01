#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Fetches SHA-256 SPKI pins for all pinned Hetzner endpoints and prints a
# Kotlin-friendly snippet ready to paste into app/src/main/kotlin/.../data/api/Pins.kt.
#
# Pin the *issuer/intermediate* keys for stability — leaves rotate every 60-90 days.
# Run this for every release tag and verify diffs by hand before committing.

set -euo pipefail

hosts=(
  "api.hetzner.cloud"
  "robot-ws.your-server.de"
  "dns.hetzner.com"
  "api.hetzner.com"
  "fsn1.your-objectstorage.com"
  "hel1.your-objectstorage.com"
  "nbg1.your-objectstorage.com"
)

pin_for() {
  local host=$1
  echo "# $host"
  echo |
    openssl s_client -servername "$host" -connect "$host:443" -showcerts 2>/dev/null |
    awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' |
    awk 'BEGIN{c=0} /BEGIN CERTIFICATE/{c++} {print > "/tmp/falco_pin_'"$host"'_" c ".pem"}'
  for cert in /tmp/falco_pin_"${host}"_*.pem; do
    [ -s "$cert" ] || continue
    pin=$(openssl x509 -in "$cert" -pubkey -noout |
          openssl pkey -pubin -outform der |
          openssl dgst -sha256 -binary | base64)
    subject=$(openssl x509 -in "$cert" -noout -subject -nameopt RFC2253)
    echo "  \"$pin\", # $subject"
    rm -f "$cert"
  done
  echo
}

for h in "${hosts[@]}"; do
  pin_for "$h"
done
