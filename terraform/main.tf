provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  insecure = true
  token    = digitalocean_kubernetes_cluster.k8s-cluster.kube_config.0.token
  host     = digitalocean_kubernetes_cluster.k8s-cluster.kube_config.0.host
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_token
}

resource "digitalocean_vpc" "net" {
  name     = "${var.project.name}-net"
  region   = var.region
  ip_range = var.net_cidr
}

data "digitalocean_kubernetes_versions" "k8s" {}

resource "digitalocean_kubernetes_cluster" "k8s-cluster" {
  name    = "${var.project.name}-cluster"
  region  = var.region
  tags    = var.tags
  version = data.digitalocean_kubernetes_versions.k8s.latest_version

  node_pool {
    name       = "default"
    size       = var.instance_type
    node_count = var.node_count
  }

  vpc_uuid = digitalocean_vpc.net.id
}

data "digitalocean_droplets" "nodes" {
  filter {
    key    = "name"
    values = digitalocean_kubernetes_cluster.k8s-cluster.node_pool.0.nodes.*.name
  }
}

resource "local_file" "kubeconfig" {
  sensitive_content = digitalocean_kubernetes_cluster.k8s-cluster.kube_config.0.raw_config
  filename          = "${path.module}/.kube/config.yaml"
}

module "k8s-setup" {
  source       = "./modules/k8s-setup"
  project      = var.project.name
  environments = var.project.envs.*.name

  providers = {
    kubernetes = kubernetes
  }
}

module "k8s-lb" {
  source                      = "./modules/cloud-lb"
  namespace                   = module.k8s-setup.ingress-namespace
  ingress-service-annotations = {
    "service.beta.kubernetes.io/do-loadbalancer-name" = "${var.project.name}-balancer"
  }
  providers                   = {
    kubernetes = kubernetes
  }
}

resource "cloudflare_record" "records" {
  for_each = toset(var.project.envs.*.domain)

  zone_id = var.cloudflare_zone
  name    = each.key
  value   = module.k8s-lb.external-ip
  proxied = true
  type    = "A"
}
