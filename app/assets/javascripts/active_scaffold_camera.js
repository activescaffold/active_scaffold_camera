//= require say-cheese
//= require_self

ActiveScaffold.snapshot = function(selector_or_elements, parent) {
  function startVideo(element, videoConstraint) {
    var sayCheese = new SayCheese($element, {snapshots: true, video: videoConstraint});
    
    sayCheese.on('start', function() {
      $(this.video).data('saycheese', this);
      $(this.video).after($('<div>').addClass('snapshot'));
      this.video.play();
    });
    sayCheese.on('error', function(error) {
      var $alert = $('<div>');
      $alert.addClass('alert alert-error').css('margin-top', '20px');

      if (error === 'NOT_SUPPORTED') {
        $alert.html(element.data('video-not-supported'));
      } else if (error === 'AUDIO_NOT_SUPPORTED') {
        $alert.html(element.data('audio-not-supported'));
      } else {
        $alert.html(element.data('media-forbidden'));
      }

      $(this.video).before($alert);
    });
    sayCheese.on('snapshot', function(snapshot) {
      var img = document.createElement('img'), container = $(this.video).parent();
      $(img).on('load', function() { $('.snapshot', container).html(img); });
      img.src = snapshot.toDataURL('image/png');
    });

    sayCheese.start();
  }
  
  var elements;
  if (typeof(selector_or_elements) == 'string') elements = jQuery(selector_or_elements, parent);
  else elements = jQuery(selector_or_elements);

  elements.each(function() {
    var $element = $(this);
    MediaStreamTrack.getSources(function(sourceInfos) {
      var sources = [];
      for(i in sourceInfos) {
        var source = sourceInfos[i];
        if (source.kind == 'video') {
          console.log(source.id, source.label || 'camera ' + (sources.length + 1));
          $element.before($('<p>').html(source.label || 'camera ' + (sources.length + 1)));
          sources.push(source);
        }
      }
      var videoConstraint = sources.length == 0 ? true : {optional: [{sourceId: sources[sources.length-1].id}]};
      startVideo($element, videoConstraint);
    });
  });
};

jQuery(document).ready(function($) {
  $(document).on('click', '.active-scaffold .snapshot video', function() {
    $(this).data('saycheese').takeSnapshot();
  });
  $(document).on('as:action_success', 'a.as_action', function(e, action_link) {
    var pads = $('.snapshot', action_link.adapter);
    if (pads.length) ActiveScaffold.snapshot(pads);
  });
  $(document).on('as:element_updated', function(e) {
    var pads = $('.snapshot', e.target);
    if (pads.length) ActiveScaffold.snapshot(pads);
  });
  var pads = $('.snapshot');
  if (pads.length) ActiveScaffold.snapshot(pads);
});
