$ ->

  #btn = document.getElementById "run"
  #js = document.getElementById "js"
  cd = document.getElementById "code"
  cl  = document.getElementById "clear"

  #btn.onclick = ->
  #  try
  #    coffee = CoffeeScript.compile cd.value
  #    new Function("paper", "window", "document", "paper.clear();" + coffee).call(paper, paper)
  #  catch e
  #    console.log(e.message || e)

  #js.onclick = ->
  #  try
  #    coffee = CoffeeScript.compile cd.value
  #    myWindow = window.open('','','width=600,height=600,scrollbars=yes')
  #    myWindow.document.write("<pre>" + coffee + "</pre>")
  #    myWindow.focus()
  #  catch e
  #    console.log(e.message || e)

  cl.onclick = ->
    if $('#tables').is(':visible')
      $('#tables').html ""
    else
      paper.clear()

  $(document).mousemove (e) ->
    $('#status').html(`e.pageX + ', ' + e.pageY`)
