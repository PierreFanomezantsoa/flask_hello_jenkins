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
      image: python:3.10-slim
      command: 
        - cat 
      tty: true 
      resources:
        requests:
          cpu: "50m"
          memory: "128Mi"
        limits:
          cpu: "300m"
          memory: "512Mi"
    - name: docker 
      image: docker:git 
      command: 
        - cat 
      tty: true 
      securityContext:         # AJOUT : Donne l'autorisation d'accéder à docker.sock
        runAsUser: 0
      volumeMounts:
        - mountPath: /var/run/docker.sock 
          name: docker-sock 
      resources:
        requests:
          cpu: "50m"
          memory: "64Mi"
        limits:
          cpu: "200m"
          memory: "128Mi"
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
          // 1. On met à jour pip pour corriger ses bugs de téléchargement lent
          sh "pip install --upgrade pip"
          
          // 2. On installe les paquets classiques sans vérifier les empreintes
          sh "pip install --no-cache-dir --default-timeout=300 -r requirements.txt" 
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