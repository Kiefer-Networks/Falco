#!/usr/bin/env bash
# Downloads the Hetzner OpenAPI specs into spec/ and regenerates the API
# packages under packages/ with tonik (version pinned in pubspec.lock).
#   tool/specs.sh            download and generate
#   tool/specs.sh --offline  generate from the specs already in spec/
set -euo pipefail
cd "$(dirname "$0")/.."

if [ "${1:-}" != "--offline" ]; then
  for spec in cloud hetzner; do
    curl -fsSL --proto '=https' --tlsv1.2 -o "spec/$spec.spec.json.tmp" \
      "https://docs.hetzner.cloud/$spec.spec.json"
    jq -e '.openapi and .paths' "spec/$spec.spec.json.tmp" >/dev/null
    # Stable formatting keeps the PR diff readable.
    jq --indent 1 . "spec/$spec.spec.json.tmp" >"spec/$spec.spec.json"
    rm "spec/$spec.spec.json.tmp"
  done
fi

generate() { # spec package
  # Generate next to the old package first: `dart run` resolves the app's
  # dependencies, which include the existing path package.
  tmp=$(mktemp -d)
  (cd spec && dart run tonik --spec "$1.spec.json" \
    --package-name "$2" --output-dir "$tmp")
  rm -rf "packages/$2"
  mv "$tmp/$2" "packages/$2"
  rm -rf "$tmp"
}
generate cloud hetzner_cloud_api
generate hetzner hetzner_storage_box_api
