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
      # OPTIMISATION RAM/CPU : Empêche le conteneur de saturer ton i5
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
          // Les images alpine n'ont pas toujours tous les outils de build. 
          // Si pip install lxml echoue, enleve le '//' de la ligne suivante :
          // sh "apk add --no-cache gcc musl-dev libxml2-dev libxslt-dev"
          
          sh "pip install --no-cache-dir --default-timeout=120 -r requirements.txt" 
          sh "python test.py" 
        } 
      } 
    } 
    // ici pour construire et pousser l'image dans le registry local de minikube, tu peux aussi utiliser un registry distant comme dockerhub ou github packages, mais il faudra adapter les commandes docker build et push en conséquence.
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