#!groovy

// this is a comment3
// using this to format our comment block when posting back to Github
import groovy.json.JsonOutput   


def buildPipeline() {
	def colorS = "\033[1;34m"
	def colorE = "\033[0m"

	node {

	    stage('Checkout') {

		checkout scm

		ansiColor('bash') { 
		    echo(colorS + "checking out branch: " + env.BRANCH_NAME + colorE)
		    git_commit = sh script: "git rev-parse  HEAD", returnStdout: true
		    githubAPI = "https://api.github.com/repos/ShehryarAbbasi/testjenkinsfile/commits/${git_commit.trim()}/comments"
		    sh script: "ls -l"
		}
	    }


	    stage('RunTerraform') {

		if (env.BRANCH_NAME == 'master') {
		    ansiColor('bash') { 
			echo(colorS + "This is the master branch, running terraform plan and apply" + colorE)
		       // sh script: "docker run --rm -v $WORKSPACE:/tmp tf:latest /bin/bash -c 'cd /tmp; terraform init -force-copy; terraform plan -out=plan; terraform apply plan'", returnStdout: false
			    sh script: "docker run --rm -v $WORKSPACE:/tmp tf:latest /bin/bash -c 'cd /tmp; terraform init -force-copy; terraform plan -out=plan; terraform apply plan;'", returnStdout: false
		    }
		} else {
		    ansiColor('bash') { 
			echo(colorS + "This is not the master branch, running terraform plan only. Merge to Master to run terraform apply." + colorE)
			sh script: "docker run --rm -v $WORKSPACE:/tmp tf:latest /bin/bash -c 'cd /tmp; terraform init -force-copy; terraform plan -out=plan;'", returnStdout: false // -c 'cd /tmp && terraform plan && terraform init -force-copy'", returnStdout: true
		    }
		}	
		}
	}
}
return this;
