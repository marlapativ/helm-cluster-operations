pipeline {
    environment {
        imageRegistry = "docker.io"
        imageRepo = "marlapativ"
        registryCredential = 'dockerhub'
    }
    agent any
    stages {
        stage('helm chart validations') {
            parallel {
                stage('helm lint') {
                    steps {
                        sh '''
                            helm lint . --strict
                        '''
                    }
                }

                stage('helm template') {
                    steps {
                        sh '''
                            helm template .
                        '''
                    }
                }
            }
        }

        stage('setup docker') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: registryCredential, passwordVariable: 'password', usernameVariable: 'username')]) {
                        sh('docker login -u $username -p $password')
                    }
                }
            }
        }

        stage('github release') {
            tools {
                nodejs "nodejs"
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-app', passwordVariable: 'GITHUB_TOKEN', usernameVariable: 'GITHUB_USERNAME')]) {
                        sh '''
                            npm i -g @semantic-release/exec
                            export GITHUB_ACTION=true
                            npx semantic-release
                        '''
                    }
                }
            }
        }

        stage('dockerhub release') {
            steps {
                script {
                    sh '''
                        helm push *.tgz oci://$imageRegistry/$imageRepo
                    '''
                }
            }
        }
    }
}
