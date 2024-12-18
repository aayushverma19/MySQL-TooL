pipeline{
    agent any
    tools {
        ansible 'ansible'
    }
    environment {
                TERRA_PATH = "${WORKSPACE}/Mysql-Infra"
                ANSIBLE_PLAY_CR_PATH = "${WORKSPACE}/Mysql-Rool/Mysql.yml"
                ANSIBLE_PLAY_DT_PATH = "${WORKSPACE}/Mysql-Rool/deletedata.yml"
                ANSIBLE_INVENTORY = "${WORKSPACE}/Mysql-Rool/aws_ec2.yml"
            }
    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'choices one option for create/destroy infra')
        choice(name: 'table', choices: ['create', 'delete'], description: 'Choose the action Create or Delete the Table')
    }
    stages {
        stage ('git_clone'){
            steps {
                git branch: 'main', url: 'https://github.com/aayushverma191/region.git'
            }
        }
        stage ('terraform init') {
            when { 
                  expression { params.table != 'delete' || params.action == 'destroy' }
              }
            steps {
                sh 'terraform -chdir=${TERRA_PATH} init'
            }
        }
        stage ('terraform validate') {
            when { 
                  expression {  params.table != 'delete' || params.action == 'destroy' }
            }
            steps {
                sh 'terraform -chdir=${TERRA_PATH} validate'
            }
        }
        stage ('terraform plan') {
            when { 
                  expression {  params.table != 'delete' || params.action == 'destroy' }
            }
            steps {
                sh 'terraform -chdir=${TERRA_PATH} plan'
            }
        }
        stage ('approval apply') {
            when { 
                 expression { params.action == 'apply' && params.table != 'delete' }
            }
            steps {
                input message: 'Approval for infra apply' , ok: 'Approved'
            }
        }
        stage ('terraform apply') {
            when { 
                 expression { params.action == 'apply' && params.table != 'delete' }
            }
            steps {
                sh 'terraform -chdir=${TERRA_PATH} apply --auto-approve'
            }
        }
        stage ('approval destroy') {
            when { 
                  expression { params.action == 'destroy'  || ( params.table != 'delete' && params.table != 'create' )}
            }
            steps {
                input message: 'Approval for infra destory' , ok: 'Approved'
            }
        }
        stage ('terraform destroy') {
            when { 
                  expression { params.action == 'destroy'  || ( params.table != 'delete' && params.table != 'create' )}
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
                    ansiblePlaybook credentialsId: '98a085ea-0055-4363-9382-81b2371ec021', disableHostKeyChecking: true, installation: 'ansible',
                    inventory: '${ANSIBLE_INVENTORY}' , playbook: '${ANSIBLE_PLAY_CR_PATH}'
              }
          }
        stage ('delete table approval') {
            when { 
                expression { params.table == 'delete' && params.action == 'apply' }
            }
            steps {
                input message: 'Approval for table delete' , ok: 'Approved'
            }
        }
        stage("Delete-Table") {
            when { 
                  expression { params.table == 'delete' && params.action == 'apply' }
            }
            steps {
                ansiblePlaybook credentialsId: '98a085ea-0055-4363-9382-81b2371ec021', disableHostKeyChecking: true, installation: 'ansible',
                inventory: '${ANSIBLE_INVENTORY}' , playbook: '${ANSIBLE_PLAY_DT_PATH}'
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
