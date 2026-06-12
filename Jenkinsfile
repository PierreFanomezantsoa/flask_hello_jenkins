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
    - name: kubectl 
      image: alpine/k8s:1.29.2
      command: 
        - cat 
      tty: true 
      resources:
        requests:
          cpu: "50m"
          memory: "32Mi"
        limits:
          cpu: "100m"
          memory: "64Mi"
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
          sh "pip install --upgrade pip"
          sh "pip install --no-cache-dir --default-timeout=300 -r requirements.txt" 
          sh "python test.py" 
        } 
      } 
    } 

    stage('Build image') { 
      when {
        branch 'master'
      }
      steps { 
        container('docker') { 
          sh "docker build -t localhost:4000/pythontest:latest ." 
          sh "docker push localhost:4000/pythontest:latest" 
        } 
      } 
    } 

    stage('Deploy') { 
      when {
        branch 'master'
      }
      steps { 
        container('kubectl') { 
          sh "kubectl apply -f ./kubernetes/deployment.yaml" 
          sh "kubectl apply -f ./kubernetes/service.yaml" 
        } 
      } 
    } 
  } 
}