pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sumitshirke333/Boardgame-project-'
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
                    sh '''
                    scp -o StrictHostKeyChecking=no target/*.jar ubuntu@13.200.143.85:/home/ubuntu/app.jar
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP "pkill -f $JAR_NAME || true"
                    ssh -o StrictHostKeyChecking=no ubuntu@13.200.143.85 "nohup java -jar /home/ubuntu/app.jar > app.log 2>&1 &"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo ' Deployment successful!'
        }
        failure {
            echo ' Build or deployment failed!'
        }
    }
}
