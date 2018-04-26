require "dragonfly"
require "dragonfly_puppeteer/generators/screenshot"
require "dragonfly_puppeteer/plugin"
require "dragonfly_puppeteer/version"

module DragonflyPuppeteer
  def self.root
    File.expand_path("../..", __FILE__)
  end
end
