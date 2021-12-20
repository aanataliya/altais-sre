#!/bin/bash

# move back to parent directory
cd ..

terraform init
terraform plan -out apply.out
terraform apply apply.out
