#!/bin/sh

source backend/venv/bin/activate

if [[ $# -eq 0 ]] ; then
    echo 'You must enter an argument. Please enter either NoSQL or MySQL'
    return
fi

db=$1 

if [[ ( "$db" == "NoSQL" ) || ( "$db" == "MySQL" ) ]];
then
    :
else
    echo 'Incorrect Input, Please enter either NoSQL or MySQL.'
    return
fi

if [ "$db" == "NoSQL" ];
then
    echo ----------------------------
    echo Setting up mongodb[Flask MongoEngine]
    echo ----------------------------
    pip install flask-mongoengine
    pip freeze > backend/requirements.txt
    if [ ! -d "backend/database" ];
    then
        echo --------------------------------------
        echo ----- Setting up Database folder -----
        echo --------------------------------------
        mkdir backend/database
        echo -e '# backend/database/db.py\n\n
from flask_mongoengine import MongoEngine\n
db = MongoEngine()\n
def initialize_db(app):
\tdb.init_app(app)' > backend/database/db.py

        echo -------------------------------------
        echo -------- CREATING USER MODEL --------
        echo -------------------------------------
        echo -e 'from flask_mongoengine.wtf import model_form
from .db import db
import mongoengine_goodjson as gj # To get a clean json id tag instead of MongoDB style.\n\n
class User(db.Document):
\temail = db.StringField(required=True)
\tfirst_name = db.StringField(max_length=50)
\tlast_name = db.StringField(max_length=50)\n\n' > backend/database/models.py
        echo --------------------------------------
        echo --- Database Folder setup-complete ---
        echo --------------------------------------
    
    
    echo -------------------------------------
    echo ------- Modifying Config file -------
    echo -------------------------------------
    sed -i '16a \\tMONGODB_DB = environ.get("MONGODB_DB")\n\tMONGODB_HOST = environ.get("MONGODB_HOST")\n\tMONGODB_PORT = environ.get("MONGODB_PORT")\n\tMONGODB_USERNAME = environ.get("MONGODB_USERNAME")\n\tMONGODB_HOST = environ.get("MONGODB_PASSWORD")' backend/config.py
    echo -------------------------------------
    echo ------- Config file Modified --------
    echo -------------------------------------
    
    
    sed -i '2a from database.db import initialize_db\n' backend/app.py
    lineNum="$(grep -n "app = Flask(__name__)" backend/app.py | head -n 1 | cut -d: -f1)"
    sed -i "${lineNum}a     \\\tinitialize_db(app)" backend/app.py
    echo --------------------------------------
    echo -------- app.py modified -------------
    echo --------------------------------------

    echo --------------------------------------
    echo ------ modifiying .env file ----------
    echo --------------------------------------
    echo -e "MONGODB_DB='project1'" >> backend/.env
    echo -e "MONGODB_HOST='192.168.1.35'" >> backend/.env
    echo -e "MONGODB_PORT=12345" >> backend/.env
    echo -e "MONGODB_USERNAME='webapp'" >> backend/.env
    echo -e "MONGODB_PASSWORD='pwd123'" >> backend/.env

    fi

elif [ "$db" == "MySQL" ];
then
    echo ----------------------------
    echo Setting up SQL[SQL-Alchemy]
    echo ----------------------------
    pip install pymysql
    pip freeze > backend/requirements.txt
    if [ ! -d "backend/database" ];
    then
        echo --------------------------------------
        echo ----- Setting up Database folder------
        echo --------------------------------------
        mkdir backend/database
        echo -e '# backend/database/db.py\n\n
from flask_sqlalchemy import SQLAlchemy\n
db = SQLAlchemy()\n
def initialize_db(app):
\tdb.init_app(app)' > backend/database/db.py
        echo -------------------------------------
        echo -------- CREATING USER MODEL --------
        echo -------------------------------------
        echo -e 'from marshmallow_sqlalchemy import ModelSchema
from marshmallow import fields
from . import db\n\n
class User(db.Model):
\t__tablename__ = "users"
\temail = db.Column(db.String(120), primary_key=True)
\tfirst_name = db.Column(db.String(50), unique=True)
\tlast_name = db.Column(db.String(50), unique=True)\n\n
\tdef __repr__ (self):
\t\treturn "<User {}>".format(self.username)' > backend/database/models.py
        echo --------------------------------------
        echo --- Database Folder setup-complete ---
        echo --------------------------------------

    echo -------------------------------------
    echo ------- Modifying Config file -------
    echo -------------------------------------
    sed -i '16a \\tSQLALCHEMY_DATABASE_URI = environ.get("SQLALCHEMY_DATABASE_URI")\n\tSQLALCHEMY_TRACK_MODIFICATIONS = environ.get("SQLALCHEMY_TRACK_MODIFICATIONS")' backend/config.py
    echo -------------------------------------
    echo ------- Config file Modified --------
    echo -------------------------------------
    

    echo --------------------------------------
    echo -------- modifying app.py ------------
    echo --------------------------------------
    sed -i '2a \t from database.db import initialize_db\n' backend/app.py
    lineNum="$(grep -n "app.config.from_object" backend/app.py | head -n 1 | cut -d: -f1)"
    sed -i "${lineNum}a     \\\tinitialize_db(app)" backend/app.py
    lineNum=$((lineNum+=1))
    sed -i "${lineNum}a   \\\twith app.app_context():\n\tdb.create_all()" backend/app.py
    echo --------------------------------------
    echo -------- app.py modified -------------
    echo --------------------------------------


    echo --------------------------------------
    echo ------ modifiying .env file ----------
    echo --------------------------------------
        echo -e "SQLALCHEMY_DATABASE_URI='mysql://webapp:pwd123@192.168.1.35:12345/project1'" >> backend/.env

    fi

fi


