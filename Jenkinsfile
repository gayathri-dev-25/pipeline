pipeline {
    agent any

    environment {
        IMAGE_NAME = 'gayathrireddyponna123/nodeapp'
        DEPLOYMENT_NAME = 'nodeapp-deployment'
        CONTAINER_NAME = 'nodeapp'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    credentialsId: 'ae89cfc6-1ebc-401b-b838-cd6933e98698',
                    url: 'https://github.com/gayathri-dev-25/pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'e10d6df6-afc7-4950-b113-5658c553bf7c', url: '']) {
                    script {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "kubectl rollout status deployment/${DEPLOYMENT_NAME}"
            }
        }
    }
}

