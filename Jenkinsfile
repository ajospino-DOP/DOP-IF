pipeline{
    agent {
        label 'TA-Agent'
    }
    environment{
        AWS_REGION = 'us-east-2'
    }
    stages {
        stage('Initialization'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh "cd terraform-deployment && terraform init"
                }
            }
        }
        stage('Validation'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh "cd terraform-deployment && terraform validate"
                }
            }
        }
        stage('Planning'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh "cd terraform-deployment && terraform plan -out main.tfplan"
                }
            }
        }
        stage('Deploying'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh "cd terraform-deployment && terraform apply main.tfplan"
                }
            }
        }
    }
}    