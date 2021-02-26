output "ingress-namespace" {
  value = kubernetes_namespace.ingress_nginx.id
}
