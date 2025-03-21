#!/usr/bin/env bash
flutterReleaseJson=$(curl -s "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json")

flutterVersion=$(jq -r '[.releases[] | select(.channel=="stable")][0].version' <<< $flutterReleaseJson)

echo $flutterVersion