# ibmlab_hw
This is a Streamlit application for getting the query plans for indexed table to see if they use indices.

I could've written a bash script for this stuff, but didn't know what operating system will be used to run,

and didn't have time to write a multiplatform one, sorry.
So please, if you have docker installed, run these commands.


docker pull mariadb


docker run -i -p 127.0.0.1:3501:3501 --name ufos -e MARIADB_ROOT_PASSWORD=my-secret-pw -d mariadb bash


docker exec -it ufos bash -c "apt-get update;apt-get install -y git;cd /;git clone https://github.com/lipicsbarna/ibmlab_hw;mv /ibmlab_hw /data;chmod+x /data/init_db.sh;"

git clone https://github.com/lipicsbarna/ibmlab_hw

docker build -t ufo $PATH_TO_REPO

docker run ufo -p 8501:8501

In a browser, type:
http://localhost:8501/

Enjoy (or not)
