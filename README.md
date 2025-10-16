# 🎯 Automated DevOps Pipeline for Board Game Web Application

> A production-grade CI/CD pipeline implementing Infrastructure as Code, automated security scanning, containerization, and real-time monitoring on AWS

[![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![SonarQube](https://img.shields.io/badge/SonarQube-Quality-4E9BCD?logo=sonarqube&logoColor=white)](https://www.sonarqube.org/)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Prerequisites](#-prerequisites)
- [Implementation Guide](#-implementation-guide)
- [Pipeline Stages](#-pipeline-stages)
- [Monitoring & Observability](#-monitoring--observability)
- [Security Implementation](#-security-implementation)
- [Screenshots](#-screenshots)
- [Troubleshooting](#-troubleshooting)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

This project showcases a comprehensive DevOps implementation for a Spring Boot-based Board Game Listing application. It demonstrates enterprise-level practices including automated infrastructure provisioning, continuous integration/delivery, security scanning, containerization, and monitoring.

### Key Objectives

- **Automation First**: Zero-touch deployment from code commit to production
- **Security by Design**: Integrated vulnerability scanning and code quality gates
- **Observable Systems**: Real-time metrics and monitoring dashboards
- **Infrastructure as Code**: Reproducible and version-controlled infrastructure
- **Scalability Ready**: Architecture designed for horizontal scaling

---

## 🏗️ Architecture

```
┌─────────────┐
│   GitHub    │
│ Repository  │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────────────────────┐
│                    Master Node (EC2)                    │
│  ┌─────────┐  ┌──────────┐  ┌───────────┐  ┌────────┐ │
│  │ Jenkins │  │SonarQube │  │Prometheus │  │Grafana │ │
│  └────┬────┘  └─────┬────┘  └─────┬─────┘  └───┬────┘ │
└───────┼────────────┼──────────────┼─────────────┼──────┘
        │            │              │             │
        ▼            ▼              │             │
   ┌────────┐  ┌─────────┐         │             │
   │ Maven  │  │ Trivy   │         │             │
   │ Build  │  │ Scanner │         │             │
   └───┬────┘  └────┬────┘         │             │
       │            │              │             │
       ▼            ▼              │             │
   ┌────────────────────┐          │             │
   │    Docker Hub      │          │             │
   │  (Image Registry)  │          │             │
   └─────────┬──────────┘          │             │
             │                     │             │
             ▼                     ▼             ▼
   ┌─────────────────────────────────────────────────────┐
   │              Worker Node (EC2)                      │
   │  ┌──────────────────┐      ┌──────────────────┐   │
   │  │  Docker Container│      │  Node Exporter   │   │
   │  │  (Board Game App)│      │  (System Metrics)│   │
   │  │  Port: 8080      │      │  Port: 9100      │   │
   │  └──────────────────┘      └──────────────────┘   │
   └─────────────────────────────────────────────────────┘
```

### Architecture Highlights

- **Separation of Concerns**: Master node handles CI/CD and monitoring, worker node runs application
- **Security Layers**: Code analysis, vulnerability scanning, and isolated deployment
- **Metrics Collection**: Prometheus scrapes both application and infrastructure metrics
- **Single Source of Truth**: All infrastructure defined in Terraform

---

## 🛠️ Technology Stack

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| **Cloud Provider** | AWS EC2 | - | Compute infrastructure |
| **IaC** | Terraform | 1.0+ | Infrastructure provisioning and management |
| **CI/CD** | Jenkins | 2.x | Pipeline orchestration and automation |
| **Build Tool** | Maven | 3.8+ | Java application build and dependency management |
| **Code Quality** | SonarQube | 9.x | Static code analysis and quality gates |
| **Security Scan** | Trivy | Latest | Container vulnerability scanning |
| **Containerization** | Docker | 20.x+ | Application containerization |
| **Registry** | Docker Hub | - | Container image storage |
| **Monitoring** | Prometheus | 2.x | Metrics collection and storage |
| **Visualization** | Grafana | 9.x+ | Metrics dashboards and alerting |
| **System Metrics** | Node Exporter | 1.x | Linux system metrics exposure |

---

## ✅ Prerequisites

Before starting, ensure you have:

### Required Accounts
- AWS Account with appropriate permissions
- Docker Hub account
- GitHub account

### Required Tools
```bash
# Terraform
terraform --version  # v1.0 or higher

# AWS CLI (configured with credentials)
aws --version

# Git
git --version

# SSH key pair for EC2 access
```

### Required Knowledge
- Basic understanding of Linux commands
- Familiarity with CI/CD concepts
- Basic networking knowledge (security groups, ports)

---

## 🚀 Implementation Guide

### Step 1: Infrastructure Provisioning

#### 1.1 Clone the Repository
```bash
git clone <repository-url>
cd boardgame-devops-pipeline
```

#### 1.2 Configure Terraform Variables
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your AWS credentials and preferences
```

#### 1.3 Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

**Expected Output:**
```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:
master_node_ip = "xx.xx.xx.xx"
worker_node_ip = "yy.yy.yy.yy"
```

#### 1.4 Verify EC2 Instances
```bash
aws ec2 describe-instances --filters "Name=tag:Project,Values=BoardGame" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]'
```

---

### Step 2: Jenkins Configuration

#### 2.1 Access Jenkins
```
URL: http://<master-node-ip>:8080
```

#### 2.2 Initial Setup
```bash
# SSH into master node
ssh -i your-key.pem ubuntu@<master-node-ip>

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

#### 2.3 Install Required Plugins
- SonarQube Scanner
- Docker Pipeline
- SSH Agent
- Pipeline
- Git

#### 2.4 Configure Credentials
Navigate to: `Manage Jenkins > Credentials > System > Global credentials`

Add the following:

| Credential Type | ID | Description |
|----------------|-------|-------------|
| SSH Username with private key | `ec2-ssh-key` | Worker node SSH access |
| Secret text | `sonarqube-token` | SonarQube authentication |
| Username with password | `dockerhub-creds` | Docker Hub push access |

#### 2.5 Create Pipeline Job
```groovy
// Create new Pipeline job
Name: boardgame-pipeline
Pipeline script from SCM: Git
Repository URL: <your-repo-url>
Script Path: Jenkinsfile
```

---

### Step 3: SonarQube Setup

#### 3.1 Access SonarQube
```
URL: http://<master-node-ip>:9000
Default credentials: admin/admin
```

#### 3.2 Generate Token
```
User > My Account > Security > Generate Token
Name: jenkins-integration
Save the token securely
```

#### 3.3 Configure Quality Gate
```
Quality Gates > Create
Add conditions:
- Coverage > 80%
- Bugs > 0
- Vulnerabilities > 0
- Code Smells > 10
```

#### 3.4 Configure Jenkins Integration
```
Administration > Configuration > Webhooks
Create: http://<jenkins-ip>:8080/sonarqube-webhook/
```

---

### Step 4: Docker Configuration

#### 4.1 Dockerfile
```dockerfile
FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/boardgame.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

#### 4.2 Build and Push
```bash
docker build -t <dockerhub-username>/boardgame:latest .
docker push <dockerhub-username>/boardgame:latest
```

---

### Step 5: Monitoring Setup

#### 5.1 Prometheus Configuration
```bash
# SSH to master node
sudo nano /etc/prometheus/prometheus.yml
```

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['<worker-node-ip>:9100']

  - job_name: 'boardgame-app'
    static_configs:
      - targets: ['<worker-node-ip>:8080']
    metrics_path: '/actuator/prometheus'
```

```bash
sudo systemctl restart prometheus
```

#### 5.2 Grafana Configuration
```
URL: http://<master-node-ip>:3000
Default credentials: admin/admin
```

**Add Data Source:**
1. Configuration > Data Sources > Add data source
2. Select Prometheus
3. URL: `http://localhost:9090`
4. Save & Test

**Import Dashboard:**
1. Create > Import
2. Dashboard ID: `1860` (Node Exporter Full)
3. Select Prometheus data source
4. Import

---

## 🔄 Pipeline Stages

### Jenkinsfile Overview

```groovy
pipeline {
    agent any
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: '<repo-url>'
            }
        }
        
        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t <username>/boardgame:${BUILD_NUMBER} .'
                sh 'docker tag <username>/boardgame:${BUILD_NUMBER} <username>/boardgame:latest'
            }
        }
        
        stage('Trivy Scan') {
            steps {
                sh 'trivy image --severity HIGH,CRITICAL <username>/boardgame:latest'
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    sh 'docker push <username>/boardgame:${BUILD_NUMBER}'
                    sh 'docker push <username>/boardgame:latest'
                }
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@<worker-ip> "
                            docker stop boardgame || true
                            docker rm boardgame || true
                            docker pull <username>/boardgame:latest
                            docker run -d --name boardgame -p 8080:8080 <username>/boardgame:latest
                        "
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
```

---

## 📊 Monitoring & Observability

### Prometheus Targets
Access: `http://<master-ip>:9090/targets`

**Expected Targets:**
- ✅ prometheus (localhost:9090)
- ✅ node-exporter (worker-ip:9100)
- ✅ boardgame-app (worker-ip:8080/actuator/prometheus)

### Grafana Dashboards

#### System Metrics Dashboard (ID: 1860)
**Monitors:**
- CPU Usage (%)
- Memory Usage (GB)
- Disk I/O (MB/s)
- Network Traffic (KB/s)
- System Load Average
- Disk Space Usage (%)

#### Custom Application Dashboard
**Create custom panels for:**
- HTTP Request Rate
- Response Times (p50, p95, p99)
- Error Rate (%)
- JVM Heap Memory
- Active Threads

---

## 🔐 Security Implementation

### Multi-Layer Security Approach

#### 1. Code Level
- **SonarQube**: Static Application Security Testing (SAST)
- Quality gates block deployment if vulnerabilities found
- Continuous monitoring of code quality metrics

#### 2. Container Level
- **Trivy Scanner**: Scans for CVEs in base images and dependencies
- Fails build on HIGH and CRITICAL vulnerabilities
- Regular image updates to patch vulnerabilities

#### 3. Infrastructure Level
- Security groups restrict access to necessary ports only
- SSH key-based authentication
- No hardcoded credentials (using Jenkins credential store)

#### 4. Network Level
```
Master Node:
- Port 8080: Jenkins (restrict to your IP)
- Port 9000: SonarQube (restrict to your IP)
- Port 9090: Prometheus (restrict to your IP)
- Port 3000: Grafana (restrict to your IP)
- Port 22: SSH (restrict to your IP)

Worker Node:
- Port 8080: Application (open to internet)
- Port 9100: Node Exporter (allow from master node only)
- Port 22: SSH (restrict to your IP)
```

---

## 📸 Screenshots

### ✅ Infrastructure Deployment

<img width="958" height="775" alt="Screenshot 2025-10-16 134208" src="https://github.com/user-attachments/assets/cde87b28-5122-4bae-9c2f-53e1491e62fb" />

*Successful infrastructure provisioning with Terraform*

### ✅ CI/CD Pipeline

<img width="1884" height="753" alt="Screenshot 2025-10-17 010411" src="https://github.com/user-attachments/assets/f918435c-6ab7-4be4-bcf3-be5f66387e9f" />

*Complete pipeline execution with all stages passed*

### ✅ Code Quality Analysis

<img width="1895" height="793" alt="Screenshot 2025-10-17 023651" src="https://github.com/user-attachments/assets/14616d32-948d-4263-9101-1a7dc31be5fe" />

*Code quality metrics and security analysis*

### ✅ Security Scanning

<img width="1846" height="554" alt="Screenshot 2025-10-17 023757" src="https://github.com/user-attachments/assets/894b4d9f-dd24-4890-9492-052cba6eeb9a" />

*Container vulnerability scan results*

### ✅ Container Registry

<img width="1900" height="853" alt="Screenshot 2025-10-17 024025" src="https://github.com/user-attachments/assets/152088c1-717c-4502-84e8-dab286e995e4" />

*Published Docker image on Docker Hub*

### ✅ Application Deployment

<img width="1715" height="806" alt="image" src="https://github.com/user-attachments/assets/0ab14c6b-997c-4f4e-a5ad-6f64ece4a3cb" />

*Board Game application running on EC2*

### ✅ Monitoring Stack

<img width="1919" height="462" alt="Screenshot 2025-10-17 022611" src="https://github.com/user-attachments/assets/e989bc4b-3069-4d26-8dd9-c9617a083bd5" />

*All monitoring targets healthy*

<img width="1919" height="752" alt="Screenshot 2025-10-17 023130" src="https://github.com/user-attachments/assets/876f7f0a-a65b-477b-a20b-c8991329ce64" />

*Real-time system metrics visualization*

---

## 🐛 Troubleshooting

### Common Issues and Solutions

#### Issue: Jenkins cannot connect to worker node
```bash
# Verify SSH connectivity
ssh -i your-key.pem ubuntu@<worker-ip>

# Check security group allows SSH from master node
aws ec2 describe-security-groups --group-ids <sg-id>
```

#### Issue: SonarQube quality gate fails
```bash
# Check SonarQube logs
sudo journalctl -u sonarqube -n 100

# Verify webhook configuration
curl -X POST http://<jenkins-ip>:8080/sonarqube-webhook/
```

#### Issue: Docker push fails
```bash
# Verify Docker Hub credentials
docker login

# Check Jenkins credential configuration
# Ensure credential ID matches Jenkinsfile
```

#### Issue: Prometheus targets are down
```bash
# Check Node Exporter status
systemctl status node_exporter

# Verify port is open
sudo netstat -tulpn | grep 9100

# Test connectivity
curl http://<worker-ip>:9100/metrics
```

#### Issue: Application not accessible
```bash
# Check container status
docker ps -a

# View container logs
docker logs boardgame

# Verify port mapping
docker port boardgame

# Check security group allows port 8080
```

---

## 🚀 Future Enhancements

### Short-term Improvements
- [ ] Implement HTTPS with Let's Encrypt certificates
- [ ] Add Nginx reverse proxy for all services
- [ ] Configure email notifications for pipeline failures
- [ ] Add Slack integration for real-time alerts
- [ ] Implement automated backups for Jenkins and SonarQube

### Medium-term Goals
- [ ] Migrate from H2 to AWS RDS (PostgreSQL)
- [ ] Implement Blue-Green deployment strategy
- [ ] Add integration and E2E tests to pipeline
- [ ] Configure Auto Scaling Groups
- [ ] Add Application Load Balancer

### Long-term Vision
- [ ] Multi-region deployment for disaster recovery
- [ ] Kubernetes migration for container orchestration
- [ ] Implement GitOps with ArgoCD
- [ ] Service mesh with Istio
- [ ] Advanced monitoring with ELK stack
- [ ] Infrastructure cost optimization with AWS Cost Explorer

---

## 📚 Resources & References

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Trivy Vulnerability Scanner](https://aquasecurity.github.io/trivy/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Sumit Dilip Shirke**  
DevOps Engineer | Cloud & CI/CD Enthusiast

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sumitshirke333/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](http://linkedin.com/in/sumit-shirke-0335ab337)

---

## 🙏 Acknowledgments

- Thanks to the open-source community for the amazing tools
- Inspired by industry best practices and real-world DevOps implementations
- Special thanks to all contributors and supporters

---

## 📞 Support

If you have questions or need help:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Open an [Issue](https://github.com/sumitshirke/boardgame-devops/issues)
3. Reach out via [LinkedIn](https://linkedin.com/in/sumitshirke)

---

<div align="center">

**⭐ If you find this project helpful, please consider giving it a star! ⭐**

Made with ❤️ by Sumit Dilip Shirke

</div>
