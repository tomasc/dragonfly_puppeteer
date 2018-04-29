require 'test_helper'

describe DragonflyPuppeteer::Generators::Screenshot do
  let(:generator) { DragonflyPuppeteer::Generators::Screenshot.new }
  let(:app) { test_app.configure_with(:puppeteer) }
  let(:content) { Dragonfly::Content.new(app) }
  let(:div_width) { 1200 }
  let(:div_height) { 1200 }
  let(:url_attributes) { Dragonfly::UrlAttributes.new }
  let(:source) { %Q{
    <html>
      <head>
        <style type="text/css">
          body { margin: 0; }
          .test { width: #{div_width}px; height: #{div_height}px; }
        </style>
      </head>
      <body>
        <div class="test">TEST</div>
      </body>
    </html>
  } }
  let(:opts) { {} }

  before do
    generator.call(content, source, opts)
    generator.update_url(url_attributes, source, opts)
  end

  describe 'formats' do
    describe 'png' do
      let(:opts) { { 'format' => 'png' } }

      it { get_mime_type(content.path).must_include "image/png" }
      it { content.meta.must_equal("format" => "png", "name" => "file.png") }
      it { url_attributes.name.must_equal "file.png" }
    end

    describe 'jpg' do
      let(:opts) { { 'format' => 'jpg' } }

      it { get_mime_type(content.path).must_include "image/jpeg" }
      it { content.meta.must_equal("format" => "jpg", "name" => "file.jpg") }
      it { url_attributes.name.must_equal "file.jpg" }
    end
  end

  describe 'viewport_opts' do
    let(:width) { 800 }
    let(:height) { 600 }
    let(:opts) { { 'viewport_opts' => { width: width, height: height } } }

    describe 'width' do
      it { image_properties(content)[:width].must_equal width }
    end

    describe 'height' do
      let(:height) { 200 }

      it { image_properties(content)[:height].must_equal height }
    end

    describe 'deviceScaleFactor' do
      let(:deviceScaleFactor) { 2 }
      let(:opts) { { 'viewport_opts' => { width: width, height: height, deviceScaleFactor: deviceScaleFactor } } }

      it { image_properties(content)[:width].must_equal width * 2 }
      it { image_properties(content)[:height].must_equal height * 2 }
    end
  end

  describe 'screenshot_opts' do
    describe 'fullPage' do
      let(:width) { 200 }
      let(:height) { 200 }
      let(:opts) { { 'viewport_opts' => { width: width, height: height }, 'screenshot_opts' => { fullPage: true } } }

      it { image_properties(content)[:width].must_be :>=, div_width }
      it { image_properties(content)[:height].must_be :>=, div_height }
    end
  end

  describe 'URL source' do
    let(:source) { 'https://www.google.com' }

    it { get_mime_type(content.path).must_include "image/png" }
    it { content.meta.must_equal("format" => "png", "name" => "file.png") }
    it { url_attributes.name.must_equal "file.png" }
  end

  describe 'when :file_name provided' do
    let(:file_name) { "my_file_name" }
    let(:opts) { { 'file_name' => file_name } }

    it { content.meta.must_equal("format" => "png", "name" => "#{file_name}.png") }
    it { url_attributes.name.must_equal "#{file_name}.png" }
  end

  # ---------------------------------------------------------------------

  def get_mime_type(file_path)
    `file --mime-type #{file_path}`.gsub(/\n/, "")
  end

  def image_properties(image)
    details = `identify #{image.path}`
    raise "couldn't identify #{image.path} in image_properties" if details.empty?
    # example of details string:
    # myimage.png PNG 200x100 200x100+0+0 8-bit DirectClass 31.2kb
    filename, format, geometry, geometry_2, depth, image_class, size = details.split(' ')
    width, height = geometry.split('x')
    {
      :filename => filename,
      :format => format.downcase,
      :width => width.to_i,
      :height => height.to_i,
      :depth => depth,
      :image_class => image_class,
      :size => size.to_i
    }
  end
end
