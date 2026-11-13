# frozen_string_literal: true

require 'test_helper'

# Tests the camera form UI helper without requiring a Rails application.
class ViewHelpersTest < Minitest::Test
  Column = Struct.new(:name, :options)
  Record = Struct.new(:photo)

  class Helper
    include ActiveScaffoldCamera::ViewHelpers

    def as_(key)
      "translated #{key}"
    end

    def tag(name, attributes)
      [name, attributes]
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
    assert_equal [:img, {src: 'data:image/png;base64,image'}],
                 @helper.active_scaffold_column_snapshot(Record.new('data:image/png;base64,image'), @column)
  end
end
