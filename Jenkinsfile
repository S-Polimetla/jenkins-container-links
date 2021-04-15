pipeline {
    agent { label 'docker && linux && nonprod' }  // use a jenkins slave which has docker installed on it

    options {
        buildDiscarder(logRotator(daysToKeepStr: '90', numToKeepStr: '20', artifactDaysToKeepStr: '90', artifactNumToKeepStr: '20'))
        timeout(time: 20, unit: 'MINUTES') 
    }
    stages {
        stage('build & test') {
            environment {
                POSTGRES_DB = 'capital'
                POSTGRES_USER = 'postgres'
                POSTGRES_PASSWORD = 'postgres'                
                FLYWAY_URL = 'jdbc:postgresql://localhost:5432/capital'
                FLYWAY_USER = 'postgres'
                FLYWAY_PASSWORD = 'postgres'
            }
            steps {
                checkout scm                
                script {                    
                    docker.image('postgres').withRun("--name=db -e POSTGRES_PASSWORD=postgres") { c -> // DB is spun up at this stage
                        try {
                            docker.image('postgres').inside("--link ${c.id}:db") {   // This container only gives a run time environment                             
                                sh '''
                                    while ! pg_isready -h db -p 5432
                                    do
                                        echo $
                                        echo "$(date) - waiting for database to start"
                                        sleep 10
                                    done
                                    '''
                                }
                                docker.image('flyway/flyway').inside("--link ${c.id}:db") {
                                    sh 'sleep 10' // Giving DB enough time to start
                                    sh 'info'  // Trying a connection to the DB                                    
                                }
                        } catch (exc) {
                            sh "docker logs ${c.id}"  // Logs of the first postgres container
                            throw exc
                        }
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