FROM mariadb:latest

RUN cd /
RUN apt-get update
RUN apt-get install -y git libmariadb3 libmariadb-dev python3 pip
RUN git clone https://github.com/lipicsbarna/ibmlab_hw
RUN mv ./ibmlab_hw ./data
RUN /usr/bin/python3 -m pip install pandas
RUN /usr/bin/python3 -m pip install sqlalchemy
RUN /usr/bin/python3 -m pip install mariadb
RUN /usr/bin/python3 -m pip install streamlit
RUN chmod +x /data/init_db.sh
RUN /data/init_db.sh
CMD /usr/bin/python3 -m streamlit run /data/ufo_mariadb.py





