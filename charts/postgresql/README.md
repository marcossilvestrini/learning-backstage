# Helm Chart PostgreSQL Cluster

Este Helm chart cria e configura um Cluster PostgreSQL no Kubernetes.

## Pré-requisitos

- Kubernetes 1.12+
- CloudNativePG Operator
- Helm 3.0+

## Instalação

### CloudNativePG Operator

```sh
curl -sSfL \
  https://raw.githubusercontent.com/cloudnative-pg/artifacts/main/manifests/operator-manifest.yaml | \
  kubectl apply -f -
```

### Cluster PostgreSQL

Para instalar o chart com o nome de release `meu-postgres`:

Metodo 1:

```bash
git clone https://gitlab.luizalabs.com/magalu-cloud-iaas/infrastructure/solutions/backstage/cluster-ms-dev.git
cd charts/argocd/postgresql
# Preencha os valores desejados em values.yaml
helm upgrade --install meu-postgres .

```

## Remover

Para remover o chart com o nome de release `meu-postgres`:

```bash
helm uninstall meu-postgres
```

## Configuração

O arquivo values.yaml contém parâmetros que podem ser ajustados durante a instalação.

### Parâmetros Importantes

- **cluster.imageName:** Imagem do PostgreSQL a ser usada.
- **cluster.name:** Nome do cluster PostgreSQL.
- **namespace:** namespace para o cluster
- **appUser.password:** usuario para secret postgres-user(base64)
- **appUser.username:** senha para secret postgres-user(base64)
- **bootstrap.database:** nome do banco de dados da aplicação
- **owner.database:** nome do usuario do banco de dados da aplicação

- **backup.barmanObjectStore.destinationPath:** Caminho de destino para backups (deixe em branco para desativar).

## Uso

Após a instalação, você pode gerenciar o cluster PostgreSQL usando kubectl ou outras ferramentas compatíveis com Kubernetes.

Para mais detalhes, veja a documentação oficial do operador PostgreSQL.

<https://cloudnative-pg.io/>

## Suporte e Contribuições

Este é um projeto de código aberto. Contribuições são bem-vindas através de [pull requests](https://gitlab.luizalabs.com/magalu-cloud-iaas/infrastructure/solutions/cluster-ms-dev/-/issues) no repositório do Gitlab.

## Licença

Este Helm chart é distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE)para mais detalhes.