require 'test_helper'

describe DragonflyPuppeteer::Generators::Screenshot do
  let(:generator) { DragonflyPuppeteer::Generators::Screenshot.new }
  let(:app) { test_app.configure_with(:puppeteer) }
  let(:screenshot) { Dragonfly::Content.new(app) }

  let(:url) { 'https://www.google.com' }

  describe 'formats' do
    describe 'png' do
      before { generator.call(screenshot, url, 'format' => 'png') }
      it { get_mime_type(screenshot.path).must_include "image/png" }
    end

    describe 'jpg' do
      before { generator.call(screenshot, url, 'format' => 'jpg') }
      it { get_mime_type(screenshot.path).must_include "image/jpeg" }
    end
  end

  def get_mime_type(file_path)
    `file --mime-type #{file_path}`.gsub(/\n/, "")
  end
end
