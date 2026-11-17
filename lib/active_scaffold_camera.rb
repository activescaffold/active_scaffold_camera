# frozen_string_literal: true

require 'active_scaffold_camera/engine'

module ActiveScaffoldCamera
  def self.root
    "#{File.dirname(__FILE__)}/.."
  end
  autoload :ViewHelpers, 'active_scaffold_camera/view_helpers.rb'
end

ActiveScaffold.stylesheets << 'active_scaffold_camera'
ActiveScaffold.javascripts.push('say-cheese', 'active_scaffold_camera')
