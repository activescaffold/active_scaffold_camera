//= require say-cheese
//= require_self

ActiveScaffold.snapshot = function(selector_or_elements, parent) {
  function modernMediaApi() {
    return navigator.mediaDevices && navigator.mediaDevices.getUserMedia;
  }

  function videoConstraint(video) {
    if (typeof(video) != 'string') return video;
    return modernMediaApi() ? {deviceId: {exact: video}} : {optional: [{sourceId: video}]};
  }

  function audioConstraint(audio) {
    if (typeof(audio) != 'string') return audio;
    return modernMediaApi() ? {deviceId: {exact: audio}} : {optional: [{sourceId: audio}]};
  }

  function enumerateVideoSources(callback) {
    if (navigator.mediaDevices && navigator.mediaDevices.enumerateDevices) {
      navigator.mediaDevices.enumerateDevices().then(function(devices) {
        callback(devices.filter(function(device) {
          return device.kind == 'videoinput';
        }).map(function(device) {
          return {id: device.deviceId, label: device.label};
        }));
      }).catch(function() {
        callback([]);
      });
    } else if (window.MediaStreamTrack && MediaStreamTrack.getSources) {
      MediaStreamTrack.getSources(function(sourceInfos) {
        callback(sourceInfos.filter(function(source) {
          return source.kind == 'video';
        }));
      });
    } else {
      callback([]);
    }
  }

  function startVideo(element, video, audio, video_select) {
    var sayCheese = new SayCheese(element, {snapshots: true, video: videoConstraint(video), audio: audioConstraint(audio)});

    if (video_select) {
      video_select.on('change', function() {
        sayCheese.stop();
        sayCheese.video.remove();
        $('.snapshots', sayCheese.element).remove();
        $('input', sayCheese.element).val('');
        sayCheese.options.video = videoConstraint($(this).val());
        sayCheese.start();
      });
    }
    
    sayCheese.on('start', function() {
      $(this.video).data('saycheese', this);
      $(this.video).after($('<div>').addClass('snapshots'));
      this.video.play();
    });
    sayCheese.on('error', function(error) {
      var $alert = $('<div>');
      $alert.addClass('message error-message').css('margin-top', '20px');

      if (error === 'NOT_SUPPORTED') {
        $alert.html($(this.element).data('video-not-supported'));
      } else if (error === 'AUDIO_NOT_SUPPORTED') {
        $alert.html($(this.element).data('audio-not-supported'));
      } else {
        $alert.html($(this.element).data('media-forbidden'));
      }

      $(this.element).prepend($alert);
    });
    sayCheese.on('snapshot', function(snapshot) {
      var img = document.createElement('img'), container = $(this.video).parent(), input = $('input', this.element);
      $(img).on('load', function() { $('.snapshots', container).html(img); });
      img.src = snapshot.toDataURL('image/png');
      input.val(img.src);
    });

    sayCheese.start();
  }
  
  var elements;
  if (typeof(selector_or_elements) == 'string') elements = jQuery(selector_or_elements, parent);
  else elements = jQuery(selector_or_elements);

  elements.each(function() {
    var $element = $(this), selector = '#' + $element.attr('id');
    enumerateVideoSources(function(sources) {
      var video, source, select, index = $element.data('source');
      if (index != null) {
        if (index < 0) source = sources[sources.length + index];
        else source = sources[index];
        if (source) video = source.id;
      } else if (sources.length > 1) {
        select = $('<select>');
        for (var i in sources) {
          source = sources[i];
          select.append($('<option>').val(source.id).html(source.label || 'camera ' + (i + 1)));
        }
        $element.prepend(select);
      }
      startVideo(selector, video || true, false, select);
    });
  });
};

jQuery(document).ready(function($) {
  $(document).on('click', '.active-scaffold .snapshot video', function() {
    $(this).data('saycheese').takeSnapshot();
  });
  $(document).on('as:action_success', 'a.as_action', function(e, action_link) {
    var elements = $('.snapshot-input', action_link.adapter);
    if (elements.length) ActiveScaffold.snapshot(elements);
  });
  $(document).on('as:element_updated', function(e) {
    var elements = $('.snapshot-input', e.target);
    if (elements.length) ActiveScaffold.snapshot(elements);
  });
  var elements = $('.snapshot-input');
  if (elements.length) ActiveScaffold.snapshot(elements);
});
