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
      image: python:3.10-alpine 
      command: 
        - cat 
      tty: true 
      resources:
        requests:
          cpu: "50m"
          memory: "64Mi"
        limits:
          cpu: "200m"
          memory: "256Mi"
    - name: docker 
      image: docker:git 
      command: 
        - cat 
      tty: true 
      env:
        - name: DOCKER_HOST
          value: tcp://host.docker.internal:2375
      resources:
        requests:
          cpu: "50m"
          memory: "64Mi"
        limits:
          cpu: "200m"
          memory: "128Mi"
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
          // Installation des dépendances système requises pour compiler lxml sous Alpine
          sh "apk add --no-cache gcc musl-dev libxml2-dev libxslt-dev"
          
          // Installation des packages Python sans cache pour économiser la RAM
          sh "pip install --no-cache-dir --default-timeout=120 -r requirements.txt" 
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