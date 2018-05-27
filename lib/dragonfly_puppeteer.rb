require 'dragonfly'

require 'dragonfly_puppeteer/generators/pdf'
require 'dragonfly_puppeteer/generators/screenshot'

require 'dragonfly_puppeteer/plugin'
require 'dragonfly_puppeteer/version'

module DragonflyPuppeteer
  class UnsupportedOutputFormat < RuntimeError; end

  SUPPORTED_OUTPUT_FORMATS_PDF = %w[pdf]
  SUPPORTED_OUTPUT_FORMATS_SCREENSHOT = %w[jpg jpeg png]

  SUPPORTED_OUTPUT_FORMATS = (
    SUPPORTED_OUTPUT_FORMATS_PDF +
    SUPPORTED_OUTPUT_FORMATS_SCREENSHOT
  ).freeze

  def self.root
    File.expand_path('..', __dir__)
  end
end
