

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
}

variable "region" {
  description = "The AWS region where terraform builds resources."
  type        = string
}