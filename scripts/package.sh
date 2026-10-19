#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
out=${1:-"$root/dist"}
mkdir -p "$out"
out=$(CDPATH= cd -- "$out" && pwd)
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT HUP INT TERM

# Include local rules and configuration, but let sync fetch dependencies.
mkdir -p "$stage/Hemingway/styles"
cp "$root/.vale.ini" "$stage/Hemingway/"
cp -R "$root/styles/Hemingway" "$stage/Hemingway/styles/"
rm -f "$out/Hemingway.zip"
(cd "$stage" && zip -qr "$out/Hemingway.zip" Hemingway)
printf '%s\n' "$out/Hemingway.zip"
