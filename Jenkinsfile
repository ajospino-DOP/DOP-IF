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
                    sh 'cd terraform-deployment'
                    sh "terraform init"
                }
            }
        }
        stage('Validation'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh 'cd terraform-deployment'
                    sh "terraform validate"
                }
            }
        }
        stage('Planning'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh 'cd terraform-deployment'
                    sh "terraform plan -out main.tfplan"
                }
            }
        }
        stage('Deploying'){
            steps{
                withAWS(credentials: 'AWS-Key', region: env.AWS_REGION){
                    sh 'cd terraform-deployment'
                    sh "terraform apply main.tfplan"
                }
            }
        }
    }
}    