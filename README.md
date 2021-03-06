# GoogleDirectionsApi

A wrapper around the google directions api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_directions_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_directions_api

## Usage

Set your Google API Key as the environment variable `GOOGLE_API_KEY`.

To get directions

```ruby
direction = GoogleDirectionsAPI::Directions.new_for_locations(from: '123 Fake St., Atlanta, GA', to: '345 Main St., Atlanta, GA')

directions.distance
directions.duration
directions.polyline
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/aubreyrhodes/google_directions_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
