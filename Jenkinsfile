#!groovy

pipeline 
{
    agent any
    stages
    {        
        stage('Checkout')
        {
            checkout scm        
        }
        stage("Install")
        {
            sh "mkdir build"
            sh "conan install . zaebos/stable -if build -pr profile/arduino-due"
        }
        stage("Source")
        {                        
            sh "conan source . -sf build -if build"                 
        }
        stage("Build")
        {                        
            sh "conan build . -bf build -if build -sf build"                 
        }
        stage("Package")
        {
            sh "conan package . -bf build -if build -sf build -pf build/package"
        }
    }
}