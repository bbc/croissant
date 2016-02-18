Release Dashboard
============
This is a release/testing dashboard for running Wraith, Acceptance-tests and viewing RPMS.  

## Requirements
Install Redis for storing worker jobs in queue
```
brew install reddis
```

Install Ruby dependencies
```
bundle install
```

## Certs
Add cert paths to httpee.rb

## Start services
Three are required, redis for storing the jobs, sidekiq for queue the jobs and sinatra.

```
redis-server
sidekiq -r./app/models/worker.rb
bundle exec thin start
```
