$ ->
  # Example graphics
  window.splat = (n) ->

    square = (x) -> pow(x,2)
    cube = (x) -> pow(x,3)
    pos  = -> 400 + cube (15*(random()-0.5))
    size = -> square 4.5*random()

    circles = set()
    for i in [1..n]
      circles.push circle(pos(),pos(),size())
      .attr
        fill: color = getColor()
        opacity: 0.6
        "stroke": "#333"
        "stroke-width": 1
        "stroke-opacity": 0

    circles.mouseover ->
      this.attr
        "stroke-opacity": 1
        opacity:0.85
        cursor: "pointer"
        scale: 1.5
    circles.mouseout ->
      this.anim
        "stroke-opacity": 0
        opacity:0.6
        cursor: "pointer"
        duration: 180
        scale: 1
    "Splat!"

  window.punchcard = (width, height) ->
    for i in [1..width]
      for j in [1..height]
        circle(32*i,32*j,3).bubble pow(5.2*random(),2)
    "Take that, card!"

  window.spiral = (n, x=600, y=500) ->
    posx = (i) -> x + 9*i*sin(pi/12*i)
    posy = (i) -> y + 9*i*cos(pi/12*i)
    size = (i) -> i/2 + 1

    circles = set()
    for i in [1..n]
      circles.push circle(posx(i),posy(i),size(i))
      .attr
        fill: color = getColor()
        opacity: 0.6
        "stroke": "#333"
        "stroke-width": 1
        "stroke-opacity": 0
    "Far out!"

  window.network = ->
    for i in [1..10]
      for j in [1..10]
        shape 60*i, 60*j, 20, 20

    for _ in [1..30]
      x = round 99*random()
      y = round 99*random()
      link x, y
    "Click around for glitchy fun!"

  typeColor = (object) ->
    if (type object) is 'number'
      return '#185273'
    if (type object) is 'function'
      return '#5E781D'
    if (type object) is 'object'
      return '#DBAD3B'
    if (type object) is 'array'
      return '#9D7B8C'
    if (type object) is 'string'
      return '#D13535'
    if (type object) is 'element'
      return '#FF8C4C'
    else
      return '#444'
    
  typeGo = (object) ->
    # used to enter javascript into the console from elsewhere
    # this is all quite hacky
    if (type object) is 'array'
      return go '[' + object + ']'
    if (type object) is 'number'
      return go object
    if (type object) is 'string'
      return go ['"', object, '"'].join("")
    if (type object) is 'function'
      # this "ans =" is ugly, but gives proper behavior
      return go ["ans = ", object.toString()].join("")
    if (type object) is 'object'
      # see all key/values, instead of plain [object Object]
      str = "{"
      for key, value of object
        str += "#{key}: '#{value}', "
      str = str.substring(0, str.length-2)
      str += "}"
      return go str, 'coffee'
    else
      return print object

  objecty = (name, value, x, y, height, boxContainer) ->
    color = typeColor value
    shape(x, y, 130, height, color)
    text(x+65, y+15, name).attr
      'font-size': 14
      'fill': '#fff'
    text(x+65, y+35, type value)
      .attr
        'font-size': 14
        'fill': color
        'cursor': 'pointer'
      .click ->
        typeGo value

  window.classy = (name, obj={}, opts={}) ->
    length = _(obj).keys().length

    x = opts.x || 50
    y = opts.y || 50
    boxHeight = opts.boxHeight || 50
    padding = opts.padding || 10

    boxContainer = (boxHeight+2*padding)

    # heading
    paper.rect( x, y, 150, 24+boxContainer*length, 12).attr
      fill: "#222"
      stroke: "#333"
    text(x+75, y+12, name).attr
      'font-size': 14
      'fill': '#fff'

    # each property
    i = 0
    for key, value of obj
      objecty(key, value, x+padding, y+28+boxContainer*i, boxHeight, boxContainer)
      i++
    name

  window.chart = ->
    values = []
    dotsy = []
    clr = []
    c = path("M0,0").attr
      fill: "none"
      "stroke-width": 3

    for i in [0..12]
      values[i] = randomPath(30, i, dotsy)
      clr[i] = Raphael.getColor()
      c.attr({path: values[i], stroke: clr[i]})
    print "A random path"
    c

  window.equation = ->

    eq = (x) -> sin(x)  # equation
    min = 0             # minimum
    max = 4*pi          # maximum
    inc = pi/24         # increment size
    width = 600         # window width
    zoom = 120          # amplitude multiplier
    ox = 100            # x of origin
    oy = 400            # y of origin

    num = (max-min) / inc
    points = set()
    point = (x,y) -> circle(x,y,3)
    for i in [0..num]
      x = (inc*i + min)
      y = eq x
      points.push point(x*(width/num/inc) + ox, y*zoom + oy)
    
    points.attr
      fill: getColor()
      stroke: 0
    "A sinusoid"
  
  
  # Buttons
  flipper = (button, showmsg, hidemsg, panels...) ->
    $(button).toggle( ->
      $(this).html hidemsg
      for panel in panels
        $(panel).fadeToggle()
    , ->
      $(this).html showmsg
      for panel in panels
        $(panel).fadeToggle()
    )

  flipper("#show",
          "Code",
          "Hide Code",
          "#code")
  flipper("#cons",
          "Console",
          "Hide Console",
          "#console")
  flipper("#tut",
          "Tutorial",
          "Hide Tutorial",
          "#tutorial")
  flipper("#out",
          "Output",
          "Hide Output",
          "#canvas")
  flipper("#worlds",
          "Toggle World",
          "Toggle World",
          "#tables", "#canvas")

  # Resize Hacks
  $('#output').css 'max-height': $(window).height() - 130
  $(window).bind "resize", ->
    $('#output').css 'max-height': $(window).height() - 130
    $('#canvas > svg').width($('#canvas').width()).height($('#canvas').height())
  # End hacks

  window.help = (chapter = 'help') ->
    switch chapter
      when 'help'
        print "# This is Raffi:"
        print "# Data visualization in"
        print "# CoffeeScript and Raphael."
        print "# "
        print "# Built by Kai Chang and Mary Becica"
        print "# "
        print "# Click the tutorial to learn more.  Or type:"
        print "# "
        print "help 'examples'"
        print "help 'functions'"
        print "help 'navigation'"
      when 'examples'
        print "circle(200,200,50).fill('lavender')"
        print "splat 50 "
        print "clear()"
        print "spiral 75 "
        print "punchcard 20, 20"
        print "network()"
        print "grid 40"
      when 'functions'
        print "f = (x,y) -> x*y"
        print "f(2,3)"
        print "f 2,3"
      when 'navigation'
        print "# Mouse wheel to zoom."
        print "# Grab background to pan."
        #print "# Drag and drop to move shapes."
