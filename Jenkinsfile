pipeline {
    agent any

    environment {
        IMAGE_NAME = 'gayathrireddyponna123/nodeapp'
        DEPLOYMENT_NAME = 'nodeapp-deployment'
        CONTAINER_NAME = 'nodeapp'
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'demo-eks'
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
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',  // You must create this credential in Jenkins
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                        # Update kubeconfig to access EKS cluster
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                        # Deploy new Docker image to EKS
                        kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$IMAGE_NAME:$BUILD_NUMBER
                        kubectl rollout status deployment/$DEPLOYMENT_NAME
                    '''
                }
            }
        }
    }
}

