locals {
  helm_values = [{
    externalDatabase = {
      host     = "${var.database.service}"
      port     = 5432
      user     = "postgres"
      database = "postgres"
      password = "${var.database.password}"
    }
    postgresql = {
      enabled = false
    }
    singleuser = {
      extraEnvVars = {
        # MLFLOW_TRACKING_URI = "postgresql+psycopg2://${var.database.user}:${var.database.password}@${var.database.service}:5432/mlflow"
        MLFLOW_TRACKING_URI = "${var.mlflow.cluster_ip}"
        MLFLOW_S3_ENDPOINT_URL = "http://${var.storage.endpoint}"
        AWS_ACCESS_KEY_ID = "${var.storage.access_key}"
        AWS_SECRET_ACCESS_KEY = "${var.storage.secret_access_key}"
      }
    }
    hub = {
      adminUser = "admin"
      password  = "123456"
      extraEnvVars = [
        {
          name  = "MLFLOW_TRACKING_URI"
          value = "postgresql+psycopg2://${var.database.user}:${var.database.password}@${var.database.service}:5432/mlflow"
        },
        {
          name  = "MLFLOW_S3_ENDPOINT_URL"
          value = "http://${var.storage.endpoint}"
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = "${var.storage.access_key}"
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = "${var.storage.secret_access_key}"
        },
      ]
    }
    proxy = {
      ingress = {
        enabled = true
        ingressClassName : "traefik"
        hostname = "jupyterhub.apps.${var.cluster_name}.${var.base_domain}"
        annotations = {
          "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
          "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
          "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
          "traefik.ingress.kubernetes.io/router.tls"         = "true"
          "ingress.kubernetes.io/ssl-redirect"               = "true"
          "kubernetes.io/ingress.allow-http"                 = "false"
        }
        tls = true
      }
    }
  }]
}
