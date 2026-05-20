pipeline { 
  agent { 
    kubernetes { 
      label 'jenkins-agent-my-app' 
      yaml """ 
apiVersion: v1 
kind: Pod 
metadata: 
  labels: 
    component: ci 
spec: 
  containers: 
    - name: python 
      image: python:3.10 
      command: 
        - cat 
      tty: true 
""" 
    } 
  } 

  triggers { 
      pollSCM('* * * * *') 
  } 

  stages { 
    stage('Test python') { 
      steps { 
        container('python') { 
          sh "pip install --default-timeout=120 -r requirements.txt" 
          sh "python test.py" 
        } 
      } 
    } 
  } 
}