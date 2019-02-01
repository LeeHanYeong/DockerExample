FROM        python:3.7.2-slim
ENV         LANG    C.UTF-8

COPY        requirements.txt    /tmp/requirements.txt
RUN         pip install -r /tmp/requirements.txt

COPY        .   /root/example
WORKDIR     /root/example/app

CMD         python manage.py runserver 0:80
EXPOSE      80
