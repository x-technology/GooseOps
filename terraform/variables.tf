variable "do_token" {
  type = string
  description = "DigitalOcean access token"
}

variable "github_registry_username" {
  type = string
  description = "Username for auth with github registry"
}

variable "github_registry_token" {
  type = string
  description = "Token for auth with github registry"
}

variable "cloudflare_token" {
  type        = string
  description = "CloudFlare Token for domain creation"
}

variable "cloudflare_email" {
  type        = string
  description = "CloudFlare email for domain creation"
}

variable "cloudflare_zone" {
  type        = string
  description = "CloudFlare zone_id for domain creation"
}

variable "project" {
  type = object({
    name = string
    envs = list(object({
      name = string
      domain = string
    }))
  })
  description = "Project description"
}

variable "domain" {
  type = string
  description = "Project domain"
}

variable "region" {
  type = string
  default = "lon1"
  description = "Region where all the infra will be placed"
}

variable "net_cidr" {
  type = string
  description = "This is a private subnet which all resources will belog to"
  default = "10.1.0.0/24"
}

variable "node_count" {
  type = number
  description = "Number of worker nodes in the cluster"
}

variable "tags" {
  type = list(string)
  default = [
    "goose-ops",
    "demo"
  ]
  description = "Tags which will be assigned on every resource"
}

variable "instance_type" {
  type = string
  default = "s-1vcpu-1gb"
}
