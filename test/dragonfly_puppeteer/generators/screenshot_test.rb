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
      it { screenshot.meta.must_equal({"format" => "png"}) }
    end

    describe 'jpg' do
      before { generator.call(screenshot, url, 'format' => 'jpg') }
      it { get_mime_type(screenshot.path).must_include "image/jpeg" }
      it { screenshot.meta.must_equal({"format" => "jpg"}) }
    end
  end

  describe 'viewport_opts' do
    let(:width) { 800 }
    let(:height) { 600 }
    let(:viewport_opts) { { width: width, height: height } }

    before { generator.call(screenshot, url, 'viewport_opts' => viewport_opts) }

    describe 'width' do
      it { image_properties(screenshot)[:width].must_equal width }
    end

    describe 'height' do
      let(:height) { 200 }

      it { image_properties(screenshot)[:height].must_equal height }
    end

    describe 'deviceScaleFactor' do
      let(:deviceScaleFactor) { 2 }
      let(:viewport_opts) { { width: width, height: height, deviceScaleFactor: deviceScaleFactor } }

      it { image_properties(screenshot)[:width].must_equal width * 2 }
      it { image_properties(screenshot)[:height].must_equal height * 2 }
    end
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
