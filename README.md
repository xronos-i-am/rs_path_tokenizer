# RsPathTokenizer

PathTokenizer founds predefined parts (tokens) into specified URL

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rs_path_tokenizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rs_path_tokenizer

## Usage

```ruby
  # define tokens data
  # hash key - token's URL code
  # hash value - returned property & value (ie for SQL query)
  tokens_data = {
    'balashiha' => ['region', 'balashiha'],
    'balashiha-gorodskoj-okrug' => ['region', 'balashiha-gorodskoj-okrug'],
    'gorodskoj-okrug-drugoi' => ['region', 'gorodskoj-okrug-drugoi'],
    # price from
    'price-*' => ['price', nil],
    # price from any to any (including from 0 to any)
    'price-*-*' => ['price', nil],
    'expensive' => ['sort', 'expensive']
  }

  tokenizer = RsPathTokenizer::Tokenizer.new(tokens_data)

  # search tokens in specified URL
  found_tokens = tokenizer.tokenize('balashiha-gorodskoj-okrug-drugoi-price-100-expensive')

  # {"balashiha"=>["region", "balashiha"],
  #  "gorodskoj-okrug-drugoi"=>["region", "gorodskoj-okrug-drugoi"],
  #  "price-*"=>["price", "100"],
  #  "expensive"=>["sort", "expensive"]}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rs_path_tokenizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
