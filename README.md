# 🚀 Automated DevOps Pipeline for Board Game WebApp

> A production-ready CI/CD pipeline for a **Spring Boot-based Board Game Listing Application**, featuring **automated deployment, containerization, security scanning, and monitoring on AWS**.

---

## 🎯 Project Overview

This project demonstrates an **end-to-end DevOps implementation** for deploying and managing a Java web application on AWS EC2.
It automates everything — from infrastructure provisioning to application monitoring — using modern DevOps tools.

### **Key Highlights**

* Infrastructure provisioning via **Terraform**
* CI/CD pipeline built with **Jenkins**
* **SonarQube** for code quality and bug detection
* **Trivy** for container vulnerability scanning
* **Docker** for application containerization
* **Prometheus + Grafana** for real-time monitoring and visualization

---

## 🏗️ Project Architecture

```text
┌─────────────┐
│   GitHub    │
│ Repository  │
└──────┬──────┘
       │ Code Commit
       ▼
┌──────────────────────────────────────────────┐
│              Master Node (EC2)               │
│  ┌───────────┐  ┌────────────┐  ┌──────────┐ │
│  │ Jenkins   │  │ SonarQube  │  │ Grafana  │ │
│  └────┬──────┘  └────┬───────┘  └────┬─────┘ │
│       │               │               │       │
│       ▼               ▼               ▼       │
│   ┌────────┐   ┌────────────┐   ┌──────────┐ │
│   │ Docker │   │ Trivy Scan │   │ Prometheus│ │
│   └────────┘   └────────────┘   └──────────┘ │
└────────┬─────────────────────────────────────┘
         │
         ▼
   ┌──────────────────────────────┐
   │        Worker Node (EC2)     │
   │ ┌──────────────────────────┐ │
   │ │ Dockerized WebApp (8080) │ │
   │ │ Node Exporter (9100)     │ │
   │ └──────────────────────────┘ │
   └──────────────────────────────┘
```

### **Flow Summary**

1. Code pushed to **GitHub** triggers Jenkins build
2. **Jenkins pipeline**:

   * Builds with Maven
   * Analyzes code with **SonarQube**
   * Scans image with **Trivy**
   * Pushes Docker image to **Docker Hub**
   * Deploys to **EC2 (Worker Node)**
3. **Prometheus** scrapes metrics → **Grafana** visualizes them

---

## 🧩 Project Structure

```
📦 boardgame-devops-pipeline
├── terraform/                 # AWS Infrastructure setup
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── Jenkinsfile                # CI/CD pipeline script
├── Dockerfile                 # Container image configuration
├── src/                       # Spring Boot source code
├── target/                    # Compiled JAR file
├── prometheus.yml             # Monitoring configuration
├── screenshots/               # Project screenshots
└── README.md                  # Documentation
```

---

## 🛠️ Tools & Technologies

| Category             | Tool       | Purpose              |
| -------------------- | ---------- | -------------------- |
| **Cloud**            | AWS EC2    | Host infrastructure  |
| **IaC**              | Terraform  | Automate EC2 setup   |
| **CI/CD**            | Jenkins    | Build, test, deploy  |
| **Code Quality**     | SonarQube  | Static code analysis |
| **Security**         | Trivy      | Scan Docker images   |
| **Containerization** | Docker     | Build and run app    |
| **Monitoring**       | Prometheus | Metrics collection   |
| **Visualization**    | Grafana    | Dashboard & alerts   |

---

## ⚙️ Setup & Execution

### 1️⃣ Clone Repository

```bash
git clone <your-repository-url>
cd boardgame-devops-pipeline
```

### 2️⃣ Provision Infrastructure with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### 3️⃣ Configure Jenkins

* Open Jenkins: `http://<master-node-ip>:8080`
* Create a **Pipeline job**
* Choose: “Pipeline script from SCM”
* Repo URL: `<your-repo-url>`
* Script Path: `Jenkinsfile`

### 4️⃣ Build and Run App Locally

```bash
mvn clean package -DskipTests
docker build -t boardgame-app .
docker run -d -p 8080:8080 boardgame-app
```

### 5️⃣ Configure Prometheus

Update `/etc/prometheus/prometheus.yml`:

```yaml
- job_name: 'boardgame-app'
  static_configs:
    - targets: ['<worker-ip>:8080']
  metrics_path: '/actuator/prometheus'
```

Restart Prometheus:

```bash
sudo systemctl restart prometheus
```

---

## 🔄 CI/CD Pipeline Flow

1. **Code Commit** → Jenkins triggers pipeline
2. **Build** → Maven compiles & packages app
3. **Code Analysis** → SonarQube checks quality
4. **Security Scan** → Trivy scans Docker image
5. **Push Image** → Docker image pushed to Docker Hub
6. **Deploy** → Container runs on Worker EC2
7. **Monitor** → Prometheus + Grafana track system & app metrics

---

## 📸 Project Screenshots

| Stage                          | Screenshot                                                                                    |
| ------------------------------ | --------------------------------------------------------------------------------------------- |
| **Terraform Infrastructure**   | ![Terraform](https://github.com/user-attachments/assets/cde87b28-5122-4bae-9c2f-53e1491e62fb) |
| **Jenkins Pipeline**           | ![Pipeline](https://github.com/user-attachments/assets/f918435c-6ab7-4be4-bcf3-be5f66387e9f)  |
| **SonarQube Report**           | ![SonarQube](https://github.com/user-attachments/assets/14616d32-948d-4263-9101-1a7dc31be5fe) |
| **Trivy Scan Results**         | ![Trivy](https://github.com/user-attachments/assets/894b4d9f-dd24-4890-9492-052cba6eeb9a)     |
| **Docker Hub Repository**      | ![DockerHub](https://github.com/user-attachments/assets/152088c1-717c-4502-84e8-dab286e995e4) |
| **Deployed Application (EC2)** | ![App](https://github.com/user-attachments/assets/0ab14c6b-997c-4f4e-a5ad-6f64ece4a3cb)       |
| **Prometheus Targets**         | ![Prometheus](https://github.com/user-attachments/assets/5bcbd4f2-5c81-4f59-9b83-9f0a41e118f2)   |
| **Grafana Dashboard**          | ![Grafana](https://github.com/user-attachments/assets/876f7f0a-a65b-477b-a20b-c8991329ce64)   |

---

## 🧠 Troubleshooting

| Issue                  | Fix                                                  |
| ---------------------- | ---------------------------------------------------- |
| Jenkins build fails    | Check credentials and pipeline syntax                |
| Docker push denied     | Verify Docker Hub credentials                        |
| Prometheus target down | Restart Node Exporter and open port 9100             |
| App not loading        | Check container logs and port 8080 in security group |

---

## 🚀 Future Enhancements

* Add HTTPS using Let’s Encrypt
* Configure Nginx reverse proxy
* Add Slack/email alerts for failed builds
* Implement Blue-Green Deployment
* Extend monitoring with ELK Stack

---

## 👨‍💻 Author

**Sumit Dilip Shirke**
DevOps Engineer | Cloud & CI/CD Enthusiast

🔗 [GitHub](https://github.com/sumitshirke333)
🔗 [LinkedIn](https://linkedin.com/in/sumit-shirke-0335ab337)

---

⭐ **If you like this project, give it a star!**
Made with ❤️ by *Sumit Shirke*

