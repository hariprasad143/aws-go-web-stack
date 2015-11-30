#!/bin/bash

downloadZipAndExtractToSoftwareDir () {
	cd /tmp
	local dir_output="/opt/$2"
	wget -O "$2" "$1"
	sudo mkdir -p "$dir_output"
	sudo unzip -d "$dir_output" "$2"
	cd "$dir_output/aws-cfn-bootstrap-1.4"
	mv * ./..
	ls -l "$dir_output/bin"
}

# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-helper-scripts-reference.html
# /opt/aws/bin/cfn-signal
url=https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.zip

apt-get install -y unzip

downloadZipAndExtractToSoftwareDir "$url" "aws"
