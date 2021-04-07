FROM ubuntu:bionic
# Install Flask app dependencies.
RUN apt-get update
RUN apt-get install -y libmysqlclient-dev build-essential python-dev python-pip
RUN pip install flask flask-sqlalchemy mysql-python
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_DEBUG True
WORKDIR /var/www
COPY src /var/www
EXPOSE 5000
ENTRYPOINT ["flask", "run"]
