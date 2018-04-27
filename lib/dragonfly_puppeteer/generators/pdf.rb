require 'json'

module DragonflyPuppeteer
  module Generators
    class Pdf

      class UnsupportedFormat < RuntimeError; end

      def call(content, source, opts = {})
        format = 'pdf'

        pdf_opts = extract_pdf_opts(opts)
        goto_opts = extract_goto_opts(opts)

        delay = extract_delay(opts)
        media_type = extract_media_type(opts)

        node_command = content.env.fetch(:node_command, 'node')
        # options[:host] ||= content.env[:host]
        # options[:port] ||= content.env[:port]

        content.shell_generate(ext: format) do |path|
          pdf_opts[:path] = path
          "#{node_command} #{script} #{Shellwords.escape(source)} '#{pdf_opts.to_json}' '#{goto_opts.to_json}' #{media_type} #{delay}"
        end
        content.add_meta('format' => 'pdf')
      end

      def update_url(url_attributes, source, opts = {})
        url_attributes.name = "pdf.pdf"
      end

      private

      def extract_delay(opts)
        opts['delay'] || 0
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

      def script
        File.join(DragonflyPuppeteer.root, 'script/dist/pdf.js')
      end
    end
  end
end
