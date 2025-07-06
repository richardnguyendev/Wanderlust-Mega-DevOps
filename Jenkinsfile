// =============================
// ✅ HÀM DÙNG CHUNG
// =============================
def trivy_scan() {
    echo "🔍 Trivy scan running..."
    sh 'trivy fs . || true'
}

def owasp_dependency() {
    echo "🔒 OWASP Dependency check running..."
    sh '''
        mkdir -p owasp-output
        dependency-check.sh --scan . --format XML --out owasp-output
    '''
}

def sonarqube_analysis(toolName, projectKey, projectName) {
    withSonarQubeEnv("${toolName}") {
        sh """
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
    sh "docker build -t ${dockerUser}/${imageName}:${tag} ."
}

def docker_push(imageName, tag, dockerUser) {
    echo "📤 Docker push: ${dockerUser}/${imageName}:${tag}"
    sh "docker push ${dockerUser}/${imageName}:${tag}"
}

// =============================
// ✅ PIPELINE CHÍNH
// =============================
pipeline {
    agent { label 'Node' }

    environment {
        SONAR_HOME = tool 'Sonar'
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

        stage("Git: Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/richardnguyendev/Wanderlust-Mega-DevOps.git'
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
                sh '''
                    mkdir -p owasp-output
                    ~/dependency-check --scan . --format XML --out owasp-output
                '''
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "wanderlust", "wanderlust")
                }
            }
        }

        stage("SonarQube: Quality Gate") {
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage("Exporting Environment Variables") {
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
                script {
                    dir('backend') {
                        docker_build("wanderlust-backend-beta", "${params.BACKEND_DOCKER_TAG}", "richarddevops")
                    }
                    dir('frontend') {
                        docker_build("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "richarddevops")
                    }
                }
            }
        }

        stage("Docker: Push to DockerHub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push richarddevops/wanderlust-backend-beta:${BACKEND_DOCKER_TAG}
                        docker push richarddevops/wanderlust-frontend-beta:${FRONTEND_DOCKER_TAG}
                    '''
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
