variable "project" {
  type = string
  description = "Main project name"
}

variable "environments" {
  type = list(string)
  default = [
    "prod"
  ]
}
