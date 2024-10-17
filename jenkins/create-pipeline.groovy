import jenkins.model.*
import hudson.model.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

def createPipelineJob(String jobName, String pipelineScript) {
    def jenkins = Jenkins.instance
    def existingJob = jenkins.getItem(jobName)
    if (existingJob) {
        println "Job '${jobName}' already exists. Skipping creation."
        return
    }

    // Create a new pipeline job
    def pipelineJob = new WorkflowJob(jenkins, jobName)
    pipelineJob.setDefinition(new CpsFlowDefinition(pipelineScript, true))
    jenkins.add(pipelineJob, jobName)

    println "Job '${jobName}' created successfully."
}

def pipelineScript = """
pipeline {
    agent {
        docker {
            image 'node:14'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials'
        DOCKER_IMAGE_NAME = 'yourdockerhubusername/hackathon-starter'
        GIT_REPO_URL = 'https://github.com/sahat/hackathon-starter.git'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "\${GIT_REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def image = docker.build("\${DOCKER_IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "\${DOCKER_HUB_CREDENTIALS}") {
                        def image = docker.build("\${DOCKER_IMAGE_NAME}:latest")
                        image.push("latest")
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
"""

createPipelineJob("AutoCreatedPipeline", pipelineScript)

