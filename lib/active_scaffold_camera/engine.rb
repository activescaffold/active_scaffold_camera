module ActiveScaffoldCamera
  class Engine < ::Rails::Engine
    initializer 'active_scaffold_camera.action_view' do
      ActiveSupport.on_load :action_view do
        include ActiveScaffoldCamera::ViewHelpers
      end
    end

    initializer "active_scaffold_camera.assets" do
      ActiveSupport.on_load :active_scaffold do
        self.stylesheets << 'active_scaffold_camera'
        self.javascripts << 'active_scaffold_camera'
      end
    end
  end
end
