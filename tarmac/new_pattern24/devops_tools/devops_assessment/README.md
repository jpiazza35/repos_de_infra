# DevOps Assessment

DevOps assessments are a process done with the intention of mapping out the client's (or prospect's) setup from a DevOps perspective.
It should serve as a means of both showing what we can do and how we look at things, but also as a guideline for the work the DevOps team should focus on.

## Prerequisites

The assessor(s) needs to be able to comb through the setup both individually and guided by the owners. For that the following is preferrable:

### Access
* Read-only access to version control (Github, GitLab, Bitbucket, Azure Devops etc.)
* Read-only access to cloud provider (AWS, Azure, GCP, etc.)
* Read-only access to any additional tooling used (CI/CD tools, Logging & Monitoring, 3rd party integrations)
### Meetings
* Introductions / Meet the team - 
  * Determine main point of contact
  * Determine areas of particular interest of the client to add additional focus on
* Current infrastructure setup and walkthrough
* Application context walkthrough
### Tools
* Dedicated communication channel (not email), e.g. cross org slack channel, ms teams, etc.

## Areas of Interest
1. Repository and Developer Organization
   1. Monolith vs Micro-services?
   2. Branching model
   3. Branch clean up and staleness
   4. PR process
2. Test coverage
   1. Test run cadence
   2. Percentage of coverage
   3. History of runs, error frequency
3. Continuous Integration Pipelines
   1. Build triggers
   2. CI tool in use (one or multiple)
   3. Potential security issues
      1. Base image
      2. Secrets
4. Continuous Delivery
   1. Release process
      1. Automated vs Manual
   2. Release frequency
   3. Release model (promotion of artifacts or promotion of code)
   4. Security issues
      1. Artifact store
      2. Secrets injection
      3. Env var handling
      4. Deployment user privileges
5. Infrastructure and Configuration
   1. Is/should be compliant to a framework? (ISO27001, PCI, FedRamp)
   2. Separation of environments
   3. AWS Organizations /  Azure Subscriptions / GCP Cloud Projects
   3. IAM 
      1. Forced MFA?
      2. Least Privilege Principle
      3. Role based access
   4. Networking (AWS/GCP VPC, Azure Virtual Networks)
      1. Isolation
      2. Multi-AZ vs Single AZ
      3. Intra-vpc access (VPN, Bastion, etc.)
      4. Security groups with 0.0.0.0/0
      5. Route Tables
   5. DB
      1. Encryption at rest
      2. Avoid public access
      3. Failover / Resilience
      4. Scaling
      5. Clean-up
      6. Backup & Restore / Disaster Recovery
   6. Container Registries
      1. Tag immutability
      2. CVE scanning and reporting
   7. Static Storage (S3)
      1. Public access
      2. Clean up
      3. Sensitive data
      4. Stativ web site hostings
   8. Compute Engines (AWS EC2, ECS, Azure VMs etc.)
      1. Autoscaling
      2. Metrics and logs collection
      3. Immutability
   9. Monitoring
      1.  Alarms
      2.  Dashboards
      3.  Log parsing metrics
6. Expenditure Analysis
   1. Uptime on non-production environments
   2. Scheduled auto-scaling
   3. Instance/Resource Reservation
   4. Over-provisioned resources
7. Application Context
   1. Type of data handled. Sensitive, private, public, etc.?
   2. Traffic burst hours (if any)
   3. User session length and persistence (to determine feasibility of CD)
   4. Client tenancy (is infra multi-tenant or instance per client)
   5. Client data isolation   
8. Secrets (AWS/GCP Secrets Manager, Azure KeyVault)
   1. Access/Permissions 
   2. Enable Data protection
   3. Separate Secrets per environment
9. Security and Vulnerabilities
    1. AWS Security Hub
    2. Azure Defender for Cloud
    3. GCP Security Command Center    
10. Any additional area the client requested focus on

## Findings

The findings should follow the structure above, and should contain any and all things the assessor(s) identify, irrelevant whether or not the findings is already known to the client.

## Recommendations

The recommendations should be logically grouped and should as closely as possible match the structure defined above.
Furthermore, all recommendations should be classified into **Quick Wins** vs **Long term**.
Example:
> * Database
>   * Quick Wins
>       * Enable Encryption (at least on Production)
>       * Enable Multi-AZ (at least on Production)
>       * Enable delete protection on all DBs
>   * Long term 
>       * Revise backup/restore procedure

## Notes
* Assessments should be timeboxed to 2 weeks max.
* Over-communicate.
* If unsure about something, verify with the client team, DO NOT ASSUME!
* Use google docs, share only with necessary people in Tarmac
* Share with client by exporting to PDF and emailing, CC: Brent & Account Manager.
