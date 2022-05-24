# AllegroApi

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add allegro_api

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install allegro_api

## Usage

### Example usage

```ruby
auth = AllegroApi::Auth.new(*Rails.application.credentials.allegro.values)
# or
auth = AllegroApi::Auth.new # client_id and secret taken from ENV["ALLEGRO_CLIENT_ID"], ENV["ALLEGRO_SECRET"]

auth.fetch_code
I, [2022-05-24T19:36:53.119343 #20694]  INFO -- : confirm in browser: https://allegro.pl/skojarz-aplikacje?code=ehxroj2jz
 =>
{"device_code"=>"LgR6IU3AuIu8y4KwnEN2eaT241AFetmp",
 "expires_in"=>3600,
 "user_code"=>"ehxroj2jz",
 "interval"=>5,
 "verification_uri"=>"https://allegro.pl/skojarz-aplikacje",
 "verification_uri_complete"=>"https://allegro.pl/skojarz-aplikacje?code=ehxroj2jz"}

auth.device_code
 => "LgR6IU3AuIu8y4KwnEN2eaT241AFetmp"

# Confirm in browser from link above

auth.fetch_access_token
 =>
{"access_token"=>
  "eyJhbGciOi..gewXuBw",
 "token_type"=>"bearer",
 "refresh_token"=>
  "eyJhbGciOiJSUz..u8BkOxXnqtptdg",
 "expires_in"=>43199,
 "scope"=>"allegro:api:orders:read allegro:api:billing:read allegro:api:payments:read",
 "allegro_api"=>true,
 "jti"=>"61dc1bf1-6921-4831-9a3c-939add1eefaz"}

 auth.access_token
  => "eyJhbGciOiJSUzI1NiIsInR5cCI6I..D2EjkWgewXuBw"

client = AllegroApi::Client.new(auth.access_token)
client.get('order/checkout-forms')
"https://api.allegro.pl/order/checkout-forms"
 =>
{"checkoutForms"=>
  []
}

client.get('order/events')
 => {"events"=>[]}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dawidof/allegro_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dawidof/allegro_api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AllegroApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dawidof/allegro_api/blob/master/CODE_OF_CONDUCT.md).
