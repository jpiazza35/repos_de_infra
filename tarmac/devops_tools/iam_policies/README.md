# IAM policy examples #

We put all helpful IAM policies in this directory. Policies can be both identity-based or resource-based, pretty much everything that you found helpful in restricting or conditionalizing access to an AWS account or resource.

1. IAM user self manage MFA policy restricts IAM users access to only be able to manage their own IAM user and nothing else, unless they set MFA. This means the user must add MFA before any other policy or policies attached to their user take place. (e.g. admin access policy wont work if no MFA is set)