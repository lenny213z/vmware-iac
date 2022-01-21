pipeline {
    agent any

    parameters {
        choice (
            name: 'Env',
            choices: ['Dev', 'Prod']
        )
        choice (
            name: 'Apps',
            choices: ['Web-App', 'Base', 'All']
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
                script {
                    def secrets = [
                        [path: 'secret/data/personal-keys/ribarski/nsxtpoc/akeyless_id', 
                        secretValues: [
                            [envVar: 'TF_VAR_AKEYLESS_ACCESS_ID', vaultKey: 'data']
                            ]
                        ],
                        [path: 'secret/data/personal-keys/ribarski/nsxtpoc/akeyless_key',
                        secretValues: [
                            [envVar: 'TF_VAR_AKEYLESS_ACCESS_KEY', vaultKey: 'data']
                            ]
                        ]
                    ]

                    def workspace = pwd()
                    
                    if(params.Action == 'Destroy') {
                        env.Destroy = '-destroy'
                    } else {
                        env.Destroy = ""
                    }

                    withVault(vaultSecrets: secrets) {
                        sh ("""
                            ln -s -f ${workspace}/environment/${params.Env.toLowerCase()}/${params.Apps.toLowerCase()}.tfvars ${workspace}/terraform/apps/${params.Apps.toLowerCase()}/env.auto.tfvars
                            cd ./terraform/apps/${params.Apps.toLowerCase()};
                            terraform plan ${env.Destroy} -no-color -out=tfout
                        """)
                }
                }
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
