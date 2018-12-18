FROM alpine
RUN apk add salt-master salt-minion git salt py3-psycopg2 && \
    mkdir /provision && \
    /usr/bin/pip3 install python-consul psycopg2 urllib3
COPY saltdb.sql /provision/saltdb.sql
COPY entrypoint.py /provision/entrypoint.py
RUN chmod +x /provision/entrypoint.py
