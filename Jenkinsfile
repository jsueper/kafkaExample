#!/usr/bin/env groovy

node {
	
	stage('maven') { 
		// pull maven
		checkout scm
		echo("running mvn clean install" + env.BRANCH_NAME)  	    
		sh script: "docker run --rm -v $WORKSPACE:/tmp maven:3.2-jdk-7 /bin/bash -c 'cd /tmp; mvn clean install -U;'", returnStdOut: false
	}

def pipeline = fileLoader.fromGit('script.groovy', 
        'https://github.com/ShehryarAbbasi/kafkaExample.git', 'master', null, '')
echo "Executing Build Pipeline"
pipeline.buildPipeline()
