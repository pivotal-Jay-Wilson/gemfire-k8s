
variable "reg" {
  description = "Docker Registry user"
}

variable "reguser" {
  description = "Registry user"
}

variable "regpassword" {
  description = "Registry Password"
}

variable "config_path" {
  description = "kubernetes config name"
}

variable "gemfire_op_version" {
  description = "operator version"
}

variable "namespaces" {
  type = set(string)
  default = ["uk", "us", "ingress-basic", "gemfire-operator"]
}
