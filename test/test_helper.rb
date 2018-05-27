$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dragonfly_puppeteer'

require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/spec'

# SAMPLES_DIR = Pathname.new(File.expand_path('../../samples', __FILE__))

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def test_app(name = nil)
  Dragonfly::App.instance(name).tap do |app|
    app.datastore = Dragonfly::MemoryDataStore.new
    app.secret = 'test secret'
  end
end
