pipeline {
    agent { label 'Node' }

    environment {
        SONAR_HOME = tool "Sonar"
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: 'latest', description: 'Frontend Docker image tag')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: 'latest', description: 'Backend Docker image tag')
    }

    stages {
        stage("Workspace Cleanup") {
            steps {
                cleanWs()
            }
        }

        stage("Git: Code Checkout") {
            steps {
                git url: 'https://github.com/richardnguyendev/Wanderlust-Mega-DevOps.git', branch: 'main'
            }
        }

        stage("Trivy: Filesystem Scan") {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency Check") {
            steps {
                script {
                    owasp_dependency()
                }
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "wanderlust", "wanderlust")
                }
            }
        }

        stage("SonarQube: Quality Gates") {
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage("Export Environment Variables") {
            parallel {
                stage("Backend env setup") {
                    steps {
                        dir("Automations") {
                            sh "bash updatebackendnew.sh"
                        }
                    }
                }

                stage("Frontend env setup") {
                    steps {
                        dir("Automations") {
                            sh "bash updatefrontendnew.sh"
                        }
                    }
                }
            }
        }

        stage("Docker: Build Images") {
            steps {
                dir('backend') {
                    script {
                        docker_build("wanderlust-backend-beta", "${params.BACKEND_DOCKER_TAG}", "madhupdevops")
                    }
                }
                dir('frontend') {
                    script {
                        docker_build("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "madhupdevops")
                    }
                }
            }
        }

        stage("Docker: Push to DockerHub") {
            steps {
                script {
                    docker_push("wanderlust-backend-beta", "${params.BACKEND_DOCKER_TAG}", "madhupdevops")
                    docker_push("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "madhupdevops")
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: '*.xml', followSymlinks: false

           
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
            ]
        }
    }
}

