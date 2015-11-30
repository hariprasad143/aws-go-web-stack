# aws-go-web-stack

- Go web stack deployed with cloudformation, packer and chef-solo
- Designed to be run on a buildbox in the cloud
- Pre-bakes AMI containing application and dependencies with packer for faster deploys
- Cloudformation template creates a load balanced, auto-scaled stack in your default AWS VPC with 2 nodes running a golang web application of your choice







## Set Up

#### Install
	- ruby
	- Berkshelf
	- packer
	- awscli

Make sure you have your AWS credentials set in your shell (access key and secret).









## Build & Deploy

#### 1. Bake AMI with packer and upload to AWS
```
make ami
```

#### 2. Deploy stack with AWS Cloudformation

Will deploy stack to your default VPC.

```
make stack-create
```

#### 3. Visit URL of server in browser
```
make stack-info
```

#### 4. Delete stack
```
make stack-delete
```







## Configuration

#### Golang Web Application
- baked in with packer
- currently pointing to [go-server-best-buy](https://github.com/techjacker/go-server-best-buy)
- update the `app_repo` variable in `packer/template.json` to change the application







## To Do

- image baking
	- use system d as init process for app and remove bootstrapping in cfm launch config
	- turn packer golang shell provisioner into cookbook + add logic for creating binary (ie don't rely on app repo's makefile for this)
	- build a chroot EBS AMI for faster deployments
	- add check to prevent re-baking image if app source code has not changed

- cloudformation
	- create dedicated VPC and subnets for stack in cfm template
	- split cfm template into vpc stack and app stack
	- create private subnets for app stack
	- better logic around handling stack updates
	- add cloudwatch logs
	- add cpu based scaling up and down policies to auto scaling group
