## Schedule Gardener
[![Code Climate](https://codeclimate.com/github/BCS-io/schedule_gardener.png)](https://codeclimate.com/github/BCS-io/schedule_gardener)
[![Build Status](https://travis-ci.org/BCS-io/schedule_gardener.png)](https://travis-ci.org/BCS-io/schedule_gardener)
[![Dependency Status](https://gemnasium.com/BCS-io/schedule_gardener.png)](https://gemnasium.com/BCS-io/schedule_gardener)

Application for scheduling a gardener to come to a premise and garden.


### Kickstart Project in:

#### Development:

1. git clone
2. rename config/database.example.yml -> config/database.yml
3. rename config/application.example.yml -> config/application.yml
4. rake db:create
5. Download dump from google drive: code/apps/schedule_gardener/schedule_gardener_development.dump
6. Restore database: 

   ````
   pg_restore --verbose --clean --no-acl --no-owner -d schedule_gardener_development --role richard  -U postgres schedule_gardener_development.dump
   ````

#### Production:

1. `cap deploy:setup` (requires postgresql password)
2. `cap deploy`
3. (if dev is up to date) cap postgresql:pdrestore
