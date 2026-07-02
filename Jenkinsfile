pipeline {

    agent any

    stages {

        stage('Checkout Successful') {

            steps {

                echo 'Pipeline loaded from Git!'

            }

        }

        stage('workspace'){
            steps {
                sh '''
                pwd
                ls -ltr

                '''
            }
        }

    }

}
