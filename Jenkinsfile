// =============================
// ✅ HÀM DÙNG CHUNG (Đặt TRƯỚC pipeline)
// =============================
def trivy_scan() {
    echo "🔍 Trivy scan running..."
    bat "trivy fs ."
}

def owasp_dependency() {
    echo "🔒 OWASP Dependency check running..."
    bat "dependency-check.bat --project wanderlust --scan ."
}

def sonarqube_analysis(toolName, projectKey, projectName) {
    withSonarQubeEnv("${toolName}") {
        bat """
            sonar-scanner \
            -Dsonar.projectKey=${projectKey} \
            -Dsonar.projectName=${projectName} \
            -Dsonar.sources=.
        """
    }
}

def sonarqube_code_quality() {
    timeout(time: 2, unit: 'MINUTES') {
        waitForQualityGate abortPipeline: true
    }
}

def docker_build(imageName, tag, dockerUser) {
    echo "🐳 Docker build: ${dockerUser}/${imageName}:${tag}"
    bat "docker build -t ${dockerUser}/${imageName}:${tag} ."
}

def docker_push(imageName, tag, dockerUser) {
    echo "📤 Docker pubat: ${dockerUser}/${imageName}:${tag}"
    bat "docker push ${dockerUser}/${imageName}:${tag}"
}

// =============================
// ✅ PIPELINE CHÍNH
// =============================
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

        // stage("Trivy: Filesystem Scan") {
        //     steps {
        //         script {
        //             trivy_scan()
        //         }
        //     }
        // }

        stage("OWASP: Dependency Check") {
            steps {
                bat """
                echo 🔒 Running OWASP Dependency-Check in Docker...
                docker run --rm ^
                    -v "%WORKSPACE%:/src" ^
                    -w /src ^
                    owasp/dependency-check:latest ^
                    dependency-check.sh --project wanderlust --scan /src
                """
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
                            bat "bash updatebackendnew.sh"
                        }
                    }
                }

                stage("Frontend env setup") {
                    steps {
                        dir("Automations") {
                            bat "bash updatefrontendnew.sh"
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
