FROM mariadb:latest

RUN cd / &&\
	apt-get update &&\
	apt-get install -y git libmariadb3 libmariadb-dev python3 pip &&\
	git clone https://github.com/lipicsbarna/ibmlab_hw &&\
	mv ./ibmlab_hw ./data &&\
	/usr/bin/python3 -m pip install pandas &&\
	/usr/bin/python3 -m pip install sqlalchemy &&\
	/usr/bin/python3 -m pip install mariadb &&\
	/usr/bin/python3 -m pip install streamlit &&\ 
	/usr/local/bin/docker-entrypoint.sh &&\ 
	chmod +x /data/init_db.sh &&\ 
	/data/init_db.sh
CMD /usr/bin/python3 -m streamlit run /data/ufo_mariadb.py
