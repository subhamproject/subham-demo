def var

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
      
      stage('Read Var file') {
            steps {
              script {
              load "vars.groovy"
            }
        }
        }
      
      stage('Display vars') {
            steps {
              script {
                echo "First value is: ${name}"
                echo "Second value is: ${pass}"
            }
        }
        }
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
          when { expression { env.DOCKER_PASS != null } }
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
         when { expression { env.DOCKER_PASS != null } }
            steps {
            ansiColor('xterm') {
            script {
                sh '''
                 bash scan.sh
             '''
            }
        }
        }
       }
        stage('Docker Image Push') {
          when { expression { env.DOCKER_PASS != null } }
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
