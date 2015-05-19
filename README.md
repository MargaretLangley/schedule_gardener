## Schedule Gardener
[![Code Climate](https://codeclimate.com/github/BCS-io/schedule_gardener.png)](https://codeclimate.com/github/BCS-io/schedule_gardener)
[![Build Status](https://travis-ci.org/BCS-io/schedule_gardener.png)](https://travis-ci.org/BCS-io/schedule_gardener)
[![Coverage Status](https://coveralls.io/repos/BCS-io/schedule_gardener/badge.svg?branch=master)](https://coveralls.io/r/BCS-io/schedule_gardener?branch=master)
[![Dependency Status](https://gemnasium.com/BCS-io/schedule_gardener.png)](https://gemnasium.com/BCS-io/schedule_gardener)

Application for scheduling a gardener to come to a premise and garden.


## 1. Development environment:

1. `git clone git@github.com:BCS-io/schedule_gardener.git  && cd schedule_gardener`
2. Install sql-lite if not present
  * `sudo apt-get install libsqlite3-dev`
3. `cp config/secrets.example.yml  config/secrets.yml`
  * update production variables
4. `rake db:create && rake db:migrate`
5. Add schedule gardener csv data to `import_data`

  1\. `git clone git@bitbucket.org:bcsltd/schedule_gardener_import_data.git import_data`
  2\. `rake import`
6. `rails s`
7. Navigate browser to localhost:3000

## 2. Deployment:

### Code Setup
1. `cap <environment> setup`
2. `cap <environment> deploy`

### Database Setup
3. `cap <environment> db:push`

## 3. Test:

Requires mailcatcher to be running:
`mailcatcher &`