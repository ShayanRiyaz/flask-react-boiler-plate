#!/bin/sh
COUNT=$(ls | wc -l)
LIMIT=5
if [[ $COUNT > $LIMIT ]];
then 
    echo "We found $COUNT files/folders in this directory which is $((COUNT-LIMIT)) more than the files recommended by default"
    echo "(The default file are the shell scripts)"
    echo "This might raise errors or cause some features to not function."
    read -p "Are you sure you want to proceed? [Y/n]: "  proceed
    if [ $proceed = "y" -o $proceed = "Y" ];
    then 
        :
    elif [ $proceed = "n" -o $proceed = "N" ];
    then 
        return
    fi
else
    :
fi

if [ -d .git ]; then
  echo .git;
else
  git init ;
fi;

if [ ! -f .gitignore ]; then
    touch .gitignore
    echo venv >> .gitignore
    echo node_modules >> .gitignore

    echo __pycache__ >> .gitignore
fi


if [ ! -d "backend" ];
then
    echo ------------------------------
    echo Setting up Backend
    echo ------------------------------
    mkdir backend
    
    
fi

cd backend

if [ ! -d "venv" ];
then
    echo ------------------------------
    echo Setting up Virtual Environment
    echo ------------------------------
    python -m venv venv
fi

source venv/bin/activate



if [ ! -f "requirements.txt" ];
then
    echo ------------------------------
    echo Making Requirements.txt file
    echo ------------------------------
    pip install flask
    pip install python-dotenv
    pip freeze > requirements.txt

elif [ -f "requirements.txt" ];
then 
    echo ------------------------------
    echo Installing Requirements
    echo ------------------------------
    pip install -r requirements.txt
fi

if [ ! -d "static" ];
then
    mkdir static
fi

if [ ! -d "templates" ];
then
    mkdir templates
    echo -e '<!doctype html>
    <html lang="en">
    <head>
    <meta charset="utf-8"/>
    <link rel="icon" href="/static/react/favicon.ico"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <meta name="theme-color" content="#000000"/>
    <meta name="description" content="Web site created using create-react-app"/>
    <link rel="apple-touch-icon" href="logo192.png"/>
    <link rel="manifest" href="/static/react/manifest.json"/>
    <title>React App</title><script>window.token="{{flask_token}}"</script>
    <link href="/static/react/css/main.b100e6da.chunk.css" rel="stylesheet">
    </head>
    <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">
    </div>
    <script>!function(l){function e(e){for(var t,r,n=e[0],o=e[1],u=e[2],a=0,p=[];a<n.length;a++)r=n[a],Object.prototype.hasOwnProperty.call(i,r)&&i[r]&&p.push(i[r][0]),i[r]=0;for(t in o)Object.prototype.hasOwnProperty.call(o,t)&&(l[t]=o[t]);for(s&&s(e);p.length;)p.shift()();return f.push.apply(f,u||[]),c()}function c(){for(var e,t=0;t<f.length;t++){for(var r=f[t],n=!0,o=1;o<r.length;o++){var u=r[o];0!==i[u]&&(n=!1)}n&&(f.splice(t--,1),e=a(a.s=r[0]))}return e}var r={},i={1:0},f=[];function a(e){if(r[e])return r[e].exports;var t=r[e]={i:e,l:!1,exports:{}};return l[e].call(t.exports,t,t.exports,a),t.l=!0,t.exports}a.m=l,a.c=r,a.d=function(e,t,r){a.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:r})},a.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},a.t=function(t,e){if(1&e&&(t=a(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var r=Object.create(null);if(a.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var n in t)a.d(r,n,function(e){return t[e]}.bind(null,n));return r},a.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return a.d(t,"a",t),t},a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},a.p="/static/react/";var t=this["webpackJsonpreact-app"]=this["webpackJsonpreact-app"]||[],n=t.push.bind(t);t.push=e,t=t.slice();for(var o=0;o<t.length;o++)e(t[o]);var s=n;c()}([])</script>
    <script src="/static/react/js/2.35541147.chunk.js"></script>
    <script src="/static/react/js/main.6d83365a.chunk.js"></script>
    </body>
    </html>' > templates/index.html
fi
if [ ! -f .env ];
then
    touch .env
    echo .env >> ../.gitignore
    echo -e "SECRET_KEY='secret-key'" >> .env
    echo -e "FLASK_APP=backend" >> .env
    echo -e "FLASK_ENV=development" >> .env
fi



if [ ! -f "__init__.py" ];
then
    touch __init__.py
fi

if [ ! -f "config.py" ];
then
    echo -e "from os import environ, path
from dotenv import load_dotenv\n
basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, '.env'))\n\n
class Config:
\t'''Set Flask Configuration from .env files. '''\n
\t#General Config
\tSECRET_KEY=environ.get('SECRET_KEY')
\tFLASK_APP = environ.get('FLASK_APP')
\tFLASK_ENV = environ.get('FLASK_ENV')\n\n" > config.py
fi

if [ ! -f "app.py" ];
then
    echo -e "from flask import Flask, render_template\n
def create_app():
\t'''Construct the core application.'''
\tapp = Flask(__name__)\n
\tapp.config.from_object('config.Config')\n
\treturn app\n\n" >app.py

fi

if [ ! -f "routes.py" ];
then 
    echo ----- Making Routes ------
    echo -e "from flask import current_app as app
from flask import make_response, redirect,render_template,request,url_for
\n@app.route('/')
def my_index():
\treturn render_template('index.html', flask_token='Hello   world')" > routes.py

    lineNum="$(grep -n "app.config.from_object" app.py | head -n 1 | cut -d: -f1)"
    sed -i "${lineNum}a \\\twith app.app_context():\n\t    import routes" app.py
fi


if [ ! -f "wsgi.py" ];
then 
    echo -e 'from app import create_app\n

\nif __name__ == "__main__":
\tapp = create_app()
\tapp.run(host="0.0.0.0",port=5000)' > wsgi.py
fi

cd ..
if [ ! -d "frontend" ];
then 
    echo ---------------------
    echo Setting up Frontend
    echo ---------------------
    echo --------------------------------
    echo Install React using Yarn
    echo --------------------------------
    yarn global add create-react-app react-scripts
    npx create-react-app frontend
    

fi

git add .
git commit -m "Added Front and Back"
cd frontend
npm run eject 
rm -rf node_modules
rm yarn.lock
yarn install
echo ------------------------------------------------
echo Connecting React to Flask
echo ------------------------------------------------
sed -i "s|appBuild: resolveApp('build'),|appBuild: resolveApp('../backend/static/react'),|g" config/paths.js
sed -i 's:static/::g' config/webpack.config.js
sed -i '563i    filename: "../../templates/index.html", //added line' config/webpack.config.js
sed -i '28i     <script> window.token="{{flask_token}}"</script>' public/index.html
sed -i '12i     <p>My Token = {window.token}</p>' src/App.js
sed -i '4i      "homepage": "/static/react",' package.json


yarn build



cd ..

