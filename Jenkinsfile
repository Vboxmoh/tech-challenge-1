pipeline {
    agent any

    environment {
        AWS_REGION        = 'eu-west-3'
        ECR_REGISTRY      = '277778298945.dkr.ecr.eu-west-3.amazonaws.com'
        FRONTEND_REPO     = 'devops-tc1-frontend'
        BACKEND_REPO      = 'devops-tc1-backend'
        ECS_CLUSTER       = 'devops-tc1-cluster'
        FRONTEND_SERVICE  = 'devops-tc1-frontend-svc'
        BACKEND_SERVICE   = 'devops-tc1-backend-svc'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-credentials',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_REGION | \
                        docker login --username AWS --password-stdin $ECR_REGISTRY
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    docker build -t $FRONTEND_REPO:latest $WORKSPACE/frontend
                    docker build -t $BACKEND_REPO:latest $WORKSPACE/backend
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker tag $FRONTEND_REPO:latest $ECR_REGISTRY/$FRONTEND_REPO:latest
                    docker tag $BACKEND_REPO:latest $ECR_REGISTRY/$BACKEND_REPO:latest
                    docker push $ECR_REGISTRY/$FRONTEND_REPO:latest
                    docker push $ECR_REGISTRY/$BACKEND_REPO:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-credentials',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        aws ecs update-service \
                            --cluster $ECS_CLUSTER \
                            --service $FRONTEND_SERVICE \
                            --force-new-deployment \
                            --region $AWS_REGION

                        aws ecs update-service \
                            --cluster $ECS_CLUSTER \
                            --service $BACKEND_SERVICE \
                            --force-new-deployment \
                            --region $AWS_REGION
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
            echo 'Pipeline failed!'
        }
    }
}