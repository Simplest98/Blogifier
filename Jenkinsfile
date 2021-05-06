pipeline {
	
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout..'
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'cb46df6e-b140-4439-8b9f-f4ceef31edce', url: 'https://github.com/Simplest98/Blogifier']]])
            }
        }
        stage('Docker Build') {
            steps {
                echo 'Docker..'
                sh "docker build -t Jenkins_task"
            }
        }
        stage('Push') {
            steps {
                echo 'Push..'
                sh "docker login localhost:8081 --username admin --password admin123"
				sh "docker push Jenkins_task"
            }
        }
    }
}
