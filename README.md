Schedule Gardener

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/BCS-io/schedule_gardener)

Application for scheduling a gardener to come to a premise and garden.


Kickstart Project in:

Development:

1) git clone
2) rename config/database.example.yml -> config/database.yml
3) rake db:create
4) Download dump from google drive: code/schedule_gardener/schedule_gardener_development.dump
4) Restore database: pg_restore --verbose --clean --no-acl --no-owner -d schedule_gardener_development --role richard  -U postgres schedule_gardener_development.dump


Production:

1) cap deploy:setup (requires postgresql password)
2) cap deploy
3) (if dev is up to date) cap postgresql:pdrestore
