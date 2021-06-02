
variable "environment" {
  description = "Environment name"
  default     = "EM"
}

variable "SecurityGroupId" {
  description = "sg ID"
}

variable "PATH_TO_Cert" {
  default = "./cert/cert.pem"

}

variable "PATH_TO_Key" {
  default = "./cert/key.pem"
}

variable "public_subnets" {
  description = "List of private subnet IDs"
}

variable "server_port" {
  description = "The port number the web server on each EC2 Instance should listen on for HTTP requests"
  type        = number
  default     = 443
}


variable "elb_port" {
  description = "The port number the ELB should listen on for HTTP requests"
  type        = number
  default     = 443
}
