Sinatra App using [Faye](http://faye.jcoglan.com/ruby.html) - BBC News Hack 2016
=========================

## Run locally

```sh
bundle install

bundle exec rackup -s thin -E production
```

#### Dynamo Setup

Create a table called `hack_day`, fields that are created on POST

```sh
"QuestionID"
"endTime"
"questionText"
"startTime"
"no"
"yes"
```

POST data to the `/questions` endpoint with the following JSON structure

```json
{
	"questionText": "Did you vote in the last election",
	"startTime": "2016-02-19T12:42:57.713Z",
	"endTime": "2016-02-19T12:47:57.713Z"
}
```

#### Routes:

- Client - http://localhost:9292
- Questions - http://localhost:9292/questions
- Question - http://localhost:9292/questions/:id
- Results - http://localhost:9292/results
- Result - http://localhost:9292/results/:id


### Credits:

[David Blooman](https://twitter.com/dblooman)  
[Mark McDonnell](https://twitter.com/integralist)  
[Alex Norton](https://twitter.com/alxnorton)

> Note: this was completed as part of a hack day, so please don't judge us on the quality (or lack-thereof) of our code
