STACK_NAME=aws-go-web-stack-001


########## do not edit these vars ##############
DIR_PACKER=packer
DIR_VENDOR=vendor/cookbooks
LOG_AMI=packer/build.log
CFM_TEMPLATE=cfm/stack.json
APP_PORT=8484


.DEFAULT_GOAL := ami

####################
# packer
####################
ami: $(DIR_PACKER)/template.json cookbooks
	@packer validate $<
	@rm -f $(LOG_AMI)
	@packer build -machine-readable $< | tee $(LOG_AMI)

ami-latest: $(LOG_AMI)
	@grep 'artifact,0,id' $(LOG_AMI) | cut -d, -f6 | cut -d: -f2

cookbooks: $(DIR_PACKER)
	@cd $< && berks vendor $(DIR_VENDOR)



####################
# aws cfm
####################
stack-validate: $(CFM_TEMPLATE)
	@aws cloudformation validate-template \
		--template-body file:////$(PWD)/$(CFM_TEMPLATE) >/dev/null

stack-create: stack-validate
	@echo "Stack creation in progress."
	@echo "This will take a few minutes..."
	@aws cloudformation create-stack \
		--stack-name $(STACK_NAME) \
		--template-body file:///$(PWD)/$(CFM_TEMPLATE) \
		--parameters \
			"ParameterKey=AMIID,ParameterValue=$(shell make ami-latest)" \
			"ParameterKey=VPCID,ParameterValue=$(shell make params-vpcid)" \
			"ParameterKey=Subnets,ParameterValue=$(shell make params-subnetid)" \
			"ParameterKey=AZs,ParameterValue=$(shell make params-az)"

stack-delete:
	@echo "Stack deletion in progress."
	@aws cloudformation delete-stack \
		--stack-name $(STACK_NAME)

stack-info:
	@echo "Open this URL in your browser:"
	@aws cloudformation describe-stacks \
	  --stack-name $(STACK_NAME) \
		--query Stacks[0].Outputs[0].OutputValue

params-vpcid:
	@aws ec2 describe-vpcs \
		--filters Name=isDefault,Values=true \
		--output json \
		--query Vpcs[0].VpcId

params-subnetid:
	@aws ec2 describe-subnets \
		--filters Name=vpc-id,Values=$(shell make params-vpcid) \
		--output json \
		--query Subnets[0].SubnetId

params-az:
	@aws ec2 describe-subnets \
		--filters Name=subnet-id,Values=$(shell make params-subnetid) \
		--output json \
		--query Subnets[0].AvailabilityZone

clean:
	@rm -rf $(DIR_PACKER)/$(DIR_VENDOR) $(LOG_AMI)

.PHONY: clean cookbooks ami* stack* params*
