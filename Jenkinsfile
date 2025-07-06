<<<<<<< HEAD
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
=======
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
pipeline {
    agent { label 'Node' }

    environment {
<<<<<<< HEAD
        SONAR_HOME = tool "Sonar"
=======
        SONAR_HOME = tool 'Sonar'
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: 'latest', description: 'Frontend Docker image tag')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: 'latest', description: 'Backend Docker image tag')
    }

    stages {
<<<<<<< HEAD
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
                    dependency-check.sh --project wanderlust --scan /src --disableNodeJS
                """
            }
        }



        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "wanderlust", "wanderlust")
=======

        stage("Workspace cleanup") {
            steps {
                cleanWs()
            }
        }

        stage("Git: Code Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/richardnguyendev/Wanderlust-Mega-DevOps.git'
            }
        }

        stage("Trivy: Filesystem scan") {
            steps {
                sh 'trivy fs . || true'
            }
        }

        stage("OWASP: Dependency check") {
            steps {
                sh '''
                    mkdir -p owasp-output
                    dependency-check.sh --scan . --format XML --out owasp-output
                '''
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                withSonarQubeEnv("Sonar") {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=wanderlust \
                        -Dsonar.projectName=wanderlust \
                        -Dsonar.sources=.
                    '''
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
                }
            }
        }

<<<<<<< HEAD
        stage("SonarQube: Quality Gates") {
            steps {
                script {
                    sonarqube_code_quality()
=======
        stage("SonarQube: Code Quality Gates") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
                }
            }
        }

<<<<<<< HEAD
        stage("Export Environment Variables") {
=======
        stage("Exporting environment variables") {
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
            parallel {
                stage("Backend env setup") {
                    steps {
                        dir("Automations") {
<<<<<<< HEAD
                            bat "bash updatebackendnew.sh"
=======
                            sh "bash updatebackendnew.sh"
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
                        }
                    }
                }

                stage("Frontend env setup") {
                    steps {
                        dir("Automations") {
<<<<<<< HEAD
                            bat "bash updatefrontendnew.sh"
=======
                            sh "bash updatefrontendnew.sh"
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
                        }
                    }
                }
            }
        }

        stage("Docker: Build Images") {
            steps {
<<<<<<< HEAD
                dir('backend') {
                    script {
                        docker_build("wanderlust-backend-beta", "${params.BACKEND_DOCKER_TAG}", "madhupdevops")
                    }
                }
                dir('frontend') {
                    script {
                        docker_build("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "madhupdevops")
=======
                script {
                    dir('backend') {
                        sh "docker build -t richarddevops/wanderlust-backend-beta:${params.BACKEND_DOCKER_TAG} ."
                    }
                    dir('frontend') {
                        sh "docker build -t richarddevops/wanderlust-frontend-beta:${params.FRONTEND_DOCKER_TAG} ."
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
                    }
                }
            }
        }

        stage("Docker: Push to DockerHub") {
            steps {
<<<<<<< HEAD
                script {
                    docker_push("wanderlust-backend-beta", "${params.BACKEND_DOCKER_TAG}", "madhupdevops")
                    docker_push("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "madhupdevops")
=======
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push richarddevops/wanderlust-backend-beta:${BACKEND_DOCKER_TAG}
                        docker push richarddevops/wanderlust-frontend-beta:${FRONTEND_DOCKER_TAG}
                    '''
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
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


// @Library('Shared') _
// pipeline {
//     agent {label 'Node'}
    
//     environment{
//         SONAR_HOME = tool "Sonar"
//     }
    
//     parameters {
//         string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
//         string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
//     }
    
//     stages {
        
//         stage("Workspace cleanup"){
//             steps{
//                 script{
//                     cleanWs()
//                 }
//             }
//         }
        
//         stage('Git: Code Checkout') {
//             steps {
//                 script{
//                     code_checkout("https://github.com/DevMadhup/Wanderlust-Mega-Project.git","main")
//                 }
//             }
//         }
        
//         stage("Trivy: Filesystem scan"){
//             steps{
//                 script{
//                     trivy_scan()
//                 }
//             }
//         }

//         stage("OWASP: Dependency check"){
//             steps{
//                 script{
//                     owasp_dependency()
//                 }
//             }
//         }
        
//         stage("SonarQube: Code Analysis"){
//             steps{
//                 script{
//                     sonarqube_analysis("Sonar","wanderlust","wanderlust")
//                 }
//             }
//         }
        
//         stage("SonarQube: Code Quality Gates"){
//             steps{
//                 script{
//                     sonarqube_code_quality()
//                 }
//             }
//         }
        
//         stage('Exporting environment variables') {
//             parallel{
//                 stage("Backend env setup"){
//                     steps {
//                         script{
//                             dir("Automations"){
//                                 sh "bash updatebackendnew.sh"
//                             }
//                         }
//                     }
//                 }
                
//                 stage("Frontend env setup"){
//                     steps {
//                         script{
//                             dir("Automations"){
//                                 sh "bash updatefrontendnew.sh"
//                             }
//                         }
//                     }
//                 }
//             }
//         }
        
//         stage("Docker: Build Images"){
//             steps{
//                 script{
//                         dir('backend'){
//                             docker_build("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","madhupdevops")
//                         }
                    
//                         dir('frontend'){
//                             docker_build("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","madhupdevops")
//                         }
//                 }
//             }
//         }
        
//         stage("Docker: Push to DockerHub"){
//             steps{
//                 script{
//                     docker_push("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","madhupdevops") 
//                     docker_push("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","madhupdevops")
//                 }
//             }
//         }
//     }
//     post{
//         success{
//             archiveArtifacts artifacts: '*.xml', followSymlinks: false
//             build job: "Wanderlust-CD", parameters: [
//                 string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
//                 string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
//             ]
//         }
//     }
// }
