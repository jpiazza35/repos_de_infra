# AWS WAF

This is the directory where all AWS Web Application Firewall (WAF) resources are defined. This module creates the following resources:

- WAF rules
- Association to API GW

## Structure ##

The `.tf` files in this module are named per what they manage e.g. `rules.tf` manages the creation of the WAF rules.

## How it works ##
How this code works is that in order for the resources written in this directory to be applied and created, we need to run the Terraform commands in the appropriate AWS account directory. 

For example if we want to create the WAF infra in the AWS `example-account`, we need to go into `my_folder/example_account` directory and initialize, plan and apply the changes with TF commands. The `main.tf` file there contains all modules needed for that AWS account and connects to directories created in the `terraform_modules` dir, just like this `terraform_modules/waf` one.
## Tool Versions ##
Terraform version used in this repository is 0.14.11

Note: this Terraform version is specific to the project where the module was created and used.
You should pick the Terraform version that meets your project's requirements. 

## WAF Details

We have a set of web access control lists (web ACLs) monitoring HTTP(S) requests for our applications in our accounts to help protect them from attacks. 

Each web ACL, have rules that define how to handle incoming requests. The rules and rule groups specify conditions like originating IP addresses and regex patterns to look for. Based on the conditions, the web ACL determines whether to allow or block each request. The protected AWS resource responds to the request with either the requested content (allowed request) or with an HTTP 403 status code (blocked request). 

At this point, we have the following rules in our web ACL:
    * AWS-BotControlRuleSet: AWS WAF Bot Control offers you protection against automated bots that can consume excess resources, skew business metrics, cause downtime, or perform malicious activities. Bot Control provides additional visibility through Amazon CloudWatch and generates labels that you can use to control bot traffic to your applications.
	* AWS-CommonRuleSet: Contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities, including those described in OWASP publications.
	* AWS-AmazonIpReputationList: This group contains rules that are based on Amazon threat intelligence. This is useful if you would like to block sources associated with bots or other threats.
	* AWS-KnownBadInputs: Contains rules that allow you to block request patterns that are known to be invalid and are associated with exploitation or discovery of vulnerabilities. This can help reduce the risk of a malicious actor discovering a vulnerable application.

Those rules can be found in the rules.tf file. The rule action tells AWS WAF what to do with a web request when it matches the criteria defined in the rule (Count/Allow/Block/CAPTCHA). We can override rule actions when we add them to a web ACL. When we do this, the rule runs with the action set to count. Currently all rules have override rule to count, meaning AWS WAF doesn't act upon them (block) and allow everything and just count the requests that match those rules.

This is the block we need to add for overriding a rule:

    override_action {
      count {}
    }

Useful documentation: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rules.html
