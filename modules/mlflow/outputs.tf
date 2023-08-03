output "id" {
  description = "ID to pass other modules in order to refer to this module as a dependency."
  value       = resource.null_resource.this.id
}

output "cluster_ip" {
  value = data.kubernetes_service.mlflow.spec[0].cluster_ip
}

output "endpoint" {
  description = "MinIO endpoint where the buckets are available."
  value       = "mlflow.${var.namespace}.svc.cluster.local:5000"
}