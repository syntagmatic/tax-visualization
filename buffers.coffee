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

  window.spiral = (n) ->

    posx = (x) -> 600 + 9*i*sin(pi/12*i)
    posy = (x) -> 500 + 9*i*cos(pi/12*i)
    size = (x) -> x/2 + 1

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
    ox = 400            # x of origin
    oy = 400            # y of origin

    num = (max-min) / inc
    points = []
    point = (x,y) -> circle(x,y,3)
    for i in [0..num]
      x = (inc*i + min)
      y = eq x
      points.push point(x*(width/num/inc) + ox, y*zoom + oy)
    
    points.attr
      fill: "#999"
      stroke: "#999"
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
  $(window).bind "resize", ->
    $('#output').css 'max-height': $(window).height() - 130
    paper.setSize $('#canvas').width(), $('#canvas').height()
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
        print "# Splatter canvas with circles"
        print "splat 50 "
        print "# Make a spiral"
        print "spiral 75 "
        print "# Clear the canvas"
        print "clear()"
        print "grid(40)"
        print "c = circle(200,200,50).fill('lavender')"
        print "c.draggable()"
      when 'functions'
        print "f = (x,y) -> x*y"
        print "f(2,3)"
        print "f 2,3"
      when 'navigation'
        print "# Mouse wheel to zoom."
        print "# Grab background to pan."
        print "# Drag and drop to move shapes."
