# Tiltfile https://gitlab.luizalabs.com/magalu-cloud-iaas/infrastructure/solutions/api

tiltfile_path = config.main_path

# Welcome to tilt
if config.tilt_subcommand == 'up':  
  print("""
  \033[32m\033[32m🎉 Bem-vindo ao Tilt! Sua configuração está sendo processada...🎉\033[0m

  Se esta é a sua primeira vez usando o Tilt e você gostaria de alguma orientação, temos um tutorial para acompanhar este projeto:
  https://docs.tilt.dev/tutorial

  Se você está se sentindo particularmente aventureiro, tente abrir {tiltfile} em um editor e fazer algumas alterações enquanto o Tilt está em execução.
  O que acontece se você introduzir intencionalmente um erro de sintaxe? Você consegue corrigi-lo?
  """.format(tiltfile=tiltfile_path))

# Load resource functions
load('ext://git_resource', 'git_checkout')
load('ext://helm_resource', 'helm_resource', 'helm_repo')
load('ext://dotenv', 'dotenv')

# Set kubernetes context
allow_k8s_contexts('local')
allow_k8s_contexts('k3d-backstage')
local_resource(
  'copy-kubeconfig', 
  cmd='k3d kubeconfig write backstage -o tmp/kubeconfig.yaml',
  labels=['set-cluster']
)

# Set environments variables
dotenv(fn='.env')

# Build backstage image
local_resource(
  name='build-backstage',
  cmd='''
  yarn install --frozen-lockfile;
  yarn tsc;
  yarn build:backend --config ../../app-config.yaml
  ''',
  labels=['build']
)
docker_build(
    'registry-local/backstage:1.0.0',
    context='.',    
    dockerfile='packages/backend/Dockerfile',        
    live_update=[
      sync('./packages/backend', '/app/packages/backend'),
      sync('./packages/app', '/app/packages/app'),
      sync('./plugins/', '/app/plugins/'),
      sync('./app-config.yaml', '/app/app-config.yaml'),
      run(
        'yarn install',
        trigger=['./package.json', './yarn.lock', './packages/backend/package.json', './packages/app/package.json', './plugins/helm-tools/package.json']
      )
    ]    
)

backstage = helm(
  './charts/backstage/',  
  name = 'backstage',
  namespace = 'backstage',
  values = ['./charts/backstage/values.yaml'],
  set=[
    'global.imageRegistry=registry-local',
    'ingress.enabled=true',
    'ingress.host=backstage.dev',
    'backstage.replicas=1',
    'backstage.image.registry=registry-local',
    'backstage.image.repository=backstage',
    'backstage.image.tag=1.0.0',
    'backstage.image.pullPolicy=Always'
  ]  
)

# Deployment backstage
k8s_yaml(backstage)

k8s_resource(
  'backstage',  
  labels=['backstage-service']
)

# Expose services
# k8s_resource(
#   'backstage',
#   port_forwards='7007:7008',
#   labels=['frontend']
#  )
