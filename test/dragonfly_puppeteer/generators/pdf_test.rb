require 'test_helper'

describe DragonflyPuppeteer::Generators::Pdf do
  let(:generator) { DragonflyPuppeteer::Generators::Pdf.new }
  let(:app) { test_app.configure_with(:puppeteer) }
  let(:content) { Dragonfly::Content.new(app) }

  let(:source) { 'https://www.google.com' }

  describe 'formats' do
    describe 'PDF' do
      before { generator.call(content, source) }
      it { get_mime_type(content.path).must_include "application/pdf" }
      it { content.meta.must_equal("format" => "pdf") }
    end
  end

  # ---------------------------------------------------------------------

  def get_mime_type(file_path)
    `file --mime-type #{file_path}`.gsub(/\n/, "")
  end
end
