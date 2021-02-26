variable "ingress-service-annotations" {
  type = map(string)
  default = {}
  description = "list of annotations for ingress service"
}

variable "namespace" {
  type = string
}
