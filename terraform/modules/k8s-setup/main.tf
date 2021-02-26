resource "kubernetes_namespace" "k8s-namespace" {
  for_each = toset(var.environments)
  metadata {
    name = each.value

    labels = {
      project = var.project
    }
  }
}
