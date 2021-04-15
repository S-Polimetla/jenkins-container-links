def withDockerNetwork(Closure inner) {
  try {
    networkId = UUID.randomUUID().toString()
    sh "docker network create ${networkId}"
    inner.call(networkId)
  } finally {
    sh "docker network rm ${networkId}"
  }
}

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
                    def database = docker.build('database', '-f DbDockerfile .')
                    def sidecar = docker.build('sidecar', '-f SideCarDockerfile .')

                    withDockerNetwork{ n ->
                        database.withRun("--network ${n} --name=database -e POSTGRES_PASSWORD=postgres") { c -> // DB is spun up at this stage
                            try {
                                // sidecar.inside("--network ${n}") {   // This container only gives a run time environment                             
                                //     sh '''
                                //         while ! pg_isready -h localhost -p 5432
                                //         do
                                //             echo $
                                //             echo "$(date) - waiting for database to start"
                                //             sleep 10
                                //         done
                                //     '''
                                // }
                                docker.image('flyway/flyway').inside("--network ${n} -e FLYWAY_URL=jdbc:postgresql://database:5432/postgres") {
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
    }
    post {
        always {
            cleanWs()
        }
    }
}