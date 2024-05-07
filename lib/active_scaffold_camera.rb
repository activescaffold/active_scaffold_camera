require "active_scaffold_camera/engine.rb"

module ActiveScaffoldCamera
  def self.root
    File.dirname(__FILE__) + "/.."
  end
  autoload 'ViewHelpers', 'active_scaffold_camera/view_helpers.rb'
end
