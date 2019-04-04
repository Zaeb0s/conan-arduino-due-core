#!groovy

pipeline 
{
    agent any
    stages
    {    
        stage("Info")
        {
            steps
            {
                echo "PATH: ${PATH}"
                echo "PYTHONPATH: ${PYTHONPATH}"
                sh "mkdir -p build"
                sh "rm -rf build/*"
                sh "conan info . --graph=build/index.html -pr profile/arduino-due"
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '', reportFiles: 'build/index.html', reportName: 'HTML Report', reportTitles: ''])                
            }
        }                    
        stage("Build and run tests")
        {
            steps
            {                
                sh "conan create . zaebos/stable -pr profile/arduino-due"
            }
        }
    }
}
