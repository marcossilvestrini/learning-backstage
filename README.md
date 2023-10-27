[![ESLint](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/eslint.yml/badge.svg?branch=main)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/eslint.yml)

[![njsscan sarif](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/njsscan.yml/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/njsscan.yml)

[![pages-build-deployment](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/pages/pages-build-deployment)

[![PSScriptAnalyzer](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/powershell.yml/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/powershell.yml)

[![CodeQL](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/marcossilvestrini/learning-backstage/actions/workflows/github-code-scanning/codeql)

# Learning Backstage

## Docs

[Official Documentation](https://backstage.io/docs/overview/what-is-backstage>)
[Auth](https://github.com/RoadieHQ/backstage-auth-example/blob/main/README.md)

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

http://backstage.skynet.com.br/api/auth/github/handler/frame

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
...
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

#### Configure .env with github secret

```env
export AUTH_GITHUB_CLIENT_ID="fobarbeer"
export AUTH_GITHUB_CLIENT_SECRET="foobarbeer"
```

#### Test github callback

```html
http://backstage.skynet.com.br:7007/api/auth/github/start?env=development
```

### Gitlab

#### Create gitlab Application

![gitlab](https://github.com/RoadieHQ/backstage-auth-example/raw/gitlab/docs/static/gitlab_auth_setup.png)

If you use nginx proxy, this is example:

http://backstage.skynet.com.br/api/auth/github/handler/frame

#### Configure frontend

*packages\app\src\App.tsx*

```ts
import { gitlabAuthApiRef } from '@backstage/core-plugin-api';
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
            id: 'gitlab-auth-provider',
            title: 'Gitlab',
            message: 'Sign in using Gitlab',
            apiRef: gitlabAuthApiRef,
          },          
        ]}
      />
    ),
  },
```

#### Configure backend

*packages\backend\src\plugins\auth.ts*

```ts
...
providerFactories: {
      ...defaultAuthProviderFactories,     
      gitlab: providers.gitlab.create({
        signIn: {
          resolver(_, ctx) {
            const userRef = 'user:default/guest'; // Must be a full entity reference
            return ctx.issueToken({
              claims: {
                sub: userRef, // The user's own identity
                ent: [userRef], // A list of identities that the user claims ownership through
              },
            });
          },
          // resolver: providers.github.resolvers.usernameMatchingUserEntityName(),
        },
      }),     
    },
```

#### Configure app

```yaml
...
enableExperimentalRedirectFlow: true
auth:
  # see https://backstage.io/docs/auth/ to learn about auth providers  
  environment: development  
  providers:
    gitlab:      
      development:
        clientId: ${AUTH_GITLAB_CLIENT_ID}
        clientSecret: ${AUTH_GITLAB_CLIENT_SECRET}
        ## uncomment if using a custom redirect URI      
        callbackUrl: http://backstage.skynet.com.br/api/auth/gitlab/handler/frame
        ## uncomment if using self-hosted GitLab
        # audience: https://gitlab.company.com
        # audience : https://gitlab.com        
```

#### Configure .env with gitlab secrets

```env
export GITLAB_BASE_URL=https://gitlab.com
export AUTH_GITLAB_CLIENT_ID=foobarbeer
export AUTH_GITLAB_CLIENT_SECRET=foobarbeer
```

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
