#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
#
# One-shot dev-environment bootstrap for Falco.
# Verifies the Android SDK and Java toolchain, generates the Gradle wrapper jar
# if it is missing, and prints the env vars you need exported in your shell.

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

echo "→ Falco dev setup"
echo "  repo root: $repo_root"

# Android SDK
if [[ -z "${ANDROID_HOME:-}" ]]; then
  for candidate in "$HOME/Android/Sdk" "$HOME/Android/sdk" "/opt/android-sdk"; do
    if [[ -d "$candidate" ]]; then
      ANDROID_HOME="$candidate"; export ANDROID_HOME
      break
    fi
  done
fi
if [[ -z "${ANDROID_HOME:-}" || ! -d "${ANDROID_HOME}" ]]; then
  echo "✗ Android SDK not found. Install via Android Studio or sdkmanager and set ANDROID_HOME." >&2
  exit 1
fi
echo "  ANDROID_HOME=$ANDROID_HOME"

# JDK
if [[ -z "${JAVA_HOME:-}" ]]; then
  for candidate in /opt/android-studio/jbr /usr/lib/jvm/java-21-openjdk /usr/lib/jvm/java-17-openjdk; do
    if [[ -x "$candidate/bin/java" ]]; then
      JAVA_HOME="$candidate"; export JAVA_HOME
      break
    fi
  done
fi
if [[ -z "${JAVA_HOME:-}" ]]; then
  echo "✗ JAVA_HOME not set and no JDK found. Install JDK 17 or 21." >&2
  exit 1
fi
echo "  JAVA_HOME=$JAVA_HOME"
"$JAVA_HOME/bin/java" -version 2>&1 | head -1 | sed 's/^/  /'

# Gradle wrapper jar — generate if missing
if [[ ! -f gradle/wrapper/gradle-wrapper.jar ]]; then
  echo "→ gradle-wrapper.jar missing, bootstrapping…"
  if command -v gradle >/dev/null; then
    gradle wrapper --gradle-version 8.11.1 --distribution-type bin
  else
    tmp=$(mktemp -d)
    curl -sL "https://services.gradle.org/distributions/gradle-8.11.1-bin.zip" -o "$tmp/g.zip"
    unzip -q "$tmp/g.zip" -d "$tmp"
    "$tmp/gradle-8.11.1/bin/gradle" wrapper --gradle-version 8.11.1 --distribution-type bin
    rm -rf "$tmp"
  fi
fi
echo "  wrapper jar: $(stat -c%s gradle/wrapper/gradle-wrapper.jar) bytes"

# local.properties
if [[ ! -f local.properties ]]; then
  echo "sdk.dir=$ANDROID_HOME" > local.properties
  echo "  wrote local.properties"
fi

cat <<EOF

✓ Setup complete. Add this to your shell profile (~/.bashrc / ~/.zshrc):

  export ANDROID_HOME=$ANDROID_HOME
  export JAVA_HOME=$JAVA_HOME
  export PATH="\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/cmdline-tools/latest/bin:\$PATH"

Common tasks:

  ./gradlew :app:assembleDebug          # build debug APK
  ./gradlew :app:installDebug           # install on attached device
  ./gradlew :app:test                   # unit tests
  ./gradlew :app:lintRelease            # lint
  ./gradlew :app:assembleRelease        # release APK (R8 minified)

Before tagging a release: refresh certificate pins.

  ./scripts/fetch_pins.sh
EOF
