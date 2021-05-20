pipeline {
    agent any

    stages {
	
        stage('Checkout') {
            steps {
                echo 'Checkout..'
				checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GIT', url: 'https://github.com/vlad-333/Blogifier']]])
            }
        }
		
		stage('Docker Build') {
            steps {
                echo 'Building Docker..'
                sh "docker build --network=host -t localhost:8081/jenkins_task ."
            }
        }
		
		stage('Push') {
            steps {
                echo 'Pushing..'
                sh "docker login localhost:8081 -u admin -p ubuntu"
				sh "docker push localhost:8081/jenkins_task"
            }
        }
    }
}
