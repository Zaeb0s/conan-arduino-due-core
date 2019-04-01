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
                sh "conan info . --graph=build/package.hmtl -pr profile/arduino-due"
                archiveArtifacts artifacts: 'build/package.html'
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