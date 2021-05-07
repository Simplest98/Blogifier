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
                sh "cat /home/vm/pasw | docker login -u vpolevoi --password-stdin"
                sh "docker login localhost:8083 -u admin -p vlad"
				sh "docker push jenkins_task"
            }
        }
    }
}
