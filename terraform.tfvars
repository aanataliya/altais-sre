# Global variables change if required
# Note: If any variables are changed here, it also needs to change in test case under file tests/webserver_test.google_compute_address

cidr = "10.0.0.0/16"
azs  = ["us-east-2a", "us-east-2b", "us-east-2c"]
region = "us-east-2"
private_subnets = ["10.0.1.0/28"]
public_subnets  = ["10.0.10.0/28"]
apache-ami           = "ami-00d66ebbebe0adef6"
