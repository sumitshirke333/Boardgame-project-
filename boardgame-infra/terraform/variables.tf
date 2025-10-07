variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ubuntu_ami" {
  description = "AMI ID for Ubuntu (region-specific, e.g. ami-0123456789abcdef0)"
  type        = string
  default     = "ami-02d26659fd82cf299" # leave empty and pass via -var or set a value here
}


variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "m7i-flex.large"
}

variable "key_name" {
  description = "Key pair name to create in AWS"
  type        = string
  default     = "sumit"
}

variable "docker_image" {
  description = "Docker image to run"
  type        = string
  default     = "sumitshirke369/boardgame:latest"
}
