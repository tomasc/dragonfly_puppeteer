require 'json'

module DragonflyPuppeteer
  module Generators
    class Screenshot

      class UnsupportedFormat < RuntimeError; end

      def call(content, url, opts = {})
        format = extract_format(opts)
        raise UnsupportedFormat unless %w[jpg png].include?(format.to_s)

        viewport_opts = extract_viewport_opts(opts)
        screenshot_opts = extract_screenshot_opts(opts)
        screenshot_opts[:type] = (format == 'jpg' ? 'jpeg' : format)
        goto_opts = extract_goto_opts(opts)

        delay = extract_delay(opts)

        node_command = content.env.fetch(:node_command, 'node')
        # options[:host] ||= content.env[:host]
        # options[:port] ||= content.env[:port]

        content.shell_generate(ext: format) do |path|
          screenshot_opts[:path] = path
          "#{node_command} #{script} #{url} '#{viewport_opts.to_json}' '#{screenshot_opts.to_json}' '#{goto_opts.to_json}' #{delay}"
        end
        content.add_meta('format' => format)
      end

      def update_url(url_attributes, url, opts = {})
        url_attributes.name = "screenshot.#{extract_format(opts)}"
      end

      private

      def extract_format(opts)
        opts['format'] || 'png'
      end

      def extract_delay(opts)
        opts['delay'] || 0
      end

      def extract_viewport_opts(opts)
        opts['viewport_opts'] || {
          width: 1280,
          height: 800,
          isMobile: false,
          deviceScaleFactor: 1
        }
      end

      def extract_screenshot_opts(opts)
        opts['screenshot_opts'] || {
          fullPage: false,
          omitBackground: false,
          # quality: 100
        }
      end

      def extract_goto_opts(opts)
        opts['goto_opts'] || {
          waitUntil: 'networkidle2'
        }
      end

      def script
        File.join(DragonflyPuppeteer.root, 'script/dist/screenshot.js')
      end
    end
  end
end
