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
                sh "docker build --network=host -t jenkins_task:tag1 ."
            }
        }
		
		stage('Push') {
            steps {
                echo 'Pushing..'
                sh "docker login localhost:8083 -u admin -p vlad"
				sh "docker push localhost:8083/jenkins_task"
            }
        }
    }
}
