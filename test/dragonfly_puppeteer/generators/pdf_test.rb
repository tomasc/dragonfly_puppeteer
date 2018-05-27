require 'test_helper'

describe DragonflyPuppeteer::Generators::Pdf do
  let(:generator) { DragonflyPuppeteer::Generators::Pdf.new }
  let(:app) { test_app.configure_with(:puppeteer) }
  let(:content) { Dragonfly::Content.new(app) }
  let(:url_attributes) { Dragonfly::UrlAttributes.new }
  let(:file_name) {}
  let(:opts) { {} }
  let(:source) do
    %(
      <html>
        <body>TEST</body>
      </html>
    )
  end

  before do
    generator.call(content, source, opts)
    generator.update_url(url_attributes, source, opts)
  end

  describe 'formats' do
    describe 'PDF' do
      it { get_mime_type(content.path).must_include 'application/pdf' }
      it { content.meta.must_equal('format' => 'pdf', 'name' => 'file.pdf') }
      it { url_attributes.name.must_equal 'file.pdf' }
    end
  end

  describe 'URL source' do
    let(:source) { 'https://www.google.com' }

    it { get_mime_type(content.path).must_include 'application/pdf' }
    it { content.meta.must_equal('format' => 'pdf', 'name' => 'file.pdf') }
    it { url_attributes.name.must_equal 'file.pdf' }
  end

  describe 'when :file_name provided' do
    let(:file_name) { 'my_file_name' }
    let(:opts) { { 'file_name' => file_name } }

    it { content.meta.must_equal('format' => 'pdf', 'name' => "#{file_name}.pdf") }
    it { url_attributes.name.must_equal "#{file_name}.pdf" }
  end

  # ---------------------------------------------------------------------

  def get_mime_type(file_path)
    `file --mime-type #{file_path}`.delete("\n")
  end
end
