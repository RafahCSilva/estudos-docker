#!/usr/bin/env bash

# install (https://github.com/shyiko/kubetpl)
[ ! -f /usr/local/bin/kubetpl ] &&
  (echo "Installing kubetpl ...." &&
    curl \
      -sSL https://github.com/shyiko/kubetpl/releases/download/0.9.0/kubetpl-0.9.0-$(bash -c '[[ $OSTYPE == darwin* ]] && echo darwin || echo linux')-amd64 \
      -o kubetpl &&
    chmod a+x kubetpl &&
    sudo mv kubetpl /usr/local/bin/ &&
    echo "  Installed in /usr/local/bin/kubetpl")

echo "Generating..."
rm -rf generated/*

FILES="00_namespace.yml
01_mysql.yml
02_redis.yml
05_webapp.yml
06_webapp-ingress.yml"

for FILE in $FILES; do
  echo " - $FILE"
  kubetpl \
    render "./template/$FILE" \
    -i ./dev-DockerHubRegistry.env \
    -x=$ \
    >"./generated/$FILE"
    #| kubectl apply -f -
done
echo "Generated!"
