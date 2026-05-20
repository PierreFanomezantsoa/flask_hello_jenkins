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
      # On pointe directement vers le proxy TCP de ton Docker Desktop Windows
      env:
        - name: DOCKER_HOST
          value: tcp://host.docker.internal:2375
""" 
    } 
  } 

  triggers { 
      pollSCM('*/10 * * * *') 
  } 
// stage jenkinsfile pour tester l'app et construire l'image
  stages { 
    stage('Test python') { 
      steps { 
        container('python') { 
          sh "pip install --default-timeout=120 -r requirements.txt" 
          sh "python test.py" 
        } 
      } 
    } 
// stage pour build image et la push sur le registry local de Docker Desktop Windows
    stage('Build image') { 
      steps { 
        container('docker') { 
          // Plus besoin de chmod ici, la connexion passe 
          sh "docker build -t localhost:4000/pythontest:latest ." 
          sh "docker push localhost:4000/pythontest:latest" 
        } 
      } 
    } 
  } 
}