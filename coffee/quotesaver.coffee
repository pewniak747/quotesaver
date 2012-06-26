App =
  getQuote: =>
    App.renderLoader()
    $.getJSON "/quote.json", App.setQuote
  fetchQuote: (key)=>
    App.renderLoader()
    $.getJSON "/#{key}.json", App.setQuote
  setQuote: (quote)=>
    if history? && history.pushState?
      history.pushState(quote, "Quote", "/#{quote.key}")
    App.renderQuote(quote)
  renderQuote: (quote)=>
    $('#quote').html(JST['quote'](quote))
    $('#actions').html(JST['actions'](quote))
    $(window).trigger 'resize'
  renderLoader: =>
    $('#quote').html(JST['loader']())
    $(window).trigger 'resize'

_.templateSettings =
  interpolate : /\{\{(.+?)\}\}/g
  evaluate : /\{\#(.+?)\#\}/g

JST =
  quote: _.template '''
      <blockquote id='content'>{{content}}</blockquote>
      <div id='author'>{{author}}</div>
    '''
  actions: _.template '''
      {# if(tweet_url != null) { #}
      <a href='{{tweet_url}}' id='tweet' target='_new'>tweet it</a>
      |
      {# }; #}
      <a href='/' id='next'>next quote</a>
    '''
  loader: _.template '''
      <div id="loader"></div>
    '''

window.App = App
window.JST = JST

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
