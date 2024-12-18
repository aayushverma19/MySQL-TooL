pipeline {
    agent any
    tools {
        ansible 'ansible'
    }
    environment {
        TERRAFORM_DIR_PATH = "${WORKSPACE}/Mysql-Infra"
        ANSIBLE_PLAY_CR_PATH = "${WORKSPACE}/Mysql-Rool/Mysql.yml"
        ANSIBLE_PLAY_DT_PATH = "${WORKSPACE}/Mysql-Rool/deletedata.yml"
        ANSIBLE_INVENTORY = "${WORKSPACE}/Mysql-Rool/aws_ec2.yml"
    }
    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Terraform action: apply or destroy')
        choice(name: 'table', choices: ['create', 'delete'], description: 'MySQL table: create or delete')
    }
    stages {
        stage ('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/aayushverma191/region.git'
            }
        }
        stage ('Initialize Terraform') {
            when { expression { params.table != 'delete' || params.action == 'destroy' } }
            steps {
                sh "terraform -chdir=${TERRAFORM_DIR_PATH} init"
            }
        }
        stage ('Validate Terraform Configuration') {
            when { expression { params.table != 'delete' || params.action == 'destroy' } }
            steps {
                sh "terraform -chdir=${TERRAFORM_DIR_PATH} validate"
            }
        }
        stage ('Generate Terraform Plan') {
            when { expression { params.table != 'delete' || params.action == 'destroy' } }
            steps {
                sh "terraform -chdir=${TERRAFORM_DIR_PATH} plan"
            }
        }
        stage ('Approval for Apply Action') {
            when { expression { params.action == 'apply' && params.table != 'delete' } }
            steps {
                input message: 'Approval for infrastructure apply', ok: 'Approved'
            }
        }
        stage ('Apply Terraform Changes') {
            when { expression { params.action == 'apply' && params.table != 'delete' } }
            steps {
                sh "terraform -chdir=${TERRAFORM_DIR_PATH} apply --auto-approve"
            }
        }
        stage ('Approval for Destroy Action') {
            when { expression { params.action == 'destroy' || (params.table != 'delete' && params.table != 'create') } }
            steps {
                input message: 'Approval for infrastructure destroy', ok: 'Approved'
            }
        }
        stage ('Destroy Terraform Resources') {
            when { expression { params.action == 'destroy' || (params.table != 'delete' && params.table != 'create') } }
            steps {
                sh "terraform -chdir=${TERRAFORM_DIR_PATH} destroy --auto-approve"
            }
        }
        stage ('Install MySQL and Create Table') {
            when { expression { params.table == 'create' && params.action == 'apply' } }
            steps {
                ansiblePlaybook credentialsId: '98a085ea-0055-4363-9382-81b2371ec021', disableHostKeyChecking: true, installation: 'ansible',
                inventory: "${ANSIBLE_INVENTORY}", playbook: "${ANSIBLE_PLAY_CR_PATH}"
            }
        }
        stage ('Approval for Delete Table') {
            when { expression { params.table == 'delete' && params.action == 'apply' } }
            steps {
                input message: 'Approval for table delete', ok: 'Approved'
            }
        }
        stage ('Delete MySQL Table') {
            when { expression { params.table == 'delete' && params.action == 'apply' } }
            steps {
                ansiblePlaybook credentialsId: '98a085ea-0055-4363-9382-81b2371ec021', disableHostKeyChecking: true, installation: 'ansible',
                inventory: "${ANSIBLE_INVENTORY}", playbook: "${ANSIBLE_PLAY_DT_PATH}"
            }
        }
    }
    post {
        success {
            script {
                if (params.table == 'create' && params.action == 'apply') {
                    slackSend(channel: 'info', message: "Deployment Successful: Installed MySQL & table has been created successfully. Job Details - Name: ${JOB_NAME}, Build Number: ${BUILD_NUMBER}, URL: ${BUILD_URL}")
                } else if (params.action == 'destroy' || (params.table != 'delete' && params.table != 'create')) {
                    slackSend(channel: 'info', message: "Destroy Successful: Infrastructure destruction completed successfully. Job Details - Name: ${JOB_NAME}, Build Number: ${BUILD_NUMBER}, URL: ${BUILD_URL}")
                } else if (params.table == 'delete' && params.action == 'apply') {
                    slackSend(channel: 'info', message: "SUCCESS: The specified MySQL table has been deleted successfully. Job Details - Name: ${JOB_NAME}, Build Number: ${BUILD_NUMBER}, URL: ${BUILD_URL}")
                }
            }
        }
        failure {
            slackSend(channel: 'info', message: "FAILURE: The build process encountered an issue. Job Details - Name: ${JOB_NAME}, Build Number: ${BUILD_NUMBER}, URL: ${BUILD_URL}")
        }
    }
}
