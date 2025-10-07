pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    environment {
        EC2_USER = 'ubuntu'
        EC2_IP = '13.200.143.85'             
        JAR_NAME = 'app.jar'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sumitshirke333/Boardgame-project-.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {   
                    
                    sh 'scp -o StrictHostKeyChecking=no target/*.jar $EC2_USER@$EC2_IP:/home/ubuntu/$JAR_NAME'
                    sh 'ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP "sudo pkill -f $JAR_NAME || true"'
                    sh 'ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP "nohup java -jar /home/ubuntu/$JAR_NAME > app.log 2>&1 &"'
                    
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Build or deployment failed!'
        }
    }
}
