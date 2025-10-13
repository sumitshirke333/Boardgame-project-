##############################################
# 🌐 Essential Outputs
##############################################

# Master Node Public IP
output "master_public_ip" {
  description = "Public IP of the Master (Jenkins + Ansible) Node"
  value       = aws_instance.master_node.public_ip
}

# Worker Node Public IP
output "worker_public_ip" {
  description = "Public IP of the Worker (Application) Node"
  value       = aws_instance.worker_node.public_ip
}
