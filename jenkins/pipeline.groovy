pipeline {
    agent any

    environment {
        REGISTRY_URL = 'your-registry-url.com'
        DOCKER_CREDENTIALS_ID = 'docker-credentials' // Jenkins ID for Docker credentials
        GIT_REPO = 'git@github.com:ducnt102/elsa-demo.git'
        NAMESPACE = 'hackathon-starter'
        IMAGE_WEB = "${REGISTRY_URL}/hackathon-starter-web"
        IMAGE_DB = "${REGISTRY_URL}/hackathon-starter-db"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling latest code from GitHub repository...'
                git url: "${GIT_REPO}", branch: 'main'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running automated tests...'
                sh './run-tests.sh'  // Assuming you have a test script
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    echo 'Building Docker images...'
                    sh "docker build -t ${IMAGE_WEB}:latest ./web"
                    sh "docker build -t ${IMAGE_DB}:latest ./db"
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    echo 'Pushing Docker images to registry...'
                    docker.withRegistry("https://${REGISTRY_URL}", 'docker-credentials') {
                        sh "docker push ${IMAGE_WEB}:latest"
                        sh "docker push ${IMAGE_DB}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh 'kubectl apply -f k8s-manifests/ -n ${NAMESPACE}'
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'CI/CD Pipeline failed. Please check the logs.'
        }
    }
}
