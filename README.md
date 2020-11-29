# flask-react-boiler-plate
A collection of shell files to make a flask/react boiler plate


## Steps

### 1. ```init.sh``` for basic flask-react boiler plate

You can simply run this file by running this following command in your terminal from the root directory:
- `. init.sh`
- When prompted to eject enter `y`.
- run `. run.sh` to run the backend
- Navigate to `localhost:5000`

The shell script sets up a base React and Flask application.
**Note**: In order for the script to run without an error make sure you have atleast the following version.
| Programs | Versions| Command to check | Command to upgrade | 
|---------|-|-|-|
|<img src="https://img.shields.io/badge/nodejs%20-%23323330.svg?&style=for-the-badge&logo=nodejs&logoColor=green"/> | `v15.2.1`|`node --version`| `nvm install [version.number]`|
|<img src="https://img.shields.io/badge/yarn%20-%2314354C.svg?&style=for-the-badge&logo=yarn&logoColor=blue"/>| `1.22.10` | `yarn --version` | `yarn upgrade --latest`|
|<img src="https://img.shields.io/badge/python%20-%2314354C.svg?&style=for-the-badge&logo=python&logoColor=blue"/>| `3.8.6` |`python --version`| 
|<img src="https://img.shields.io/badge/pip%20-%2314354C.svg?&style=for-the-badge&logo=pip&logoColor=blue"/>| `20.2.3`|`pip --version` | `pip install --upgrade pip` |

*The commands above are primarily for **Linux** users. I haven't set up CI Tests yet for versions before these, so not sure if it'll work with those setups or not.*

2. To add a css framework for the `ReactJS` frontend run:

```shell
. add_react_css_framework.sh -a bootstrap 
```
or

```shell
. add_react_css_framework.sh --add bootstrap 
```
Currently bootstrap is the only one available in the script.

3. To add a Database to our backend run:
```shell
. add_database.sh NoSQL 
``` 
for MongoEngine
or

```shell
. add_database.sh MySQL 
```
for MySQL Alchemy. This file will set up a basic user model and necessary mongodb configurations


4. Alternatively, you can run `. run_all.sh` to run all 4 scripts in a go.

