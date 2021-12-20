package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformApacheServer(t *testing.T) {

  azList := []string{"us-east-2a", "us-east-2b", "us-east-2c"}
  privateSubList := []string{"10.0.1.0/28"}
  publicSubList := []string{"10.0.10.0/28"}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../",

    Vars: map[string]interface{}{
      "cidr":  "10.0.0.0/16",

      "azs": azList,
      "region": "us-east-2",

      "private_subnets": privateSubList,
      "public_subnets":  publicSubList,

      "apache-ami":   "ami-00d66ebbebe0adef6",
    },
	})

	//Temporarily disabled to destroy for altias test
	//defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the IP of the instance
	publicIp := terraform.Output(t, terraformOptions, "public_ip")

	// Make an HTTP request to the instance and make sure we get back a 200 OK with the body "Hi Altias"
	url := fmt.Sprintf("http://%s:80", publicIp)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hi Altias", 5, 5*time.Second)
}
