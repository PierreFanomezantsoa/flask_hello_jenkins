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
      // Vérification toutes les 10 minutes pour soulager la RAM de ton PC
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
          sh "docker build -t localhost:4000/pythontest:latest ." 
          sh "docker push localhost:4000/pythontest:latest" 
        } 
      } 
    } 
  } 
}