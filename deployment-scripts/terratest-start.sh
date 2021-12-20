#!/bin/bash

# move back to test directory
cd ../tests
go mod init webserver_test
go get -t -v
go mod tidy
go test -v webserver_test.go
