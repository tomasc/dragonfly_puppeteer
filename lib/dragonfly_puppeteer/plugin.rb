module DragonflyPuppeteer
  class Plugin
    def call(app, options={})
      app.env[:node_command] = options[:node_command] || 'node'
      app.env[:host] = options[:host]
      app.env[:port] = options[:port]

      # app.add_processor :rasterize, DragonflyChromeHeadless::Processors::Rasterize.new
    end
  end
end

Dragonfly::App.register_plugin(:puppeteer) do
  DragonflyPuppeteer::Plugin.new
end
