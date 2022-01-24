pipeline {
    agent any

    environment {
        TF_VAR_AKEYLESS_ACCESS_ID   = credentials('jenkins-akeyless-key-id')
        TF_VAR_AKEYLESS_ACCESS_KEY  = credentials('jenkins-akeyless-key-value')
        AWS_PROFILE                 = "pinfos"
        AWS_ACCESS_KEY_ID           = credentials('jenkins-aws-key-id')
        AWS_SECRET_ACCESS_KEY       = credentials('jenkins-aws-key-value')
        VAULT_ADDR                  = "https://hvp.akeyless.io"
        HOOK                        = credentials('msteams-webhook')
    }

    options {
        office365ConnectorWebhooks([[
                    startNotification: true,
                    notifySuccess: true,
                    notifyFailure: true,
                        url: "${env.HOOK}"
            ]]
        )
    }

    parameters {
        choice (
            name: 'Env',
            choices: ['Dev', 'Prod']
        )
        choice (
            name: 'Apps',
            choices: ['Base', 'Web-App', 'DB-App']
        )
        choice(
            name: 'Action',
            choices: ['Build', 'Destroy']
        )
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/lenny213z/vmware-iac.git'

                sh """
                ls -all
                """
            }
        }
        stage('Terraform Init') {
            steps {
                terraformInit()
            }
        }
        stage('Terraform Plan') {
            steps {
                terraformPlan()
            }
        }
        stage('Approval') {
            parallel {
                stage('Wait for Approval') {
                    steps {
                        input(message: 'Apply Terraform ?')
                    }
                }
                stage('Notify in Teams') {
                    steps {
                        office365ConnectorSend (
                            webhookUrl: "${env.HOOK}",
                            message: "The **${params.Apps}** Application is waiting for an Aproval for Action - **${params.Action}**"
                        )
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                terraformApply()
            }
        }
        stage('Setup Ansible Env') {
            when { 
                expression {
                    return params.Action == 'Build'
                }
                expression {
                    params.Apps == 'DB-App' || 
                    params.Apps == 'Web-App'
                }
            }
            steps {
                sh("""
                    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
                    virtualenv iac
                    source ./iac/bin/activate
                    pip install -r requirements.txt
                """)
            }
        }
        stage('Apply Ansible if Any') {
            when { 
                expression {
                    return params.Action == 'Build'
                }
                expression {
                    params.Apps == 'DB-App' || 
                    params.Apps == 'Web-App'
                }
            }
            steps {
                applyAnsible()
            }
        }
        stage('Chef Inspec for Web-App') {
            when {
                expression {
                    return params.Action == 'Build'
                }
                expression {
                    return params.Apps == 'Web-App'
                }
            }
            sptes {
                inspecValidation()
            }
        }
        
    }
    post {
        always {
            echo 'Deleting Directory!'
            deleteDir()
        }
    }
}

def terraformInit() {
    sh("""
        cd ./terraform/apps/${params.Apps.toLowerCase()};
        terraform init
        terraform workspace select ${params.Env.toLowerCase()} || terraform workspace new ${params.Env.toLowerCase()}
    """)
}

def terraformPlan() {
    // Setting Terraform Destroy flag
    if(params.Action == 'Destroy') {
        env.DESTROY = '-destroy'
    } else {
        env.DESTROY = ""
    }

    sh("""
        ln -s -f ${workspace}/environment/${params.Env.toLowerCase()}/${params.Apps.toLowerCase()}.tfvars ${workspace}/terraform/apps/${params.Apps.toLowerCase()}/env.auto.tfvars
        cd ./terraform/apps/${params.Apps.toLowerCase()};
        terraform plan ${env.Destroy} -no-color -out=tfout
    """)
}

def terraformApply() {
    sh("""
        ln -s -f ${workspace}/environment/${params.Env.toLowerCase()}/${params.Apps.toLowerCase()}.tfvars ${workspace}/terraform/apps/${params.Apps.toLowerCase()}/env.auto.tfvars
        cd ./terraform/apps/${params.Apps.toLowerCase()};
        terraform apply tfout -no-color
        terraform output | awk -f ../../../bin/awk | awk 'NF >0' > ../../../inspec/files/output
    """)
}

def applyAnsible () {
    withCredentials([
        file(credentialsId: 'ansible_hosts', variable: 'host'), 
        file(credentialsId: 'ansible_vault', variable: 'vault'),
        sshUserPrivateKey(credentialsId: 'ansible_ssh', keyFileVariable: 'ssh')
        ]) {
            sh ("""
                source ./iac/bin/activate
                printf "We have a playbook for '%s'. Appling Ansible...\n" ${params.Apps.toLowerCase()}
                export ANSIBLE_CONFIG="${workspace}/ansible/ansible.cfg"
                ansible-playbook -i "${host}" "${workspace}/ansible/${params.Apps.toLowerCase()}.yaml" --key-file "${ssh}" --vault-password-file "${vault}"
            """)
        }
}

def inspecValidation () {
    sh ("""#!/bin/bash
        while read -r h; do inspec exec -t ssh://ansible@$h -i ./secrets/ssh-keys/ansible --sudo ./inspec/vm & done < ./inspec/files/output
    """)
}
