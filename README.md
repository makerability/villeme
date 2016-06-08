![alt tag](http://i.imgur.com/V7T6r88.jpg)

# Villeme [![Build Status](https://snap-ci.com/jonatassalgado/villeme/branch/master/build_image)](https://snap-ci.com/jonatassalgado/villeme/branch/master) [![Code Climate](https://codeclimate.com/github/makerability/villeme/badges/gpa.svg)](https://codeclimate.com/github/makerability/villeme) [![Coverage Status](https://img.shields.io/coveralls/jonatassalgado/villeme.svg)](https://coveralls.io/r/jonatassalgado/villeme?branch=master)

The easiest way to find events, activities and services in your city.

## Getting started

##### Dependencies

[Git](http://git-scm.com/)
[Ruby](https://www.ruby-lang.org) 2.2.3 with Rbenv ([Ubuntu](http://goo.gl/GV3jz9)/[Mac](http://goo.gl/iopwFk))
Rails 4.2.6 ([Ubuntu](http://goo.gl/85rKbk)/[Mac](http://goo.gl/Zq6Rgv))

##### Setup the project

1. Clone the project: `$ git clone https://github.com/jonatassalgado/villeme.git`
2. Enter project folder: `$ cd villeme`
3. Install imagemagick for Ubuntu: `sudo apt-get install imagemagick`
4. Install postgreSQL packages : `$ sudo apt-get install libpq-dev`
5. Install Gems: `$ bundle install`
6. Install Npm modules: `$ sudo npm install`
7. Compile assets (js, css, images): `$ bundle exec rake assets:precompile`
8. Create the database: `$ bundle exec rake db:schema:load`
9. Create faker data with seed: `$ bundle exec rake db:seed`
10. If everything goes OK, you can now run the project `$ rails server` and open [http://localhost:3000/sign_in](http://localhost:3000/sign_in)
11. Login as admin with email: `admin@gmail.com` and pass: `password`

###### If some errors occur in setup, try:

https://github.com/jonatassalgado/villeme/wiki/Erros-can-occur-in-setup

## Collaborate

Villeme is a "open startup", where anyone can contribute.

#### Current tasks

Open https://github.com/jonatassalgado/villeme/issuesWe or use Zenhub. For see our tasks in a Kanban [just add Zenhub extension for your browser](https://www.zenhub.com/) and after come to this repository.

#### Submitting a Feature

Open https://github.com/jonatassalgado/villeme/wiki/Submitting-a-Feature


###### How to start to colaborate

https://github.com/jonatassalgado/villeme/wiki/Start-to-Colaborate

###### Style Guide

Go to [frontify.com/villeme-style-guide](https://app.frontify.com/d/sirfXbGEnYuj/villeme-style-guide). If you want to edit, request access (the tool accept only people in team can edit).

## Team

Founder: [Jonatas Eduardo (John)](https://www.facebook.com/jonataseduardo/) from Brazil.


## License

Copyright (C) 2014  Jonatas Eduardo Vedoi Salgado

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

Read more on: [makerability/villeme/LICENSE](https://github.com/makerability/villeme/blob/master/LICENSE)
