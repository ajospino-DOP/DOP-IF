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
                    sh 'cd terraform-deployment && ls'
                    sh "terraform init"
                    sh "terraform validate"
                    sh "terraform plan -out main.tfplan"
                    sh "terraform apply main.tfplan"
                }
            }
        }
    }
}    