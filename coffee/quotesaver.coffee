window.App =
  initialize: ->
    _.templateSettings =
      interpolate : /\{\{(.+?)\}\}/g
      evaluate : /\{\#(.+?)\#\}/g
    @template = _.template '''
        <div id='mark'>&ldquo;</div>
        <blockquote id='content'>{{quote}}</blockquote>
        <div id='author'>{{author}}</div>
        <div id='actions'>
          {# if(typeof(tweet)!='undefined') { #}
          <a href='{{tweet}}' id='tweet' target='_new'>tweet it</a>
          |
          {# }; #}
          <a href='/' id='next'>next quote</a>
        </div>
      '''
  getQuote: =>
    $.ajax 'quote.json', dataType: 'json', success: (response) =>
      $('#quote').html(App.template(response))
      $(window).trigger 'resize'

$(document).ready ->
  $(window).resize ->
    $('#quote').css('top', $(window).height()/2 - $('#quote').outerHeight()/2)
  .resize()
  $('#quote').hover ->
    $('#actions').fadeIn('fast')
  , -> $('#actions').fadeOut('fast')
  $('#next').live 'click', (e)->
    e.preventDefault()
    App.getQuote()
  
  App.initialize()
