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

## Configure Auth

### Github

#### Create github Application

![github](https://backstage.io/assets/images/gh-oauth-6ba1157307d9e1a95301a49e9ee1b05b.png)

If you use nginx proxy, this is example:

http://backstage.skynet.com.br

http://backstage.skynet.com.br/api/auth/github/handler/frame.

Enable device flow option

#### Configure frontend

*packages\app\src\App.tsx*

```ts
import { githubAuthApiRef } from '@backstage/core-plugin-api';
import { SignInPage } from '@backstage/core-components';

...
const app = createApp({
  apis,
  components: {
    SignInPage: props => (
      <SignInPage
        {...props}
        providers={[
          'guest',
          {
            id: 'github-auth-provider',
            title: 'GitHub',
            message: 'Sign in using GitHub',
            apiRef: githubAuthApiRef,
          },          
        ]}
      />
    ),
  },
```

#### Configure app

```yaml
enableExperimentalRedirectFlow: true
auth:
  # see https://backstage.io/docs/auth/ to learn about auth providers  
  environment: development  
  providers:    
    github:      
      development:
        clientId: ${AUTH_GITHUB_CLIENT_ID}
        clientSecret: ${AUTH_GITHUB_CLIENT_SECRET}  
```

#### Configure .env

```env
export AUTH_GITHUB_CLIENT_ID="fobarbeer"
export AUTH_GITHUB_CLIENT_SECRET="foobarbeer"
```

#### Test github callback

```html
http://backstage.skynet.com.br:7007/api/auth/github/start?env=development
```

### Gitlab

#### Test gitlab callback

```html
http://backstage.skynet.com.br:7007/api/auth/gitlab/start?env=development
```

## Access Backstage remotely

```ssh
# Create ssh tunel
ssh -L 3000:localhost:3000 -L 7007:localhost:7007 vagrant@192.168.0.150
# Access in browser
http://localhost:3000
```
