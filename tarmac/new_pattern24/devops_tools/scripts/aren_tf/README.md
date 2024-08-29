# Tarmac TF Validator
This is a simple terraform file cleanliness validator specific to the Tarmac standard way of working with TF.
The checks will only be performed over the .tf and .tfvars files.

## Usage
Download this folder to any locations
Run
```
python3 validate.py
```
You will then get a prompt to enter the root filepath (absolute or relative) to your terraform folder
```
Enter the root filepath to your terraform code:
```
After that all findings will be both printed and saved in report.txt file in your current working directory.

## Currently implemented checks
* Find all hardcoded AWS region strings in the /modules folder.
* Find all hardcoded AWS account IDs in the /modules folder.
* Find all hardcoded passwords in all files.
* Find all open ingres/egress rules in all files.