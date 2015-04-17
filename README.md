## Schedule Gardener
[![Code Climate](https://codeclimate.com/github/BCS-io/schedule_gardener.png)](https://codeclimate.com/github/BCS-io/schedule_gardener)
[![Build Status](https://travis-ci.org/BCS-io/schedule_gardener.png)](https://travis-ci.org/BCS-io/schedule_gardener)
[![Coverage Status](https://coveralls.io/repos/BCS-io/schedule_gardener/badge.png)](https://coveralls.io/r/BCS-io/schedule_gardener)
[![Dependency Status](https://gemnasium.com/BCS-io/schedule_gardener.png)](https://gemnasium.com/BCS-io/schedule_gardener)

Application for scheduling a gardener to come to a premise and garden.


## Application Setup

### 1. Development:

1. git clone
2. rename config/database.example.yml -> config/database.yml
3. rename config/application.example.yml -> config/application.yml
4. rake db:create
5. Download dump from google drive: code/apps/schedule_gardener/schedule_gardener_development.dump
6. Restore database: 

   ````
   pg_restore --verbose --clean --no-acl --no-owner -d schedule_gardener_development --role richard  -U postgres schedule_gardener_development.dump
   ````

### 2. Production:

#### Code Setup
1. `cap <environment> setup`
2. `cap <environment> deploy`

#### Database Setup
3. `cap production db:push`
