
#!/bin/bash

nodejs=$(cat $PWD/utils/get_keys.json | jq -r '.nodejs')

if [ "$nodejs" = true ]; then
  echo "Descargando listado de versiones de NODEJS"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

  source ~/.nvm/nvm.sh
  latest_version=$(nvm list-remote | tail -1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo "Instalando la Version de NODEJS $latest_version"
  nvm install "$latest_version"

fi



