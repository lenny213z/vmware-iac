pipeline {
    agent any

    environment {
        TF_VAR_AKEYLESS_ACCESS_ID   = credentials('jenkins-akeyless-key-id')
        TF_VAR_AKEYLESS_ACCESS_KEY  = credentials('jenkins-akeyless-key-value')
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
        stage('Init') {
            steps {
                terraformInit()
            }
        }
        stage('Plan') {
            steps {
                terraformPlan()
            }
        }
        stage('Approval') {
            steps {
                input(message: 'Apply Terraform ?')
            }
        }
        stage('Apply') {
            steps {
                terraformApply()
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