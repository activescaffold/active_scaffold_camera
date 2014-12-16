//= require say-cheese
//= require_self

ActiveScaffold.snapshot = function(selector_or_elements, parent) {
  function startVideo(element, videoConstraint) {
    var sayCheese = new SayCheese(element, {snapshots: true, video: videoConstraint});
    
    sayCheese.on('start', function() {
      $(this.video).data('saycheese', this);
      $(this.video).after($('<div>').addClass('snapshot'));
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
      startVideo('#' + $element.attr('id'), videoConstraint);
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
