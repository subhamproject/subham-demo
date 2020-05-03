pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  environment {
      DOCKER_PASS = credentials('DOCKER_PASS')
   }
    agent any
    stages {
        stage('Maven Build') {
            steps {
            ansiColor('xterm') {
                sh '''
                mvn package
                '''
            }
            }
        }
        stage('Docker Build') {
            steps {
            ansiColor('xterm') {
                sh '''
                docker build -t subham-test-image .
                '''
            }

            }
        }
        stage('Docker Tag') {
            steps {
            ansiColor('xterm') {
                sh '''
                docker login -u mandalsubham -p "${DOCKER_PASS}"
                docker tag subham-test-image mandalsubham/subham-demo:secondimage
                '''
            }
        }
        }
        stage('Docker Image Push') {
            steps {
            ansiColor('xterm') {
                sh '''
                docker push mandalsubham/subham-demo:secondimage
                '''
            }
            }
        }
    }
}
