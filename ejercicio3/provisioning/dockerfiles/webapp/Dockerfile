FROM ubuntu:focal
RUN apt-get update \
	&& apt-get install -y libmysqlclient-dev python3-pip python3-dev \
	&& pip3 install flask flask-sqlalchemy mysqlclient \
	&& apt-get --purge autoremove \
	&& apt-get autoclean \
	&& apt-get clean
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_DEBUG True
WORKDIR /var/www
COPY src /var/www
EXPOSE 5000
ENTRYPOINT ["flask", "run"]
