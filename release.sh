#!/bin/sh
VERSION=$(egrep -o "version: ([0-9]-*.*)+[0-9]" pubspec.yaml | cut -d ":" -f 2)
if [ ! "${VERSION}" ] || [ -z "${VERSION}" ];then
    echo "Instabug: err: Version Number not found."
    exit 1
else 
    mkdir -p .pub-cache
    cat <<EOF > $HOME/.pub-cache/credentials.json
    {
        "accessToken":"${ACCESS_TOKEN}",
        "refreshToken":"${REFRESH_TOKEN}",
        "tokenEndpoint":"https://accounts.google.com/o/oauth2/token",
        "scopes":["https://www.googleapis.com/auth/userinfo.email","openid"],
        "expiration":${EXPIRATION}
    }
EOF
    flutter packages pub publish -f

    OWNER="Instabug"
    REPOSITORY="Instabug-Flutter"
    ACCESS_TOKEN=${RELEASE_GITHUB_TOKEN}
    VERSION=$(echo ${VERSION} | sed 's/ //1')
    curl --data '{"tag_name": "'$VERSION'",
                "target_commitish": "master",
                "name": "'$VERSION'",
                "body": "Release of version '$VERSION'",
                "draft": false,
                "prerelease": false}'  https://api.github.com/repos/$OWNER/$REPOSITORY/releases?access_token=$ACCESS_TOKEN
    echo "https://api.github.com/repos/$OWNER/$REPOSITORY/releases?access_token=$ACCESS_TOKEN"
fi

