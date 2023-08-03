locals {
  credentials = {
    user     = "moderndevopsadmin"
    password = resource.random_password.password_secret.result
    database = "mlflow"
  }
  helm_values = [{
    volumePermissions = {
      enabled = true
    }
    global = {
      postgresql = {
        auth = {
          username       = local.credentials.user
          database       = local.credentials.database
          existingSecret = "postgres-secrets"
          secretKeys = {
            adminPasswordKey       = "postgres-password"
            userPasswordKey        = "password"
            replicationPasswordKey = "replication-password"
          }
        }
      }
    }
    image = {
      debug = true
    }
    primary = {
      service = {
        type = "LoadBalancer"
      }
      persistence = {
        size = "10Gi"
      }
      # configuration = {
      #   huge_pages       = "off"
      #   listen_addresses = "*"
      #   port             = "5432"
      #   max_wal_size     = "16000MB"
      #   min_wal_size     = "4000MB"
      # }
      # extraVolumeMounts = [{
      #   name      = "pg-sample-config"
      #   mountPath = "/opt/bitnami/postgresql/share/postgresql-conf-sample"
      #   subPath   = "postgresql-conf-sample"
      # }]
      # extraVolumes = [{
      #   configMap = {
      #     name = "pg-sample-config"
      #   }
      #   name = "pg-sample-config"
      # }]
    }
    # extraDeploy = [{
    #   apiVersion = "v1"
    #   kind       = "ConfigMap"
    #   metadata = {
    #     name = "pg-sample-config"
    #   }
    #   data = {
    #     postgresql-conf-sample = {
    #       huge_pages = "off"
    #     }
    #   }
    # }]
  }]
}
