##############################################
# 🌍 Provider Variables
##############################################

variable "aws_region" {
  description = "AWS region to deploy infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "availability_zone" {
  description = "AZ for subnet placement"
  type        = string
  default     = "ap-south-1a"
}

##############################################
# 💻 EC2 Configuration
##############################################

variable "instance_type" {
  description = "EC2 instance type for master and worker nodes"
  type        = string
  default     = "m7i-flex.large"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Ubuntu preferred)"
  type        = string
  default     = "ami-02d26659fd82cf299"
}

variable "key_name" {
  description = "Name of the existing AWS key pair to use for SSH access"
  type        = string
  default     = "sumit"   # ✅ Correct — use quotes
}


##############################################
# 🔐 Optional Variables
##############################################

variable "project_name" {
  description = "Project name tag"
  type        = string
  default     = "boardgame"
}
