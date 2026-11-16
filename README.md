# Camera for ActiveScaffold

[![Build status](https://github.com/activescaffold/active_scaffold_camera/actions/workflows/ci.yml/badge.svg)](https://github.com/activescaffold/active_scaffold_camera/actions/workflows/ci.yml)
[![Maintainability](https://qlty.sh/gh/activescaffold/projects/active_scaffold_camera/maintainability.svg)](https://qlty.sh/gh/activescaffold/projects/active_scaffold_camera)
[![Code Coverage](https://qlty.sh/gh/activescaffold/projects/active_scaffold_camera/coverage.svg)](https://qlty.sh/gh/activescaffold/projects/active_scaffold_camera)
[![Gem Version](https://badge.fury.io/rb/active_scaffold_camera.svg)](https://badge.fury.io/rb/active_scaffold_camera)
[![Inline docs](https://inch-ci.org/github/activescaffold/active_scaffold_camera.svg?branch=master)](https://inch-ci.org/github/activescaffold/active_scaffold_camera)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Currently, this plugin is compatible with ActiveScaffold >= 3.4 gem.

## Overview

This plugin adds a camera viewer to take a snapshot from camera on ActiveScaffold forms. It uses [SayCheese.js](https://github.com/leemachin/say-cheese)

### Browser compatibility

The plugin uses the modern `navigator.mediaDevices` API when available, including
[`enumerateDevices()`](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/enumerateDevices)
and `deviceId` constraints. The legacy callback-based API, `MediaStreamTrack.getSources`,
and `sourceId` constraints remain available as a fallback for older browsers.

Camera access requires a secure context (HTTPS or localhost) and the user's permission.

## Installation

You'll need at least ActiveScaffold 3.4 to use this

```
gem install active_scaffold_camera
```

## Usage

#### Step 1

Set column to use :snapshot form_ui

#### Step 2

Setup snapshot using options method on column

```ruby
# app/controllers/visitors_controller.rb

class VisitorsController < ApplicationController
  active_scaffold :visitor do |config|
    config.columns[:id_card].form_ui = :snapshot
    config.columns[:id_card].options = {:source => -1}
  end
end
```

Available options: video_not_supported, audio_not_supported, media_forbidden, source

Source can be set to use a specific source instead of displaying source selector. It must be the source index, and it can be negative index to start from end. If no device on that index, first device will be used.

If video_not_supported, audio_not_supported or media_forbidden are symbols they will be translated (using as_ method, so it must be on active_scaffold namespace). They have a default translation.

#### Save image

Snapshot form_ui sends a data url, encoded on base64, of the image, so it should be saved on column of blob type.

## Support

If you have issues installing the plugin, search / post to the [Active Scaffold](http://groups.google.com/group/activescaffold) forum or [Create an issue](http://github.com/activescaffold/active_scaffold_camera/issues)

## Contributing

Fork, hack, push, and request a pull:

http://github.com/activescaffold/active_scaffold_camera/

## License

Released under the MIT license (included).
