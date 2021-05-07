pipeline {
	
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout..'
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/Simplest98/Blogifier']]])
            }
        }
        stage('Docker Build') {
            steps {
                echo 'Docker..'
                sh "docker build --network=host -t jenkins_task ."
            }
        }
        stage('Push') {
            steps {
                echo 'Push..'
                sh "docker login localhost:8083 --username admin --password vlad"
				sh "docker push jenkins_task"
            }
        }
    }
}
