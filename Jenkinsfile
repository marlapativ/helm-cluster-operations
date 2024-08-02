pipeline {
    environment {
        imageRegistry = "docker.io"
        imageRepo = "marlapativ"
        registryCredential = 'dockerhub'
        istioImagesTag = "1.22.3"
        istiodImageName = "pilot"
        istioGatewayImageName = "proxyv2"
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
                sh '''
                    if [ -n "$(docker buildx ls | grep multiarch)" ]; then
                        docker buildx use multiarch
                    else
                        docker buildx create --name=multiarch --driver=docker-container --use --bootstrap 
                    fi
                '''

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

        stage('build and push istiod image') {
            steps {
                sh '''
                    docker buildx build \
                        --build-arg BASEIMAGETAG=$istioImagesTag \
                        --platform linux/amd64,linux/arm64 \
                        --builder multiarch \
                        -t $imageRepo/$istiodImageName:latest \
                        -t $imageRepo/$istiodImageName:$istioImagesTag \
                        -f Dockerfile.istiod \
                        --push \
                        .
                '''
            }
        }

        stage('build and push istio Gateway image') {
            steps {
                sh '''
                    docker buildx build \
                        --build-arg BASEIMAGETAG=$istioImagesTag \
                        --platform linux/amd64,linux/arm64 \
                        --builder multiarch \
                        -t $imageRepo/$istioGatewayImageName:latest \
                        -t $imageRepo/$istioGatewayImageName:$istioImagesTag \
                        -f Dockerfile.istiogateway \
                        --push \
                        .
                '''
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
