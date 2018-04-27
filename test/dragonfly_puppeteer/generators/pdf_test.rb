require 'test_helper'

describe DragonflyPuppeteer::Generators::Pdf do
  let(:generator) { DragonflyPuppeteer::Generators::Pdf.new }
  let(:app) { test_app.configure_with(:puppeteer) }
  let(:content) { Dragonfly::Content.new(app) }

  let(:source) { %Q{
    <html>
      <head></head>
      <body>TEST</body>
    </html>
  } }

  before { generator.call(content, source) }

  describe 'formats' do
    describe 'PDF' do
      it { get_mime_type(content.path).must_include "application/pdf" }
      it { content.meta.must_equal("format" => "pdf") }
    end
  end

  describe 'URL source' do
    let(:source) { "https://www.google.com" }

    it { get_mime_type(content.path).must_include "application/pdf" }
  end

  # ---------------------------------------------------------------------

  def get_mime_type(file_path)
    `file --mime-type #{file_path}`.gsub(/\n/, "")
  end
end
