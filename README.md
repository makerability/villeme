![alt tag](http://i.imgur.com/V7T6r88.jpg)

# Villeme

[villeme.com](http://www.villeme.com) | The easiest way to find events, activities and services in your city.

The official repo is https://github.com/makerability/villeme

## Status

[![Build Status](https://snap-ci.com/jonatassalgado/villeme/branch/master/build_image)](https://snap-ci.com/jonatassalgado/villeme/branch/master) [![Circle CI](https://circleci.com/gh/jonatassalgado/villeme/tree/master.svg?style=svg)](https://circleci.com/gh/jonatassalgado/villeme/tree/master) [![Code Climate](https://codeclimate.com/github/makerability/villeme/badges/gpa.svg)](https://codeclimate.com/github/makerability/villeme) [![Coverage Status](https://img.shields.io/coveralls/jonatassalgado/villeme.svg)](https://coveralls.io/r/jonatassalgado/villeme?branch=master) 

## Dependencies

To run app in **development** you need to have:

* [Git](http://git-scm.com/)
* [Ruby](https://www.ruby-lang.org) 2.2.3 with Rbenv ([Ubuntu](http://goo.gl/GV3jz9)/[Mac](http://goo.gl/iopwFk))
* Rails 4.0.3 ([Ubuntu](http://goo.gl/85rKbk)/[Mac](http://goo.gl/Zq6Rgv))

To run app **test** locale you need to have (not necessary, but recommended):

* [Poltergeist](https://github.com/teampoltergeist/poltergeist) with [PhantomJS](http://goo.gl/3DpHeO)


## Getting started

#### Setup the project

1. Clone the project: `$ git clone https://github.com/makerability/villeme.git`
2. Enter project folder: `$ cd villeme`
3. Install the gems (dependencies): `$ bundle install`
4. Compile assets (js, css, images): `$ bundle exec rake assets:precompile`
5. Create the database: `$ bundle exec rake db:schema:load`
7. Install imagemagick for Ubuntu: `sudo apt-get install imagemagick`
6. Create faker data with seed: `$ bundle exec rake db:seed`

If everything goes OK, you can now run the project!


#### Running the project

	$ rails server

Open [http://localhost:3000](http://localhost:3000)

* Login as admin

    Go to [http://localhost:3000/sign_in](http://localhost:3000/sign_in)

* Complete the form with

    **email:** admin@gmail.com

    **password:** password

#### If some errors occur try:

* [Installing PG gem - failure to build native extension](http://stackoverflow.com/questions/19262312/installing-pg-gem-failure-to-build-native-extension/19620569#19620569)
* [No bundle shim; rbenv: bundle: command not found](https://github.com/sstephenson/rbenv/issues/576#issuecomment-50113969)
* ExecJS::RuntimeUnavailable: Could not find a JavaScript runtime
	* [Solution A](http://stackoverflow.com/questions/11598655/therubyracer-install-error)
	* [Solution B - Ubuntu](http://stackoverflow.com/questions/6282307/execjs-and-could-not-find-a-javascript-runtime)



## Community of makers

This is a product being built by the Assembly community. You can help push this idea forward by visiting [assembly.com/villeme](https://assembly.com/villeme).


## Collaborate

Villeme is a "open startup", where anyone can contribute.

#### The plan - If you are a marketing guy ;)

Go to: [assembly.com/villeme](https://assembly.com/villeme)

#### Current tasks - If you are a programmer ;)

User Mapping -> Go to [villeme.storiesonboard.com](https://villeme.storiesonboard.com/m/villeme) and see the tasks and histories context.

Kanban       -> Go to [trello.com/villeme-tasks](https://trello.com/b/DNjA2KLc/villeme-tasks) and see the tasks to develop.

#### Style Guide - If you are a designer ;)

Go to [frontify.com/villeme-style-guide](https://app.frontify.com/d/sirfXbGEnYuj/villeme-style-guide). If you want to edit, request access (the tool accept only people in team can edit).

##### Tips

The best way to collaborate is to "Fork" repo on GitHub.
This will create a copy of the repo on your GitHub account.

Before you set out to improve the code, you should have a focused idea in mind of what you want to do.

Each commit should do one thing, and each PR should be one specific improvement.

#### Forking


	$ git clone



#### Editing and Testing


Ok, you're ready to start editing the code, right?
Not quite!
Before you start editing, you should create a *branch*.
A branch is like an alternate timeline.

You can read more about *git branch* [here](http://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell).

If you're trying to fix a bug, you might want to name the branch:

    fix-short-description

If you're adding a feature:

    feature-short-description

After you can execute checkout to go the branch
`git checkout -b branch-name`


As far as code style, just try to imitate the style of existing code.
Don't sweat over this too much.
If the maintainer doesn't like how your code looks, they'll suggest changes.

You can set of tests to make sure that the existing functionality of the code stays the same as you make changes.
This helps keep the software stable.


#### Committing and Pushing

`git commit -m "your commit message"`

**Using Your Change:** though it may not be obvious, you can begin using your code in your own projects immediately.


## Getting your Change into the Project

You made your change, tested it, committed it with `git commit`, and want to send it back to the project and have it included in a future version.

To do this on GitHub, you need to submit a "pull request" (PR).


#### Submitting a Pull Request

The golden rule of submitting PRs is to do things the way the project maintainers would want it done.

You can't read the minds of the project maintainers, but you can look at [assembly.com/villeme/bounties](https://assembly.com/villeme/bounties).


#### Submitting a Bug Report (or "Issue")

In GitHub, "Bug Reports" are called "Issues."

Project maintainers really appreciate thorough explanations.
It usually helps them address the problem more quickly, so everyone wins!


## Tech Stacks

* **Back-end:** Ruby / Rails / Postgresql
* **Front-end:** HTML5 / CSS / SASS / jQuery / Coffeescript / RiotJS
* **Tests:** RSpec / FactoryGirl / Faker / Poltergeist / PhantomJS
* **Technical:** SuitCSS / JavascriptOO / Clean Architecture in Rails way / DDD in Rails way / JSON
* **DevOps:** SnapCI / TravisCI / Codeclimate
* **Important Modules:** Devise / Gon / Paperclip / Merit / Geocoder



## Best practices

* **Style guide for Ruby:** https://github.com/bbatsov/ruby-style-guide
* **Style Guide for Coffeescriot:** [github.com/coffeescript-style-guide](https://github.com/polarmobile/coffeescript-style-guide)
* **Pattern for Javascript:** [thoughtbot.com/module-pattern](http://robots.thoughtbot.com/module-pattern-in-javascript-and-coffeescript)
* **Tests for Ruby in RSpec** (not obligatory if you don't know to do) for each scenario of the feature you are trying to implement.




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
