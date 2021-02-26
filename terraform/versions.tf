terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "4.5.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "2.18.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.5.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }
  }
  required_version = ">= 0.14"
}
