# DragonflyPuppeteer

[![Build Status](https://travis-ci.org/tomasc/dragonfly_puppeteer.svg)](https://travis-ci.org/tomasc/dragonfly_puppeteer) [![Gem Version](https://badge.fury.io/rb/dragonfly_puppeteer.svg)](http://badge.fury.io/rb/dragonfly_puppeteer) [![Coverage Status](https://img.shields.io/coveralls/tomasc/dragonfly_puppeteer.svg)](https://coveralls.io/r/tomasc/dragonfly_puppeteer)

## Requirements

* node
* Chrome headless

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dragonfly_puppeteer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dragonfly_puppeteer

## Usage

Add the plugin to Dragonfly:

```ruby
Dragonfly.app.configure do
  plugin :puppeteer
end
```

```ruby
Dragonfly.app.configure do
  plugin :puppeteer, host: 'chrome_headless', port: '9222'
end
```

### Screenshot generator

```ruby
Dragonfly.app.generate(
  :screenshot,

  "https://www.google.com",

  "format" => "png",

  # default value, additional delay before taking screenshot
  "delay" => 0,

  # default values
  "viewport_opts" => {
    "width" => 1200,
    "height" => 800,
    "isMobile" => false,
    "deviceScaleFactor" => 2
  },

  # default values
  "screenshot_opts" => {
    "fullPage" => true,
    "omitBackground" => false
  },

  # default values
  "goto_opts" => {
    "waitUntil" => "networkidle2"
  }
)
```

For list of all options see Puppeteer API docs:
* [`page.setViewport`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagesetviewportviewport)
* [`page.screenshot`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagescreenshotoptions)
* [`page.goto`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagegotourl-options)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To install JS dependencies run `yarn`. To recompile JS scripts run `yarn run webpack`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dragonfly_puppeteer.
