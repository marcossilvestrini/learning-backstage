[![ESLint](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/eslint.yml/badge.svg?branch=main)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/eslint.yml)

[![njsscan sarif](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/njsscan.yml/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/njsscan.yml)

[![pages-build-deployment](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/pages/pages-build-deployment)

[![PSScriptAnalyzer](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/powershell.yml/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/powershell.yml)

[![CodeQL](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/github-code-scanning/codeql)

# Learning Backstage

## Official Documentation

[Official Documentation](https://backstage.io/docs/overview/what-is-backstage>)

## Get Started

[Backstage Tutorial](https://backstage.io/docs/getting-started/)
[Spotify Tutorial](https://backstage.spotify.com/blog/introducing-backstage-learn)

## Configure Postgresql

## Install plugins

```sh
# From your Backstage root directory
yarn add --cwd packages/backend pg
```

### Set your .env variables

```sh
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=backstage
```

### Set app-config.yaml

```yaml
backend:
  database:
    client: pg
    connection:
      host: ${POSTGRES_HOST}
      port: ${POSTGRES_PORT}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
          pluginDivisionMode: schema
    plugin:
      catalog:
        connection:
          database: backstage_db
      auth:
        connection:
          database: backstage_db
      app:
        connection:
          database: backstage_db
      scaffolder:
        connection:
          database: backstage_db
```

## Access Backstage remotely

```ssh
# Create ssh tunel
ssh -L 3000:localhost:3000 -L 7007:localhost:7007 vagrant@192.168.0.150
# Access in browser
http://localhost:3000
```
