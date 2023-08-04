output "keycloak_users" {
  description = "Map containing the credentials of each created user."
  value       = nonsensitive(module.oidc.devops_stack_users_passwords)
  sensitive   = true
}

output "jupyterhub_url" {
  value = module.jupyterhub.endpoint
  sensitive   = true
}
output "mlflow_url" {
  value = module.mlflow.endpoint
  sensitive   = true
}

