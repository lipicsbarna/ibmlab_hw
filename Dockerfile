FROM mariadb:latest

RUN mkdir /data
cd /data
RUN apt-get update
RUN apt-get install git python3.9
RUN cd
RUN git clone 
RUN /usr/bin/python -m pip install pandas
RUN /usr/bin/python -m pip install sqlalchemy
RUN /usr/bin/python -m pip install mariadb
RUN /usr/bin/python -m pip install streamlit
RUN chmod +x /data/init_db.sh
RUN /data/init_db.sh
CMD /usr/bin/python -m streamlit run /data/ufo_mariadb.py





