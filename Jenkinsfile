pipeline{
    agent any
    tools {
        ansible 'ansible'
    }
    environment {
                TERRA_PATH = "${WORKSPACE}/Mysql-Terraform"
                ANSIBLE_PLAY_CR_PATH = "${WORKSPACE}/assignment5/toolbook.yml"
                ANSIBLE_PLAY_DT_PATH = "${WORKSPACE}/assignment5/deletedata.yml"
                ANSIBLE_INVENTORY = "${WORKSPACE}/assignment5/aws_ec2.yml"
            }
    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'choices one option for create/destroy infra')
        choice(name: 'table', choices: ['create', 'delete'], description: 'Choose the action Create or Delete the Table')
    }
    
    stages {
        stage ('git_clone'){
            steps {
                git branch: 'main', url: 'https://github.com/aayushverma191/mysqlpvtinstance.git'
            }
        }
        stage ('user_approval') {
            steps {
                input message: 'Approval for infra' , ok: 'Approved'
            }
        }
        stage ('terraform init') {
            steps {
                sh 'terraform -chdir=${TERRA_PATH} init'
            }
        }
        stage ('terraform validate') {
            steps {
                sh 'terraform -chdir=${TERRA_PATH} validate'
            }
        }
        stage ('terraform plan') {
            steps {
                sh 'terraform -chdir=${TERRA_PATH} plan'
            }
        }
        stage ('terraform apply') {
            when { 
                  expression { params.action == 'apply' }
            }
            steps {
                sh 'terraform -chdir=${TERRA_PATH} apply --auto-approve'
            }
        }
        stage ('terraform destroy') {
            when { 
                  expression { params.action == 'destroy' }
            }
            steps {
                sh 'terraform -chdir=${TERRA_PATH} destroy --auto-approve'
            }
        }
        stage("Install_MySQL_Create-Table") {
              when { 
                  expression { params.table == 'create' && params.action == 'apply' }
              }
              steps {
                    ansiblePlaybook credentialsId: '2a4dea98-3c79-4475-908f-9f764acd5762', disableHostKeyChecking: true, installation: 'ansible',
                    inventory: '${ANSIBLE_INVENTORY}' , playbook: '${ANSIBLE_PLAY_CR_PATH}'
              }
          }
        stage("Delete-Table") {
            when { 
                  expression { params.table == 'delete' && params.action == 'apply' }
            }
            steps {
                ansiblePlaybook credentialsId: '2a4dea98-3c79-4475-908f-9f764acd5762', disableHostKeyChecking: true, installation: 'ansible',
                inventory: '${ANSIBLE_INVENTORY}' , playbook: '${ANSIBLE_PLAY_CR_PATH}'
            }
        }
    }
    post {
            success {
                    slackSend(channel: 'info', message: "Build Successful: JOB-Name:- ${JOB_NAME} Build_No.:- ${BUILD_NUMBER} & Build-URL:- ${BUILD_URL}")
                }
            failure {
                    slackSend(channel: 'info', message: "Build Failure: JOB-Name:- ${JOB_NAME} Build_No.:- ${BUILD_NUMBER} & Build-URL:- ${BUILD_URL}")
                }
    }
}
