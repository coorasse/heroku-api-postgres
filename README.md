# Heroku::Api::Postgres

Ruby library to invoke Heroku Postgres APIs.
An extension to the official [Platform API]() gem to introduce the missing APIs for Postgres.

:warning: This gem is not officialy supported, therefore if Heroku changes their APIs it may stop working. :warning:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku-api-postgres'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku-api-postgres

## Usage

Even if this gem does not require `platform-api` to be installed, you probably want to have it installed as well.

```ruby
# from platform api gem

heroku = PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN'])
```

### Backups

#### Schedules

```ruby
backups = Heroku::Api::Postgres::Backups.new(ENV['HEROKU_OAUTH_TOKEN'])
backups.schedules(id_of_database)
```

```ruby
[
  { :uuid=>"schedule-id",
    :name=>"DATABASE_URL",
    :hour=>2,
    :days=>["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    :timezone=>"Europe/Zurich",
    :created_at=>"2018-01-09 11:28:57 +0000",
    :updated_at=>"2018-03-02 01:19:52 +0000",
    :deleted_at=>nil,
    :retain_weeks=>1,
    :retain_months=>0}
]
```

To get the backup schedules of a database you need a database id. You can obtain a database id by calling the Heroku Platform API
```ruby
addons = heroku.addon.list
databases = addons.select { |addon| addon['addon_service']['name'] == 'heroku-postgresql' }
databases_ids = databases.map{ |addon| addon['id'] }
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coorasse/heroku-api-postgres.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Heroku::Api::Postgres project’s codebases, issue trackers, chat rooms and mailing lists is
expected to follow the [code of conduct](https://github.com/[USERNAME]/heroku-api-postgres/blob/master/CODE_OF_CONDUCT.md).
