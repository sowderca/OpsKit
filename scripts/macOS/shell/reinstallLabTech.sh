#!/bin/sh

LT_BASEDIR="/usr/local/ltechagent"
LT_ADDRESS="https://labtech.vc3.com/Deployment.aspx?installType=mac"

function reinstallLT() {
	local LOCATION_ID
	LOCATION_ID=$arg1
	if [ LTSvc.mpkg ]; then
		rm LTSvc.mpkg
	fi

	if [ LTAgent.zip ]; then
		rm LTAgent.zip
	fi

	if [ config.sh ]; then
		rm config.sh
	fi

	curl "$LT_ADDRESS" -o LTAgent.zip && \
		unzip LTAgent.zip && \
		awk 'NR==3{$0="LT_LOCATION=$arg1"}1' config.sh > temp.sh && \
		mv temp.sh config.sh && \
		sudo installer -pkg LTSvc.mpkg -target /
}

pushd /tmp/
reinstallLT $arg1
popd
