# frozen_string_literal: true

require 'test_helper'

class AssetsTest < Minitest::Test
  def test_registers_camera_assets
    assert_equal ['say-cheese', 'active_scaffold_camera'], ActiveScaffold.javascripts
    assert_equal ['active_scaffold_camera'], ActiveScaffold.stylesheets

    assert_path_exists File.expand_path('../app/assets/javascripts/say-cheese.js', __dir__)
    assert_path_exists File.expand_path('../app/assets/javascripts/active_scaffold_camera.js', __dir__)
    assert_path_exists File.expand_path('../app/assets/stylesheets/active_scaffold_camera.scss', __dir__)
  end

  def test_integration_asset_does_not_require_asset_processing
    source = File.read(File.expand_path('../app/assets/javascripts/active_scaffold_camera.js', __dir__))

    refute_includes source, '<%'
    refute_includes source, '//= require'
  end
end
