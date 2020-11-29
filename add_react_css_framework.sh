#!/bin/sh

while [ ! $# -eq 0 ];
do
    case "$1" in
        --help | -h)
            echo "$package - Use this shell program to add custom framworks such as boostrap"
            echo " "
            echo "$package [options] applications [arguments]"
            echo " "
            echo "options:"
            echo "-h, --help                show brief help"
            echo "-a, --add=FRAMEWORK       specity the framework to add"
            echo "Currently this program only supports bootstrap integration."
            echo "You can run add the arguments -a bootstrap or --add boostrap"
            return
            ;;
        --add | -a)
            if [ "$2" == "bootstrap" ];
            then
                echo ------------------------
                echo  ADDING REACT-BOOTSTRAP
                echo ------------------------
                if [ -d "frontend" ];
                then
                    cd frontend
                else
                    echo "You don't have a have a folder names frontend, please set one up with react"
                    return
                fi
                yarn add react-bootstrap bootstrap jquery
                lineNum="$(grep -n "<link rel="\""icon"\"" href="\""%PUBLIC_URL%/favicon.ico"\"" />" public/index.html | head -n 1 | cut -d: -f1)"
                sed -i "${lineNum}a     <link rel='stylesheet'\nhref='https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css'\nintegrity='sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk'\ncrossorigin='anonymous'/>" public/index.html
                
                lineNum="$(grep -n "<title>React App</title>" public/index.html | head -n 1 | cut -d: -f1)"
                sed -i "${lineNum}a     <script src='https://unpkg.com/react/umd/react.production.min.js' crossorigin></script>\n<script\nsrc='https://unpkg.com/react-dom/umd/react-dom.production.min.js'crossorigin></script>\n<script\nsrc='https://unpkg.com/react-bootstrap@next/dist/react-bootstrap.min.js'\ncrossorigin></script>\n<script>var Alert = ReactBootstrap.Alert;</script>" public/index.html
                
                lineNum="$(grep -n "import './App.css';" src/App.js | head -n 1 | cut -d: -f1)"
                sed -i "${lineNum}a import { Nav, Navbar, NavDropdown, Button, FormControl, Form } from 'react-bootstrap';\nimport 'bootstrap/dist/css/bootstrap.min.css';" src/App.js

                lineNum="$(grep -n "<div className="\""App"\"">" src/App.js | head -n 1 | cut -d: -f1)"
                sed -i "${lineNum}a <Navbar bg='light' expand='lg'>\n\t\t<Navbar.Brand href='#home'>React-Bootstrap</Navbar.Brand>\n\t\t<Navbar.Toggle aria-controls='basic-navbar-nav' />\n\t\t<Navbar.Collapse id='basic-navbar-nav'>n\t\t<Nav className='mr-auto'>\n\t\t<Nav.Link href='#home'>Home</Nav.Link>\n\t\t<Nav.Link href='#link'>Link</Nav.Link>\n\t\t<NavDropdown title='Dropdown' id='basic-nav-dropdown'>\n\t\t<NavDropdown.Item href='#action/3.1'>Action</NavDropdown.Item>\n\t\t<NavDropdown.Item href='#action/3.2'>Another action</NavDropdown.Item>\n\t\t<NavDropdown.Item href='#action/3.3'>Something</NavDropdown.Item>\n\t\t<NavDropdown.Divider />\n\t\t<NavDropdown.Item href='#action/3.4'>Separated link</NavDropdown.Item>\n\t\t</NavDropdown>\n\t\t</Nav>\n\t\t<Form inline>\n\t\t<FormControl type='text' placeholder='Search' className='mr-sm-2' />\n\t\t<Button variant='outline-success'>Search</Button>\n\t\t</Form>\n\t\t</Navbar.Collapse>\n\t\t</Navbar>" src/App.js
                yarn build
                cd ..
                return
            else
                echo "no process specified"
                return
            fi
            ;;
    esac
    shift
done