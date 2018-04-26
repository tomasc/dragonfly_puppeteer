require 'json'

module DragonflyPuppeteer
  module Processors
    class Screenshot
      class UnsupportedFormat < RuntimeError; end

      def call(content, format=:png, options={})
        raise UnsupportedFormat unless %w(jpg png).include?(format.to_s)

        node_command = content.env.fetch(:node_command, 'node')
        options[:host] ||= content.env[:host]
        options[:port] ||= content.env[:port]

        options = options.reject{ |_, v| v.nil? }

        content.shell_update(ext: format) do |old_path, new_path|
          "#{node_command} #{script} #{old_path} #{new_path} '#{options.to_json}'"
        end
      end

      def update_url(attrs, format, args='')
        attrs.ext = format.to_s
      end

      private

      def script
        File.join(DragonflyPuppeteer.root, "script/dist/screenshot.js")
      end
    end
  end
end
