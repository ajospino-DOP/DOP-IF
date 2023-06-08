pipeline{
    agent {
        label 'TA-Agent'
    }
    stages {
        stage('Check'){
            steps{
                sh "terraform version"
            }
        }
    }
}    