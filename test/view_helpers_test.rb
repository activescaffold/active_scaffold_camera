# frozen_string_literal: true

require 'test_helper'

# Tests the camera form UI helper without requiring a Rails application.
class ViewHelpersTest < Minitest::Test
  Column = Struct.new(:name, :options)
  Record = Struct.new(:photo)

  class Helper
    include ActionView::Helpers::TagHelper
    include ActiveScaffoldCamera::ViewHelpers

    def as_(key)
      "translated #{key}"
    end

    def hidden_field(scope, attribute, options)
      "hidden:#{scope}:#{attribute}:#{options[:name]}"
    end
  end

  def setup
    @helper = Helper.new
    @column = Column.new(:photo, {})
  end

  def test_registers_camera_assets
    assert_includes ActiveScaffold.javascripts, 'active_scaffold_camera'
    assert_includes ActiveScaffold.stylesheets, 'active_scaffold_camera'
  end

  def test_snapshot_attributes_translate_defaults_and_include_source
    attributes = @helper.snapshot_attributes(@column, ui_options: {source: 'rear'})

    assert_equal 'translated video_not_supported', attributes[:video_not_supported]
    assert_equal 'translated audio_not_supported', attributes[:audio_not_supported]
    assert_equal 'translated media_forbidden', attributes[:media_forbidden]
    assert_equal 'rear', attributes[:source]
  end

  def test_snapshot_attributes_preserve_literal_messages
    attributes = @helper.snapshot_attributes(
      @column,
      ui_options: {video_not_supported: 'No camera', media_forbidden: :camera_denied}
    )

    assert_equal 'No camera', attributes[:video_not_supported]
    assert_equal 'translated camera_denied', attributes[:media_forbidden]
  end

  def test_snapshot_column_renders_only_when_a_value_exists
    assert_nil @helper.active_scaffold_column_snapshot(Record.new(nil), @column)
    assert_equal '<img src="data:image/png;base64,image">',
                 @helper.active_scaffold_column_snapshot(Record.new('data:image/png;base64,image'), @column)
  end

  def test_snapshot_input_renders_container_data_and_hidden_field
    html = @helper.active_scaffold_input_snapshot(
      @column,
      {class: 'camera', id: 'record_photo', name: 'record[photo]'},
      ui_options: {source: 'front'}
    )

    assert_includes html, 'class="snapshot-input camera"'
    assert_includes html, 'id="record_photo"'
    assert_includes html, 'data-source="front"'
    assert_includes html, 'hidden:record:photo:record[photo]'
  end

  def test_root_points_to_the_gem_directory
    assert_equal File.expand_path('..', __dir__), File.expand_path(ActiveScaffoldCamera.root)
  end

  def test_engine_initializer_installs_view_helpers_on_action_view
    initializer = ActiveScaffoldCamera::Engine.initializers.find do |item|
      item.name == 'active_scaffold_camera.action_view'
    end

    initializer.run

    assert_includes ActionView::Base.ancestors, ActiveScaffoldCamera::ViewHelpers
  end
end
