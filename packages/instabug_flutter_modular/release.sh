#!/bin/sh
VERSION=$(egrep -o "version: ([0-9]-*.*)+[0-9]" pubspec.yaml | cut -d ":" -f 2)
if [ ! "${VERSION}" ] || [ -z "${VERSION}" ];then
    echo "Instabug: err: Version Number not found."
    exit 1
else 
    # Remove pubspec_overrides.yaml files before publishing to avoid warnings
    echo "Removing pubspec_overrides.yaml files before publishing..."
    find . -name "pubspec_overrides.yaml" -delete
    
    mkdir -p "/$HOME/Library/Application Support/dart"
    cat <<EOF > "$HOME/Library/Application Support/dart/pub-credentials.json"
    ${PUB_CREDENTIALS}

EOF
    flutter packages pub publish -f
fi