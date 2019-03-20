#!/bin/sh
# VERSION=v$(egrep -o "version: ([0-9]-*.*)+[0-9]" pubspec.yaml | cut -d ":" -f 2)
# if [ ! "${VERSION}" ] || [ -z "${VERSION}" ];then
#     echo "Instabug: err: Version Number not found."
#     exit 1
# else 
#     pub global activate grinder
#     flutter packages get
#     grind auto-publish
#     OWNER="Instabug"
#     REPOSITORY="Instabug-Flutter"
#     ACCESS_TOKEN=${RELEASE_GITHUB_TOKEN}
#     VERSION=$(echo ${VERSION} | sed 's/ //1')
#     echo ${VERSION}
#     curl --data '{"tag_name": "'$VERSION'",
#                 "target_commitish": "master",
#                 "name": "'$VERSION'",
#                 "body": "Release of version '$VERSION'",
#                 "draft": false,
#                 "prerelease": false}'  https://api.github.com/repos/$OWNER/$REPOSITORY/releases?access_token=$ACCESS_TOKEN
#     echo "https://api.github.com/repos/$OWNER/$REPOSITORY/releases?access_token=$ACCESS_TOKEN"
# fi
mkdir -p .pub-cache

cat <<EOF > $HOME/.pub-cache/credentials.json
{
  "accessToken":"${ACCESS_TOKEN}",
  "refreshToken":"${REFRESH_TOKEN}",
  "tokenEndpoint":"${TOKEN_ENDPOINT}",
  "scopes":["openid","https://www.googleapis.com/auth/userinfo.email"],
  "expiration":${EXPIRATION}
}
EOF

pub publish -f
