$ ->
  pageName = $("body").data("page")
  pusherKey = $("body").data("pusher-key")

  window.pusher = new Pusher(pusherKey)
  pageClass = window.stringToFunction("Pairtrix.#{pageName}")

  if pageClass isnt undefined
    loader = new pageClass
    loader.init()

  $(".datepicker").datepicker autoclose: true

  # display the loading graphic during ajax requests
  $("#loading").ajaxStart(->
    $(this).show()
  ).ajaxStop ->
    $(this).hide()

  # make sure we accept javascript for ajax requests
  jQuery.ajaxSetup beforeSend: (xhr) ->
    xhr.setRequestHeader "Accept", "text/javascript"

  Array::shuffle = ->
  i = @length
  j = undefined
  tempi = undefined
  tempj = undefined
  return false  if i is 0
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tempi = this[i]
    tempj = this[j]
    this[i] = tempj
    this[j] = tempi
  this
