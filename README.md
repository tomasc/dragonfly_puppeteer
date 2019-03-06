# DragonflyPuppeteer

[![Build Status](https://travis-ci.org/tomasc/dragonfly_puppeteer.svg)](https://travis-ci.org/tomasc/dragonfly_puppeteer) [![Gem Version](https://badge.fury.io/rb/dragonfly_puppeteer.svg)](http://badge.fury.io/rb/dragonfly_puppeteer) [![Coverage Status](https://img.shields.io/coveralls/tomasc/dragonfly_puppeteer.svg)](https://coveralls.io/r/tomasc/dragonfly_puppeteer)

[Dragonfly](https://github.com/markevans/dragonfly) gem that uses [Puppeteer](https://github.com/GoogleChrome/puppeteer) to control headless Chrome in order to render PDF or screenshots.

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

The gem bundles all `node_modules` required for the Puppeteer scripts to run and connect to remote Chrome. For that to work, the `CHROME_HEADLESS_HOST` and `CHROME_HEADLESS_PORT` env variables need to be set.

If you wish to use the Chromium bundled with Puppeteer, run `yarn --check-files` first (so that the bundled Chromium is installed).

### PDF generator

```ruby
Dragonfly.app.generate(:pdf, source, opts)
```

The `source` can be:
* url (such as https://www.google.com)
* HTML string (such as `<html><head></head><body>TEST</body></html>`)

With options:

```ruby
Dragonfly.app.generate(
  :pdf,

  "https://www.google.com",

  # default value, additional delay before saving PDF
  "delay" => 0,

  # default value, name for the generated PDF
  "file_name" => "file",

  # default value
  "pdf_opts" => {},

  # default values
  "goto_opts" => {
    "waitUntil" => "networkidle2"
  },

  # default value
  "media_type" => "null",

  # default value
  "http_headers" => {}
)
```

For list of options see Puppeteer API docs:
* [`page.pdf`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagepdfoptions)
* [`page.goto`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagegotourl-options)
* [`page.emulateMedia`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pageemulatemediamediatype)
* [`page.setExtraHTTPHeaders`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagesetextrahttpheadersheaders)

### Screenshot generator

```ruby
Dragonfly.app.generate(:screenshot, source, opts)
```

The `source` can be:
* url (such as https://www.google.com)
* HTML string (such as `<html><head></head><body>TEST</body></html>`)

With options:

```ruby
Dragonfly.app.generate(
  :screenshot,

  "https://www.google.com",

  # default value
  "format" => "png",

  # default value, additional delay before taking screenshot
  "delay" => 0,

  # default value, name for the generated PDF
  "file_name" => "file",

  # default values
  "viewport_opts" => {
    "width" => 1280,
    "height" => 800,
    "isMobile" => false,
    "deviceScaleFactor" => 1
  },

  # default values
  "screenshot_opts" => {
    "fullPage" => false,
    "omitBackground" => false
  },

  # default values
  "goto_opts" => {
    "waitUntil" => "networkidle2"
  },

  # default value
  "http_headers" => {}
)
```

For list of options see Puppeteer API docs:
* [`page.setViewport`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagesetviewportviewport)
* [`page.screenshot`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagescreenshotoptions)
* [`page.goto`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagegotourl-options)
* [`page.setExtraHTTPHeaders`](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagesetextrahttpheadersheaders)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To install JS dependencies run `yarn`. To recompile JS scripts run `yarn run webpack`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/dragonfly_puppeteer.
