window.App =
  initialize: ->
    _.templateSettings =
      interpolate : /\{\{(.+?)\}\}/g
      evaluate : /\{\#(.+?)\#\}/g
    @template = _.template '''
        <blockquote id='content'>{{content}}</blockquote>
        <div id='author'>{{author}}</div>
      '''
    @actions_template = _.template '''
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
      $('#actions').replaceWith(App.actions_template(response))
      $(window).trigger 'resize'

$(document).ready ->
  $(window).resize ->
    $('#quote').css('top', $(window).height()/2 - $('#quote').outerHeight()/2)
  .resize()
  $('#next').live 'click', (e)->
    e.preventDefault()
    App.getQuote()

  App.initialize()
