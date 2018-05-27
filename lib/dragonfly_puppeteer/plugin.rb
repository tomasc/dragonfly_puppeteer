module DragonflyPuppeteer
  class Plugin
    def call(app, options = {})
      app.env['node_command'] = options['node_command'] || 'node'

      app.add_generator :pdf, Generators::Pdf.new
      app.add_generator :screenshot, Generators::Screenshot.new
    end
  end
end

Dragonfly::App.register_plugin(:puppeteer) do
  DragonflyPuppeteer::Plugin.new
end
