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
      stage('Delete old containers') {
            steps {
            ansiColor('xterm') {
                sh '''
            if [ "$(docker ps -qa|wc -l)" -gt "0" ];then
            docker ps -qa|xargs docker rm -f
            fi
                '''
            }
            }
        }
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
       stage('Docker Image Scan') {
            steps {
            ansiColor('xterm') {
                sh '''
              docker run -d --name db arminc/clair-db
              sleep 15 # wait for db to come up
              docker run -p 6060:6060 --link db:postgres -d --name clair arminc/clair-local-scan
              sleep 1
              DOCKER_GATEWAY=$(docker network inspect bridge --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}")
              wget -qO clair-scanner https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64 && chmod +x clair-scanner
             ./clair-scanner --ip="$DOCKER_GATEWAY"  subham-test-image
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
      stage('Delete docker containers') {
            steps {
            ansiColor('xterm') {
                sh '''
               if [ "$(docker ps -qa|wc -l)" -gt 0 ];then
               docker ps -qa|xargs docker rm -f
               fi
                '''
            }
            }
        }
    }
}
