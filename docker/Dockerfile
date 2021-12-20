FROM python:alpine3.7

ENV FLASK_APP=app.py

RUN mkdir -p /home/altais
COPY python-app/requirements.txt home/altais/requirements.txt

RUN apk add --update alpine-sdk && \
    pip install -r /home/altais/requirements.txt && \
    apk add curl

COPY python-app/* home/altais/

WORKDIR /home/altais

#start application
CMD ["flask", "run", "--host", "0.0.0.0"]
