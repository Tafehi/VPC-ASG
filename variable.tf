variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

variable "environment" {
  description = "Environment name"
  default     = "EM"
}

variable "Desired_capacity" {
  type    = number
  default = 3
}
variable "Min_size" {
  type    = number
  default = 2
}
variable "Max_size" {
  type    = number
  default = 5
}
