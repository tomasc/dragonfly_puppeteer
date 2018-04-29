require 'json'

module DragonflyPuppeteer
  module Generators
    class Pdf

      class UnsupportedFormat < RuntimeError; end

      def call(content, source, opts = {})
        format = 'pdf'

        pdf_opts = extract_pdf_opts(opts)
        goto_opts = extract_goto_opts(opts)
        media_type = extract_media_type(opts)
        http_headers = extract_http_headers(opts)
        delay = extract_delay(opts)

        file_name = extract_file_name(opts)

        node_command = content.env.fetch(:node_command, 'node')

        content.shell_generate(ext: format) do |path|
          pdf_opts[:path] = path
          "#{node_command} #{script} #{Shellwords.escape(source)} '#{pdf_opts.to_json}' '#{goto_opts.to_json}' #{media_type} '#{http_headers.to_json}' #{delay}"
        end
        content.add_meta('format' => 'pdf', 'name' => "#{file_name}.pdf")
      end

      def update_url(url_attributes, source, opts = {})
        file_name = extract_file_name(opts)
        url_attributes.name = "#{file_name}.pdf"
      end

      private

      def extract_file_name(opts)
        opts['file_name'] || 'file'
      end

      def extract_goto_opts(opts)
        opts['goto_opts'] || {
          waitUntil: 'networkidle2'
        }
      end

      def extract_pdf_opts(opts)
        opts['pdf_opts'] || {}
      end

      def extract_media_type(opts)
        opts['media_type'] || 'null'
      end

      def extract_http_headers(opts)
        opts['http_headers'] || {}
      end

      def extract_delay(opts)
        opts['delay'] || 0
      end

      def script
        File.join(DragonflyPuppeteer.root, 'script/dist/pdf.js')
      end
    end
  end
end
