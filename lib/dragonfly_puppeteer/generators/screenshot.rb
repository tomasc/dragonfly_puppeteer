require 'json'

module DragonflyPuppeteer
  module Generators
    class Screenshot
      def call(content, source, opts = {})
        opts = stringify_keys(opts)

        format = extract_format(opts)

        raise UnsupportedOutputFormat unless SUPPORTED_OUTPUT_FORMATS_SCREENSHOT.include?(format)

        viewport_opts = stringify_keys(extract_viewport_opts(opts)).reject{ |k, v| v.nil? || v == "" }
        screenshot_opts = stringify_keys(extract_screenshot_opts(opts)).reject{ |k, v| v.nil? || v == "" }
        screenshot_opts['type'] = (format == 'jpg' ? 'jpeg' : format)
        goto_opts = stringify_keys(extract_goto_opts(opts)).reject{ |k, v| v.nil? || v == "" }
        http_headers = stringify_keys(extract_http_headers(opts)).reject{ |k, v| v.nil? || v == "" }

        delay = extract_delay(opts)
        file_name = extract_file_name(opts)

        node_command = content.env.fetch('node_command', 'node')

        content.shell_generate(ext: format) do |path|
          screenshot_opts['path'] = path
          "#{node_command} #{script} #{Shellwords.escape(source)} '#{viewport_opts.to_json}' '#{screenshot_opts.to_json}' '#{goto_opts.to_json}' '#{http_headers.to_json}' #{delay}"
        end

        content.ext = format
        content.add_meta('format' => format, 'name' => "#{file_name}.#{format}")
      end

      def update_url(url_attributes, source, opts = {})
        opts = stringify_keys(opts)
        format = extract_format(opts)
        file_name = extract_file_name(opts)
        url_attributes.name = "#{file_name}.#{format}"
      end

      private

      def extract_file_name(opts)
        opts.fetch('file_name', 'file')
      end

      def extract_format(opts)
        opts.fetch('format', 'png').to_s
      end

      def extract_viewport_opts(opts)
        opts.fetch('viewport_opts') do
          {
            width: 1280,
            height: 800,
            isMobile: false,
            deviceScaleFactor: 1
          }
        end
      end

      def extract_screenshot_opts(opts)
        opts.fetch('screenshot_opts') do
          {
            fullPage: false,
            omitBackground: false,
            # quality: 100
          }
        end
      end

      def extract_goto_opts(opts)
        opts.fetch('goto_opts') do
          {
            waitUntil: 'networkidle0'
          }
        end
      end

      def extract_http_headers(opts)
        opts.fetch('http_headers', {})
      end

      def extract_delay(opts)
        opts.fetch('delay', 0)
      end

      def script
        File.join(DragonflyPuppeteer.root, 'script/dist/screenshot.js')
      end

      def stringify_keys(hash)
        hash.each_with_object({}) { |(k, v), memo| memo[k.to_s] = v }
      end
    end
  end
end
