This project was developed using RubyOnRails framework.

Server is used to connect to a database (Postgres) and provide a thin API layer for persisting Remarks and search capabilities.

## Tech stack
Ruby version: 2.5.3
Rails version:  5.2.3

Postgres version 11.2
PostGIS (for storing coordinates and calculating distances) version 2.5.2

Other libraries:
- activerecord-postgis-adapter (support for PostGIS data types in ActiveRecord ORM)
- Rspec (unit testing)
- Factory Bot (unit testing)

## API
Server exposes 2 endpoints:

### GET /remarks
This endpoint returns list of all available remarks.
It supports search and filtering.
Search can be performed by passing a query string (matches user name and remark text).
Passing GPS coordinates and radius will limit the result to remarks which are within the specified radius using provided GPS coordinates as a center.

### POST /remarks
Creates a new remark based on provided details:
- user name
- text of the remark
- lng/lat

## Database schema
```ruby
create_table "remarks", force: :cascade do |t|
  t.string "user_name"
  t.text "body"
  t.geography "point", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["point"], name: "index_remarks_on_point", using: :gist
end
```

Using PostGIS allow to use special data types optimized for work with geographic data.
It is trivial to use it for finding records in a particular radius or calculating distance between points.

## Local setup
- install Ruby version 2.5.3 (Recommend using RVM: https://rvm.io/rvm/install)
- install PostGIS + Postgres: `brew install postgis`
- install required Ruby gem: `bundle install`
- initialize database: `rails db:setup`
- start the server: `rails server`

## Running tests
- setup test database: `RAILS_ENV=test rails db:setup`
- run the test suite: `bundle exec rspec spec/`


## Future development
- adding user authentication (registration/login workflow)
- adding ability to store additional information (photo, video files)
