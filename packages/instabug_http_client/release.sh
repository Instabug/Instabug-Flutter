#!/bin/sh
VERSION=$(egrep -o "version: ([0-9]-*.*)+[0-9]" pubspec.yaml | cut -d ":" -f 2)
if [ ! "${VERSION}" ] || [ -z "${VERSION}" ];then
    echo "Instabug: err: Version Number not found."
    exit 1
else
    mkdir -p .pub-cache
    cat <<EOF > $HOME/.pub-cache/credentials.json
    ${PUB_CREDENTIALS}

EOF
    flutter packages pub publish -f
fi