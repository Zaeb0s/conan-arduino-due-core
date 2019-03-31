#!groovy

pipeline 
{
    def client = Artifactory.newConanClient()

    agent any
    stages
    {        
        stage('Checkout')
        {
            steps
            {
                checkout scm        
            }
        }
        stage("Install")
        {
            steps
            {
                sh "mkdir -p build"                
                client.run(command: "install . zaebos/stable -if build -pr profile/arduino-due")
            }
        }
        stage("Source")
        {    
            steps
            {
                client.run(command: "source . -sf build -if build")
            }
        }
        stage("Build")
        {    
            steps
            {                    
                client.run(command: "build . -bf build -if build -sf build")              
            }
        }
        stage("Package")
        {
            steps
            {
                sh "mkdir -p build/package"
                client.run(command: "package . -bf build -if build -sf build -pf build/package")
            }
        }
    }
}