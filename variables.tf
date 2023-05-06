
variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
  default     = "dev"
}


variable "region" {
  description = "The AWS region where terraform build resources."
  type        = string
  default     = "eu-east-1"
}
