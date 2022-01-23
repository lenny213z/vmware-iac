pipeline {
    agent any

    environment {
        TF_VAR_AKEYLESS_ACCESS_ID   = credentials('jenkins-akeyless-key-id')
        TF_VAR_AKEYLESS_ACCESS_KEY  = credentials('jenkins-akeyless-key-value')
        AWS_PROFILE                 = "pinfos"
        AWS_ACCESS_KEY_ID           = credentials('jenkins-aws-key-id')
        AWS_SECRET_ACCESS_KEY       = credentials('jenkins-aws-key-value')
        VAULT_ADDR                  = "https://hvp.akeyless.io"
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
            steps {
                input(message: 'Apply Terraform ?')
            }
        }
        stage('Terraform Apply') {
            steps {
                terraformApply()
            }
        }
        stage('Setup Ansible Env') {
            when { 
                allOf {
                    expression {
                        return params.Action == 'Build'
                        return params.Apps == 'DB-App' || 'Web-App'
                    }
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
                allOf {
                    expression {
                        return params.Action == 'Build'
                        return params.Apps == 'DB-App' || 'Web-App'
                    }
                }
            }
            steps {
                applyAnsible()
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
