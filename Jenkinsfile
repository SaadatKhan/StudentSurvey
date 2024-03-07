pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'saadatkhan/ssurvey'
        // Change 'latest' to use the Jenkins build number
        VERSION = "${BUILD_NUMBER}" 
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with the Jenkins build number as tag
                    sh "docker build -t ${DOCKER_IMAGE}:${VERSION} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "echo ${DOCKERHUB_PASSWORD} | docker login --username ${DOCKERHUB_USERNAME} --password-stdin"
                    }
                    // Push the Docker image with the Jenkins build number as tag
                    sh "docker push ${DOCKER_IMAGE}:${VERSION}"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Replace the image in the Kubernetes deployment with the new version
                    withCredentials([file(credentialsId: 'my-kube-cluster', variable: 'KUBECONFIG')]) {
                        // Use the proper deployment and container name, and remove --record
                        sh "kubectl set image deployment/ssurvey-deployment ssurvey=${DOCKER_IMAGE}:${VERSION}"
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up Docker images to save space
            sh "docker rmi ${DOCKER_IMAGE}:${VERSION}"
        }
    }
}
