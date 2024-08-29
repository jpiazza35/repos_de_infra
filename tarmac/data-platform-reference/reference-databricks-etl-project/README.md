# Reference Databricks ETL Project

Key elements
* Build and manage dependencies with Poetry 
* Local Development
  * databricks-connect
  * VS Code's Databricks Extension
  * PyCharm with Databricks
  

> Refer to CN's [CI/CD Tools Repository](https://github.com/clinician-nexus/ci_tools)

* Continuous Integration Pipeline (ran on commit to non-main branch)
    * Run Unit Tests locally 

* Continuous Delivery Pipeline (ran on merge to main)
  * Run Unit Tests on job cluster
  * Run Integration Tests on job cluster
  * Deploy Databricks Wheel to artifact repository
  * Update Databricks Infrastructure

* Infrastructure as Code
  * Databricks Job + Tasks
  * Databricks Repo
  * Artifact Repository --- AWS CodeArtifact vs DBFS / S3

### Tools / Purpose 

build, ci/cd, test tools, etc


## Development Workflow 

### Notebook Tasks

1. Create and develop your notebook with 
   1. Databricks UI
   2. Databricks Connect 
   3. VS Code
   4. PyCharm  

2. Add Notebook unit tests for Python, Scala, or R code (separate test notebooks)
   
3. Once your notebook confidently works ad-hoc, add it as a notebook task to your overall etl job 
   1. Add it to a Databricks workflow using the Databricks UI
   2. Test the entire Databricks workflow ad-hoc 

4. Add the new notebook resources to the terraform configuration
   1. Add a notebook task to the ETL job, and point it to this repository resource in Databricks Repos

5. Add notebook unit tests to the CI/CD pipeline (add a GH action to run the unit test notebooks locally upon committing code, and on clusters upon deploying code)

### Python Wheel Tasks