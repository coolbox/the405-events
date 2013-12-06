$ ->
  window.giftlist = new GiftList

class window.GiftList
  constructor: ->
    @gifts = new GLGift if @domContains '.gifts li'

  domContains: (selectors...)->
    all_match = true
    $.each selectors, (index, item) ->
      all_match = false if $(item).length is 0
    all_match

  domDoesntContain: (selectors...)->
    none_found = true
    $.each selectors, (index, item) ->
      none_found = false if $(item).length isnt 0
    none_found

class window.GLGift
  constructor:->
    @giftLinks   = $('a', 'ul.gifts')
    @bindVariables @giftLinks

  bindVariables: ->
    @giftLinks.on 'click', @actionClick

  actionClick: (event) =>
    event.preventDefault()
    link = $(event.currentTarget)
    url = link.attr('href')
    product_id = link.parent('li').data('gift')
    @incrementClicks product_id
    window.open(url,'_blank');

  incrementClicks: (product_id) ->
    $.post '/gift/clicks/increment.json',
      gift: 
        id: product_id
    .done (data) ->
      console.log data