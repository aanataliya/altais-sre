This repo is for altais sre test.

Please note that all commands and scripts have been written and tested on mac OS. I have tried to avoid any OS Specific commands so it should work on any unix based system.

**Prerequisite:**

1. AWS version 2.4.6 is required
2. AWS Cli should be configured using access_key,secret_key and should be networking
3. Terraform version 1.1.1 is required
4. Minikube version 1.24.0 is required
5. Docker version 20.10.12 is required
6. Go lang version 1.17.5 is required


Below infrastrcture is created using terraform script.

- VPC
- Private and Public subnets
- Route tables
- Internet Gateway
- S3 bucket with notification event configured to SQS
- SQS Event
- S3 file Object
- A test  case to verify webserver url repsponse written using Terratest (Go Lang)

Apart from that, A small python application is created for demonstration purpose. This app is created using docker which will be deployed through kubernetes configuration. Minikube is used to deploy application.

***Please verify Architecture diagram in Diagram folder.***

**How to Test:**

**1. Test Terraform Deployment**

Run below commands from altais-sre folder

cd deployment-scripts

sh terraform-deploy.sh

This will create all infrastructure in AWS as specified in architectural diagram  along with a S3 bucket with a file uploaded. A SQS notification must have been sent and you may verify it on SQS notification by clicking poll messages.

**2. Test terraTest unit test**

Run below commands from altais-sre folder

cd deployment-scripts

sh terratest-start.sh

This will run terraTest framework and execute test case. You will see output of PASS/FAIL at the end of the script.


**3. Test k8s Deployment**

Please make sure below points before testing

1. Minikube should be installed
2. docker service should be running

Run below commands from altais-sre folder

cd deployment-scripts

sh k8s-deploy.sh

This will deploy python app inside kubernetes and expose a URL. at the end of script , it wil print a url ending with /sayhi. If you execute this url with curl command, you should be able to get response "Hello Altais" from python microservice on kubernetes pod.
