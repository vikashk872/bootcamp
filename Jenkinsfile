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
                    image 'node:18-alpine'
                    args '-e HOME=/tmp -e NPM_CONFIG_PREFIX=/tmp/.npm'
                    reuseNode true
                }
            }
            steps {
                echo 'Retrieve source from github. run npm install and npm test' 
               script { checkout scm 
                        sh 'ls -la'
                        sh 'pwd'
           
                    echo 'build the image' 
                    sh 'npm install'
                    sh 'npm test'
              
                    echo 'push the image to docker hub' 
                    sh 'docker build --tag vikashk872/internal:2 .'
                    sh 'docker push vikashk872/internal:2'
                }
            }
    
            
         stage('Building image') {
                steps {
                    script{
                        echo "Building images"
                        dockerImage = docker.build("${env.imageName}:${env.BUILD_ID}")
                        echo "image build"


                    }
                               
        }     
        stage('Push Image') {
            steps{
                script{
                    echo "Pushing image"
docker.withRegistry('',registryCredential){
    dockerImage.push("${env.BUILD_ID}")
                }}}}
                }
                
            stage("Deploy to k8s") {
                agent {
                        docker {
                            image 'google/cloud-sdk:latest'
                            args '-e HOME=/tmp'
                            reuseNode true
                        }
                }
                steps {
                    echo 'Get cluster credential'
                    sh 'gcloud container clusters get-credentials app --zone us-central1-c --project roidtc-june22-u102'
                    sh "kubectl set image deployment/ui-svc-deployment ui-svc-containers=${env.imageName}:${env.BUILD_ID}"

                }

            }
            stage("Removing images"){
                steps{
                    echo "Removing images"
                    
                }
            }
        }
    }
}