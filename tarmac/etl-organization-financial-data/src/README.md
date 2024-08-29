# moodys-web-scraper
Clara's web scraping project

##  Outline
To do list:


1. Take the downloaded excel file and upload to s3.  (ignore until granted AWS access)
2. Write the Dockerfile. Copy script into image, run script.
3. Execute the docker container locally. `docker run ...`
4. GitHub action - build the container when there is a commit pushed to the main branch


## References 

Uploading to s3: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html

Python dockerfile: https://docs.docker.com/language/python/build-images/
Selenium docker images: https://hub.docker.com/u/selenium/


CICD
https://www.redhat.com/en/topics/devops/what-is-ci-cd
https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions


## Docker Compose 
Just using the docker-compose ecs integration instead of terraform

https://docs.docker.com/cloud/ecs-integration/

