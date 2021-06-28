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
	chmod +x /data/init_db.sh &&\ 