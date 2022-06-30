pipeline {
    agent any 
    environment {
        registryCredential = 'dockerhub'
        imageName = 'vikashk872/internal:1'
        dockerImage = ''
        }
    stages {
        stage('Run the tests') {
             agent {
                docker { 
                    image 'node:18-alpine3.15'
                    args '-e HOME=/tmp -e NPM_CONFIG_PREFIX=/tmp/.npm'
                    reuseNode true
                }
            }
            steps {
                echo 'Retrieve source from github. run npm install and npm test' 
               script { checkout scm 
                        sh 'ls -la'
                        sh 'pwd'}
            }
        }
        stage('Building image') {
            steps{
                script {
                    echo 'build the image' 
                    sh 'npm install'
                    sh 'npm server.js'
                }
            }
            }
        stage('Push Image') {
            steps{
                script {
                    echo 'push the image to docker hub' 
                    sh 'docker build --tag vikashk872/internal:2 .'
                    sh 'docker push vikashk872/internal:2'
                }
            }
        }     
         stage('deploy to k8s') {
             agent {
                docker { 
                    image 'google/cloud-sdk:latest'
                    args '-e HOME=/tmp'
                    reuseNode true
                        }
                    }
                    steps {
                        echo "deploying k8s"
                    }
           
        }     
        stage('Remove local docker image') {
            steps{
                sh "docker rmi $imageName:latest"
                sh "docker rmi $imageName:$BUILD_NUMBER"
            }
        }
    }
}