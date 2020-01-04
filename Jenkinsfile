pipeline {
    environment {
        registry = "isafronenko/capstone"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any

    stages {

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'mvn test -Punit-tests jacoco:report'
            }
        }
        stage('Integration Tests') {
            steps {
                sh 'mvn test -Pint-tests'
            }
        }
        stage('Architectural Tests') {
            steps {
                sh 'mvn test -Parc-tests'
            }
        }

        /*stage('Sonar Analysis') {
            steps {
                sh 'mvn sonar:sonar -DXmx1024m -DXX:MaxPermSize=256m'
            }
        }*/

        stage('Building image') {

            steps {
                script {
                    def dockerHome = tool 'docker'
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy Image') {
            steps {
                script {
                    def dockerHome = tool 'docker'
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                    docker.withRegistry('https://index.docker.io/', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}