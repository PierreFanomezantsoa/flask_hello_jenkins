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
    - name: docker 
      image: docker 
      command: 
        - cat 
      tty: true 
      securityContext:
        privileged: true
      volumeMounts: 
        - mountPath: /var/run/docker.sock 
          name: docker-sock 
  volumes: 
    - name: docker-sock
      hostPath: 
        path: /var/run/docker.sock 
""" 
    } 
  } 

  triggers { 
      pollSCM('*/10 * * * *') 
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

    stage('Build image') { 
      steps { 
        container('docker') { 
          // Ajustement des privilèges du fichier socket au runtime
          sh "chmod 777 /var/run/docker.sock || chmod 666 /var/run/docker.sock || true"
          
          // Build et envoi de l'image sur ton registry local
          sh "docker build -t localhost:4000/pythontest:latest ." 
          sh "docker push localhost:4000/pythontest:latest" 
        } 
      } 
    } 
  } 
}