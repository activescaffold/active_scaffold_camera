# frozen_string_literal: true

require 'test_helper'

class AssetsTest < Minitest::Test
  def test_registers_camera_assets
    assert_equal ['active_scaffold_camera'], ActiveScaffold.javascripts
    assert_equal ['active_scaffold_camera'], ActiveScaffold.stylesheets

    assert_path_exists File.expand_path('../app/assets/javascripts/active_scaffold_camera.js', __dir__)
    assert_path_exists File.expand_path('../app/assets/stylesheets/active_scaffold_camera.scss', __dir__)
  end

  def test_javascript_requires_camera_library_before_integration
    source = File.read(File.expand_path('../app/assets/javascripts/active_scaffold_camera.js', __dir__))

    assert_includes source, '//= require say-cheese'
    assert_includes source, '//= require_self'
    assert_path_exists File.expand_path('../app/assets/javascripts/say-cheese.js', __dir__)
  end
end
