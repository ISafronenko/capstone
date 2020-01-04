pipeline {
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

        stage('Building green image') {
            when {
                changelog '[green_build]'
            }
            steps {
                script {
                    sh 'docker build -t isafronenko/capstone:green .'
                }
            }
        }

        stage('Building blue image') {
            when {
                changelog '[blue_build]'
            }
            steps {
                script {
                    sh 'docker build -t isafronenko/capstone:blue .'
                }
            }
        }

        stage('Deploy Image') {
            steps {
                script {
                    sh 'docker push isafronenko/capstone'
                }
            }
        }

        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi -f isafronenko/capstone"
            }
        }
    }

}