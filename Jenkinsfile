#!groovy

pipeline 
{
    agent any
    cleanWs()
    checkout scm
    stages
    {                
        stage("Install")
        {
            steps
            {
                echo "PATH: ${PATH}"
                echo "PYTHONPATH: ${PYTHONPATH}"
                sh "mkdir -p build"
                sh "conan install . zaebos/stable -if build -pr profile/arduino-due"
            }
        }
        stage("Source")
        {    
            steps
            {
                sh "conan source . -sf build -if build"                 
            }
        }
        stage("Build")
        {    
            steps
            {                    
                sh "conan build . -bf build -if build -sf build"                 
            }
        }
        stage("Package")
        {
            steps
            {
                sh "mkdir -p build/package"
                sh "conan package . -bf build -if build -sf build -pf build/package"
            }
        }
    }
}