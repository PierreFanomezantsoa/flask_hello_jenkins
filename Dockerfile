FROM python:3.10-slim

# Ne pas lancer les app en root dans docker 
RUN useradd flask 
WORKDIR /home/flask 

# Ajouter tout le contexte sauf le contenu de .dockerignore 
ADD . . 

# Installer les déps python, pas besoin de venv car docker 
RUN pip install --no-cache-dir -r requirements.txt 

RUN chmod a+x app.py test.py && \
    chown -R flask:flask ./ 

# Déclarer la config de l'app (Format moderne corrigé):::
ENV FLASK_APP=app.py 

EXPOSE 5000 

# Changer d'user pour lancer l'app ::::
USER flask 
CMD ["python", "app.py"]