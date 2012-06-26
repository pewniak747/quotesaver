App =
  initialize: ->
    _.templateSettings =
      interpolate : /\{\{(.+?)\}\}/g
      evaluate : /\{\#(.+?)\#\}/g
    @template = _.template '''
        <blockquote id='content'>{{content}}</blockquote>
        <div id='author'>{{author}}</div>
      '''
    @actions_template = _.template '''
        {# if(tweet_url != null) { #}
        <a href='{{tweet_url}}' id='tweet' target='_new'>tweet it</a>
        |
        {# }; #}
        <a href='/' id='next'>next quote</a>
      '''
  getQuote: =>
    $.getJSON "/quote.json", App.setQuote
  fetchQuote: (key)=>
    $.getJSON "/#{key}.json", App.setQuote
  setQuote: (quote)=>
    if history? && history.pushState?
      history.pushState(quote, "Quote", "/#{quote.key}")
    App.renderQuote(quote)
  renderQuote: (quote)=>
    $('#quote').html(App.template(quote))
    $('#actions').html(App.actions_template(quote))
    $(window).trigger 'resize'

$(document).ready ->
  $(window).resize ->
    $('#quote').css('top', $(window).height()/2 - $('#quote').outerHeight()/2)
  .resize()
  $('#next').live 'click', (e)->
    e.preventDefault()
    App.getQuote()
  if window.location.pathname != '/'
    App.fetchQuote(window.location.pathname[1..-1])
  window.onpopstate = (event)=>
    App.renderQuote(event.state) if event.state?

  App.initialize()
