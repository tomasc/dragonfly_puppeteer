require 'test_helper'

describe DragonflyPuppeteer::Plugin do
  let(:app) { test_app.configure_with(:puppeteer) }

  describe 'generators' do
    describe ':pdf' do
      let(:result) { app.generate(:pdf, '<html></html>') }
      it { get_mime_type(result.path).must_include "application/pdf" }
    end

    describe ':screenshot' do
      let(:result) { app.generate(:screenshot, '<html></html>') }
      it { get_mime_type(result.path).must_include "image/png" }
    end
  end

  def get_mime_type(file_path)
    `file --mime-type #{file_path}`.gsub(/\n/, "")
  end
end
