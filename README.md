# container-links-jenkins

## Strategy

1. A postgres container is run with more or less default parameters
2. Another postgres container is linked to the first container, only to use pg_isready commandline to wait until the DB is ready to take connections
3. Use flyway container to run DB migrations against the DB setup in step 1. Eventually planned to run E2E tests also with web applications

Stackoverflow question [here](https://stackoverflow.com/questions/66893125/using-docker-container-links-in-jenkins)