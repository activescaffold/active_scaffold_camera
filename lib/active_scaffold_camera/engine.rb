module ActiveScaffoldCamera
  class Engine < ::Rails::Engine
    initializer 'active_scaffold_camera.action_view' do
      ActiveSupport.on_load :action_view do
        include ActiveScaffoldCamera::ViewHelpers
      end
    end
  end
end
