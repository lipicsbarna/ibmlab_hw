#!/bin/bash

apt-get install -y python3 pip
pip install pandas sqlalchemy streamlit


echo "create database ufo" | mariadb --user=root --password=my-secret-pw
echo "Created database named ufo."

sql="
use ufo;
create table ext_ufos (
    date_time text null,
    city text null,
    state text null,
    country text null,
    shape text null,
    duration_sec bigint null,
    duration_str text null,
    comments text null,
    date_posted text null,
    latitude text null,
    longitude text null
)
"
echo ${sql} | mariadb --user=root --password=my-secret-pw
echo "Created table."

sql="
use ufo;
load data infile '/data/ufo/scrubbed.csv' ignore
into table ext_ufos
fields terminated BY ','
lines terminated BY '\n'
ignore 1 lines
"
echo ${sql} | mariadb --user=root --password=my-secret-pw
echo "Loaded data to ext_table"

sql="
 CREATE TABLE ufos (
  date_time datetime DEFAULT NULL,
  city text DEFAULT NULL,
  state text DEFAULT NULL,
  country varchar(2) DEFAULT NULL,
  shape varchar(9) DEFAULT NULL,
  duration_sec bigint(20) DEFAULT NULL,
  duration_str text DEFAULT NULL,
  comments text DEFAULT NULL,
  date_posted text DEFAULT NULL,
  latitude text DEFAULT NULL,
  longitude text DEFAULT NULL,
  KEY shape_country_idx (shape,country),
  KEY shape_country_date_idx (shape,country,date_time),
  KEY shape_idx (shape),
  KEY country_idx (country),
  KEY date_time_idx (date_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
"
echo ${sql} | mariadb --user=root --password=my-secret-pw
echo "Created ufo table"

sql="
 use ufo;
 insert into ufos2 (
  date_time,
  city,
  state,
  country,
  shape,
  duration_sec,
  duration_str,
  comments,
  date_posted,
  latitude,
  longitude
  )
 select 
    str_to_date(
        replace(date_time, '24:', '00:'), 
        '%m/%d/%Y %H:%i') date_time,
    city,
    state,
    cast(country as varchar(2)) country,
    cast(shape as varchar(9)) shape,
  duration_sec,
  duration_str,
  comments,
  date_posted,
  latitude,
  longitude
  ;
"
echo ${sql} | mariadb --user=root --password=my-secret-pw
echo "Table is ready"

/usr/bin/python3 -m streamlit run /data/ufo_mariadb.py