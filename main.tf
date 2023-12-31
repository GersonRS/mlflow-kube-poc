# Providers configuration

# These providers depend on the output of the respectives modules declared below.
# However, for clarity and ease of maintenance we grouped them all together in this section.

provider "kubernetes" {
  host                   = module.kind.parsed_kubeconfig.host
  client_certificate     = module.kind.parsed_kubeconfig.client_certificate
  client_key             = module.kind.parsed_kubeconfig.client_key
  cluster_ca_certificate = module.kind.parsed_kubeconfig.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.kind.parsed_kubeconfig.host
    client_certificate     = module.kind.parsed_kubeconfig.client_certificate
    client_key             = module.kind.parsed_kubeconfig.client_key
    cluster_ca_certificate = module.kind.parsed_kubeconfig.cluster_ca_certificate
  }
}

provider "argocd" {
  server_addr                 = "127.0.0.1:8080"
  auth_token                  = module.argocd_bootstrap.argocd_auth_token
  insecure                    = true
  plain_text                  = true
  port_forward                = true
  port_forward_with_namespace = module.argocd_bootstrap.argocd_namespace
  kubernetes {
    host                   = module.kind.parsed_kubeconfig.host
    client_certificate     = module.kind.parsed_kubeconfig.client_certificate
    client_key             = module.kind.parsed_kubeconfig.client_key
    cluster_ca_certificate = module.kind.parsed_kubeconfig.cluster_ca_certificate
  }
}

provider "keycloak" {
  client_id                = "admin-cli"
  username                 = module.keycloak.admin_credentials.username
  password                 = module.keycloak.admin_credentials.password
  url                      = "https://keycloak.apps.${local.cluster_name}.${local.base_domain}"
  tls_insecure_skip_verify = true
  initial_login            = false
}

# Module declarations and configuration

module "kind" {
  source = "./modules/kind"

  cluster_name       = local.cluster_name
  kubernetes_version = local.kubernetes_version
}

module "metallb" {
  source = "./modules/metallb"

  subnet = module.kind.kind_subnet

  depends_on = [
    module.kind
  ]
}

module "argocd_bootstrap" {
  source = "./modules/argocd"

  depends_on = [module.metallb]
}

module "traefik" {
  source = "./modules/traefik"

  cluster_name = local.cluster_name

  # TODO fix: the base domain is defined later. Proposal: remove redirection from traefik module and add it in dependent modules.
  # For now random value is passed to base_domain. Redirections will not work before fix.
  base_domain = "172-18-0-100.nip.io"

  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  enable_service_monitor = local.enable_service_monitor

  dependency_ids = {
    argocd = module.argocd_bootstrap.id
  }

  depends_on = [
    module.argocd_bootstrap
  ]
}

module "cert-manager" {
  source = "./modules/cert-manager"

  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  enable_service_monitor = local.enable_service_monitor

  dependency_ids = {
    argocd = module.argocd_bootstrap.id
  }

  depends_on = [
    module.argocd_bootstrap
  ]
}

module "keycloak" {
  source = "./modules/keycloak"

  cluster_name     = local.cluster_name
  base_domain      = local.base_domain
  cluster_issuer   = local.cluster_issuer
  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  dependency_ids = {
    traefik      = module.traefik.id
    cert-manager = module.cert-manager.id
  }

  depends_on = [
    module.traefik,
    module.cert-manager
  ]
}

module "oidc" {
  source = "./modules/oidc"

  cluster_name   = local.cluster_name
  base_domain    = local.base_domain
  cluster_issuer = local.cluster_issuer

  dependency_ids = {
    keycloak = module.keycloak.id
    traefik  = module.traefik.id
    cert     = module.cert-manager.id
  }

  depends_on = [
    module.traefik,
    module.cert-manager,
    module.keycloak,
  ]
}

module "minio" {
  source = "./modules/minio"

  cluster_name     = local.cluster_name
  base_domain      = local.base_domain
  cluster_issuer   = local.cluster_issuer
  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  enable_service_monitor = local.enable_service_monitor

  config_minio = local.minio_config

  oidc = module.oidc.oidc

  dependency_ids = {
    traefik      = module.traefik.id
    cert-manager = module.cert-manager.id
    oidc         = module.oidc.id
  }

  depends_on = [
    module.traefik,
    module.cert-manager,
    module.oidc,
  ]
}

module "postgresql" {
  source = "./modules/postgresql"

  cluster_name     = local.cluster_name
  base_domain      = local.base_domain
  cluster_issuer   = local.cluster_issuer
  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  enable_service_monitor = local.enable_service_monitor

  dependency_ids = {
    traefik      = module.traefik.id
    cert-manager = module.cert-manager.id
    oidc         = module.oidc.id
  }

  depends_on = [
    module.traefik,
    module.cert-manager,
    module.oidc,
  ]
}

module "mlflow" {
  source = "./modules/mlflow"

  cluster_name     = local.cluster_name
  base_domain      = local.base_domain
  cluster_issuer   = local.cluster_issuer
  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  enable_service_monitor = local.enable_service_monitor

  oidc = module.oidc.oidc

  storage = {
    bucket_name       = "mlflow"
    endpoint          = module.minio.cluster_dns
    access_key        = module.minio.minio_root_user_credentials.username
    secret_access_key = module.minio.minio_root_user_credentials.password
  }

  database = {
    user     = module.postgresql.credentials.user
    password = module.postgresql.credentials.password
    database = module.postgresql.credentials.database
    service  = module.postgresql.service
  }

  dependency_ids = {
    traefik      = module.traefik.id
    cert-manager = module.cert-manager.id
    oidc         = module.oidc.id
    minio        = module.minio.id
    postgresql   = module.postgresql.id
  }

  depends_on = [
    module.traefik,
    module.cert-manager,
    module.oidc,
    module.minio,
    module.postgresql
  ]
}

module "jupyterhub" {
  source = "./modules/jupyterhub"

  cluster_name     = local.cluster_name
  base_domain      = local.base_domain
  cluster_issuer   = local.cluster_issuer
  argocd_namespace = module.argocd_bootstrap.argocd_namespace

  enable_service_monitor = local.enable_service_monitor

  oidc = module.oidc.oidc

  storage = {
    bucket_name       = "jupyterhub"
    endpoint          = module.minio.cluster_dns
    access_key        = module.minio.minio_root_user_credentials.username
    secret_access_key = module.minio.minio_root_user_credentials.password
  }

  database = {
    user     = module.postgresql.credentials.user
    password = module.postgresql.credentials.password
    database = module.postgresql.credentials.database
    service  = module.postgresql.service
  }

  mlflow = {
    cluster_ip = module.mlflow.cluster_ip
  }

  dependency_ids = {
    traefik      = module.traefik.id
    cert-manager = module.cert-manager.id
    oidc         = module.oidc.id
    minio        = module.minio.id
    postgresql   = module.postgresql.id
    mlflow       = module.mlflow.id
  }

  depends_on = [
    module.traefik,
    module.cert-manager,
    module.oidc,
    module.minio,
    module.postgresql,
    module.mlflow,
  ]
}
