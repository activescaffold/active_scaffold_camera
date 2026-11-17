# frozen_string_literal: true

require 'javascript_test_helper'

class CameraJavascriptTest < ActiveScaffold::TestSupport::Javascript::TestCase
  def test_loads_camera_library_before_adapter
    visit_javascript_fixture

    assert_javascript 'typeof window.SayCheese === "function"'
    assert_javascript 'typeof ActiveScaffold.snapshot === "function"'
    assert_no_javascript_errors
  end

  def test_initializes_camera_fields_on_load_and_element_update
    with_plugin_assets('active_scaffold_camera') do
      visit_javascript_fixture camera_fixture

      assert_selector '#camera video'
      assert_selector '#camera select option', count: 2
      assert_javascript 'window.cameraInstances[0].options.snapshots === true'

      insert_fixture_html snapshot_field('dynamic-camera'), into: '#dynamic-container'
      trigger_active_scaffold_event :element_updated, target: '#dynamic-container'

      assert_selector '#dynamic-camera video'
      assert_javascript 'window.cameraInstances.length === 2'
      assert_no_javascript_errors
    end
  end

  private

  def camera_fixture
    <<~HTML
      <script>
        window.cameraInstances = [];
        Object.defineProperty(navigator, 'mediaDevices', {
          configurable: true,
          value: {
            getUserMedia: function() {},
            enumerateDevices: function() {
              return Promise.resolve([
                {kind: 'videoinput', deviceId: 'front', label: 'Front'},
                {kind: 'videoinput', deviceId: 'rear', label: 'Rear'}
              ]);
            }
          }
        });
        window.SayCheese = function(element, options) {
          this.element = document.querySelector(element);
          this.options = options;
          this.handlers = {};
          this.video = document.createElement('video');
          this.video.play = function() { return Promise.resolve(); };
          this.element.appendChild(this.video);
          this.on = function(name, callback) { this.handlers[name] = callback; };
          this.start = function() {
            if (this.handlers.start) this.handlers.start.call(this);
          };
          this.stop = function() {};
          this.takeSnapshot = function() {};
          window.cameraInstances.push(this);
        };
      </script>
      <div class="active-scaffold">
        #{snapshot_field('camera')}
        <div id="dynamic-container"></div>
      </div>
    HTML
  end

  def snapshot_field(id)
    <<~HTML
      <div id="#{id}" class="snapshot-input snapshot"
           data-video-not-supported="Video unavailable"
           data-audio-not-supported="Audio unavailable"
           data-media-forbidden="Media forbidden">
        <input type="hidden" value="">
      </div>
    HTML
  end

  def with_plugin_assets(*assets)
    original = ActiveScaffold.javascripts.dup
    ActiveScaffold.javascripts.replace(assets)
    yield
  ensure
    ActiveScaffold.javascripts.replace(original)
  end
end
