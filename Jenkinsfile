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
          // On augmente la tolérance réseau et on contourne le cache défectueux
          sh "pip install --no-cache-dir --default-timeout=200 -r requirements.txt --add-host pypi.org:23.235.47.223" 
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