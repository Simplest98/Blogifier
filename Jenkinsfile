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
                sh "docker build --network=host -t localhost:8083/jenkins_task ."
            }
        }
        stage('Push') {
            steps {
                echo 'Push..'
                sh "docker login localhost:8083 -u admin -p vlad"
				sh "docker push localhost:8083/jenkins_task"
            }
        }
    }
}
