pipeline {
    agent any
    environment {
        docker_registry = 'pratik977/petclinic'
    }
    
    tools { 
        maven 'Maven 3.6.0'
        jdk 'jdk8' 
    }
    stages {
        stage ('Compilation.....') {
            steps {
                sh 'mvn clean compile'
                echo "Successfully Compiled"
            }
        }
        stage ('Testing......') {
            steps{
                sh 'mvn test'
                echo "Successfully tested"
            }
        }
        stage ('Packaging.......'){
            when { anyOf { branch 'main'; branch 'development' } }
            steps{
                sh 'mvn package'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true, followSymlinks: false, onlyIfSuccessful: true
                echo "Successfully archived"
            }

        }
        stage ('Deploy.........'){
            when {
                branch 'main'
            }
            stages{
                stage('Image Build.......') {
                    steps{
                        sh 'docker build -t $docker_registry:$BUILD_NUMBER .'
                        echo "Image Build successfull"
                    }
                }
                stage ('Image Push........') {
                    steps{
                        withDockerRegistry([ credentialsId: "dockerhub_credential", url: "" ]) {
                            sh 'docker push $docker_registry:$BUILD_NUMBER'
                        }
                        echo "Image Successfully pushed to registry"
                    }
                }
                stage ('Removing local image') {
                    steps {
                        sh 'docker rmi $docker_registry:$BUILD_NUMBER'
                    }
                }
                stage ('Final Deployment') {
                    steps{
                        emailext to: 'kumar.pratik@knoldus.com',
                            subject: "Input needed for Job ${JOB_NAME}",
                            body: "Please verify the deployment at ${BUILD_URL}"
                        echo "Email sent"
                        input 'proceed to deploy'
                        sh 'sudo ansible-playbook site.yml --extra-vars image=$docker_registry:$BUILD_NUMBER'
                    }
                }
            }
            
        }
        
        
    }
    post {
        always {
            emailext to: 'kumar.pratik@knoldus.com',
                 subject: "Pipeline: ${currentBuild.fullDisplayName} is ${currentBuild.currentResult}",
                 body: "For complete detail goto ${BUILD_URL}",
                 attachLog: true
        }
    }
}