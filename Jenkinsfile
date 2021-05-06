pipeline {
	enviroment{
	tag= "test"
	}
	
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'cb46df6e-b140-4439-8b9f-f4ceef31edce', url: 'https://github.com/Simplest98/Blogifier']]])
            }
        }
        stage('Docker Build') {
            steps {
                sh "docker build -t Jenkins_task"
            }
        }
        stage('Push') {
            steps {
                sh "docker login localhost:8081 --username admin --password admin123"
				sh "docker push Jenkins_task"
            }
        }
    }
}
