#!/usr/bin/python3
import os
import sys
import urllib3
import psycopg2
import subprocess
from time import sleep
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT 

def provision_tables():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        print('Provisioning salt database...')
        conn = psycopg2.connect(host="timescale",database="salt", user="salt", password="salt")
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)

        with open('/provision/saltdb.sql') as f:
            read_data = f.read()
            f.closed

        cur = conn.cursor()
        
        cur.execute(read_data)
 
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')

def check_database_state():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(host="timescale",database="salt", user="salt", password="salt")

        cur = conn.cursor()
        #we check the last table create before runing migration
        cur.execute("""select to_regclass('salt_events');""")
        rows = cur.fetchall()
        print (rows[0][0])

        if rows[0][0] == None:
            return True

        return False
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.') 

def run_checks():
    http = urllib3.PoolManager()
    elastcActive = False
    pgActive = False

    while True:
        try:
            request = http.request('GET','http://elasticsearch:9200')        
        except (Exception, urllib3.exceptions.MaxRetryError):
            print ("waiting for elasticsarch to become active")
            sleep(5)
            continue
        else:
            print("Service elastic search is now runnign")
            elastcActive = True
            break

    while True:
        try:
            conn = psycopg2.connect(host="timescale",database="salt", user="salt", password="salt")
        except:
            print ("waiting for postgres to become active")
            sleep(5)
            continue
        else:
            print ("service motherdb is now running")
            if conn is not None:
                conn.close()
                print('Database connection closed.')
            pgActive = True
            break

    if pgActive == elastcActive:
        return True
    return
 
if __name__ == '__main__':
    if run_checks() == True:
        if check_database_state() == True:
            provision_tables()
    if  os.environ['SALT_MASTER'] == True:
        process = subprocess.Popen(["salt-master"], stdout=subprocess.PIPE)
        for line in process.stdout:
            sys.stdout.write(line.decode("utf-8"))
    else:
        process = subprocess.Popen(["salt-minion"], stdout=subprocess.PIPE)
        for line in process.stdout:
            sys.stdout.write(line.decode("utf-8"))