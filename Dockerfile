FROM mariadb:latest

RUN cd /
RUN apt-get update
RUN apt-get install git python3.9
RUN git clone https://github.com/lipicsbarna/ibmlab_hw
RUN mv ./ibmlab_hw ./data
RUN /usr/bin/python -m pip install pandas
RUN /usr/bin/python -m pip install sqlalchemy
RUN /usr/bin/python -m pip install mariadb
RUN /usr/bin/python -m pip install streamlit
RUN chmod +x /data/init_db.sh
RUN /data/init_db.sh
CMD /usr/bin/python -m streamlit run /data/ufo_mariadb.py





