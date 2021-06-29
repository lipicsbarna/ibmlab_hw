FROM mariadb:latest

RUN cd / &&\
	apt-get update &&\
	apt-get install -y git python3 &&\
	git clone https://github.com/lipicsbarna/ibmlab_hw &&\
	mv ./ibmlab_hw ./data &&\
	chmod +x /data/init_db.sh

ENV MARIADB_ROOT_PASSWORD=my-secret-pw

CMD ["mysqld"]
CMD ["/data/init_db.sh"]
CMD ["usr/bin/python3","streamlit", "run", "/data/ufo_mariadb.py"]
