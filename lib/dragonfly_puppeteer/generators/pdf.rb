require 'json'

module DragonflyPuppeteer
  module Generators
    class Pdf
      def call(content, source, opts = {})
        opts = stringify_keys(opts)

        format = 'pdf'

        raise UnsupportedOutputFormat unless SUPPORTED_OUTPUT_FORMATS_PDF.include?(format)

        pdf_opts = stringify_keys(extract_pdf_opts(opts))
        goto_opts = stringify_keys(extract_goto_opts(opts))
        http_headers = stringify_keys(extract_http_headers(opts))
        user_agent = extract_user_agent(opts)

        media_type = extract_media_type(opts)
        delay = extract_delay(opts)
        file_name = extract_file_name(opts)

        node_command = content.env.fetch('node_command', 'node')

        content.shell_generate(ext: format) do |path|
          pdf_opts['path'] = path
          "#{node_command} #{script} #{Shellwords.escape(source)} '#{pdf_opts.to_json}' '#{goto_opts.to_json}' #{media_type} '#{http_headers.to_json}' '#{user_agent}' #{delay}"
        end

        content.ext = format
        content.add_meta('format' => 'pdf', 'name' => "#{file_name}.pdf")
      end

      def update_url(url_attributes, _source, opts = {})
        file_name = extract_file_name(opts)
        url_attributes.name = "#{file_name}.pdf"
      end

      private

      def extract_file_name(opts)
        opts.fetch('file_name', 'file')
      end

      def extract_goto_opts(opts)
        opts.fetch('goto_opts') do
          {
            waitUntil: 'networkidle0'
          }
        end
      end

      def extract_pdf_opts(opts)
        opts.fetch('pdf_opts', {})
      end

      def extract_media_type(opts)
        opts.fetch('media_type', 'null')
      end

      def extract_http_headers(opts)
        opts.fetch('http_headers', {})
      end

      def extract_user_agent(opts)
        opts.fetch('user_agent', 'null')
      end

      def extract_delay(opts)
        opts.fetch('delay', 0)
      end

      def script
        File.join(DragonflyPuppeteer.root, 'script/dist/pdf.js')
      end

      def stringify_keys(hash)
        hash.each_with_object({}) { |(k, v), memo| memo[k.to_s] = v }
      end
    end
  end
end
