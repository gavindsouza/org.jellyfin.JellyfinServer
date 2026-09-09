#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <version> [description]" >&2
  echo "Prepends a release entry to org.jellyfin.JellyfinServer.metainfo.xml." >&2
  exit 1
}

XML_FILE="org.jellyfin.JellyfinServer.metainfo.xml"

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  usage
fi

DESC="${2:-Updated Jellyfin and Jellyfin Web to $VERSION}"

DATE=$(date +"%Y-%m-%d")

TEMP_FILE=$(mktemp)

xmlstarlet ed -P \
  -i "/component/releases/release[1]" -t elem -n "release" \
  -s "/component/releases/release[1]" -t attr -n "version" -v "$VERSION" \
  -s "/component/releases/release[1]" -t attr -n "date" -v "$DATE" \
  -s "/component/releases/release[1]" -t elem -n "description" -v "" \
  -s "/component/releases/release[1]/description" -t elem -n "p" -v "$DESC" \
  "$XML_FILE" | xmlstarlet fo -s 2 > "$TEMP_FILE"

mv "$TEMP_FILE" "$XML_FILE"

echo "Added release version=$VERSION date=$DATE to $XML_FILE"
