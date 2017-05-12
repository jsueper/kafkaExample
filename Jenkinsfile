#!/usr/bin/env groovy

// pull maven
 def exists = fileExists 'pom.xml'
	      if (exists) { 
		stage('Maven') {
		    ansiColor('bash') { 
			echo(colorS + "running mvn clean install" + env.BRANCH_NAME + colorE)  	    
			sh script: "docker run --rm -v $WORKSPACE:/tmp maven:3.2-jdk-7 /bin/bash -c 'cd /tmp; mvn clean install -U;'", returnStdOut: false
		    }
		 }  
	      } else {}

def pipeline = fileLoader.fromGit('script.groovy', 
        'https://github.com/ShehryarAbbasi/kafkaExample.git', 'master', null, '')
echo "Executing Build Pipeline"
pipeline.buildPipeline()
