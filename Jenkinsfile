pipeline {
    agent {
        kubernetes {
            defaultContainer "robot"
            yamlFile('build/pod.yaml')
        }
    }

    stages {

        stage("Execute robot") {


            steps {
                sh(script: "cp adbkeys/* /root/.android/")
                sh(script: "/usr/bin/python3 run_parallel_tests.py ./Tests/SpeedTestApp.robot ")
            }
        }
    }

    post {
        always {
            robot outputPath: './Output',
                logFileName: 'log.html',
                outputFileName: 'output.xml',
                reportFileName: 'report.html',
                passThreshold: 100,
                unstableThreshold: 75.0

            archiveArtifacts 'Output/'
        }

    }
}
