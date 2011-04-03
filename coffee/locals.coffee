do ->
  paper = Raphael("canvas", $('#canvas').width(), $('#canvas').height())
  window.zpd = new RaphaelZPD(paper, { zoom: true, pan: true, drag: true})
  paper.ZPDPanTo 360, 0
  window.paper = paper
  width = "100%"
  height = "100%"
  Raphael.getColor.reset()
  cwidth = $('#canvas').width()
  cheight = $('#canvas').height()

  # math
  window.abs = Math.abs
  window.acos = Math.acos
  window.asin = Math.asin
  window.atan = Math.atan
  window.ceil = Math.ceil
  window.cos = Math.cos
  window.exp = Math.exp
  window.floor = Math.floor
  window.log = Math.log
  window.max = Math.max
  window.min = Math.min
  window.pi = Math.PI
  window.pow = Math.pow
  window.random = Math.random
  window.round = Math.round
  window.sin = Math.sin
  window.sqrt = Math.sqrt
  window.tan = Math.tan

  # jquery
  window.background = (color) -> $('body').css {background: color}

  # underscore
  window.type = (object) ->
    if _.isArray(object)
      return "array"
    if _.isElement(object)
      return "element"
    if _.isNull(object)
      return "null"
    if _.isNaN(object)
      return "NaN"
    if _.isDate(object)
      return "date"
    if _.isArguments(object)
      return "arguments"
    if _.isRegExp(object)
      return "RegExp"
    else
      return typeof object

  # raphael
  window.circle = (x,y,r) ->
    paper.circle(x,y,r)
# window.rect = (x,y,w,h,r) ->
#   paper.rect(x,y,w,h,r)
  window.ellipse = (x,y,rx,ry) ->
    paper.ellipse(x,y,rx,ry)
  window.image = (url,x,y,w,h) ->
    paper.image(url, x, y, w, h)
  window.text = (x,y,str) ->
    paper.text(x,y,str)
  window.path = (str) ->
    paper.path(str)
  window.getColor = -> Raphael.getColor()
  window.set = -> paper.set()
  window.clear = -> paper.clear()

  # connect shapes
  window.shape = paper.createShape
  window.link = paper.createConn

  # axis, tics, labels
  window.axis = (width,height,ticwidth) ->
    if (width == "100%")
      width = cwidth
    if (height == "100%")
      height = cheight
    axis = set()
    grid = set()
    labels = set()
    o = [ticwidth, height-ticwidth]
    ox = [width-ticwidth, ticwidth]
    axis.push path "M" + o[0] + " " + o[1] + "L" + ox[0] + " " + o[1] 
    axis.push path "M" + o[0] + " " + o[1] + "L" + o[0] + " " + o[0] 
    tic = (x,y,w,h) ->
      p1 = [x, y]
      p2 = [x-w, y+h]
      path "M" + p1[0] + " " + p1[1] + "L" + p2[0] + " " + p2[1]
    xtics = set()
    ytics = set()
    xmarks = Math.ceil( width / ticwidth)
    ymarks = Math.ceil( height / ticwidth)
    for i in [1..xmarks]
      inc= i * ticwidth
      grid.push path "M" + inc + " 0L" + inc + " " + height
    for i in [1..ymarks]
      inc= i * ticwidth
      grid.push path "M0 " + inc + "L" + width + " " + inc
    for i in [0..xmarks-3]
      inc= ticwidth+i*ticwidth
      if i % 2 == 1
        xtics.push tic(inc,height-ticwidth,0,8)
      else
        xtics.push tic(inc,height-ticwidth,0,12)
        labels.push text(inc,height-16,inc + "")
    for i in [0..ymarks-4]
      inc= ticwidth+i*ticwidth
      if i % 2 == 1
        ytics.push tic(ticwidth,height-inc,8,0)
      else
        ytics.push tic(ticwidth,height-inc,12,0)
        labels.push text(14,height-inc,inc + "")
    axis.push xtics
    axis.push ytics

    # axis defaults
    axis.attr
      stroke: "#444"
      opacity: 0
    grid.attr stroke: "#272727"
    labels.attr stroke: "#888"
    
    return { axis, grid, labels }
  
  # full width grid
  window.grid = (ticwidth) ->
    return axis "100%", "100%", ticwidth

  attrs = ['cursor', 'cx', 'cy', 'fill', 'font', 'height',
           'href', 'opacity', 'path', 'r', 'rotation', 'rx', 'ry',
           'src', 'stroke', 'target', 'title', 'translation', 'width',
           'x', 'y']

  attrs2 = ['clip-rect', 'fill-opacity', 'font-family', 'font-size',
            'font-weight', 'stroke-dasharray', 'stroke-linecap',
            'stroke-linejoin', 'stroke-miterlimit', 'stroke-opacity',
            'text-anchor']

  toCamel = (str)->
    str.replace(/(\-[a-z])/g, `function($1){return $1.toUpperCase().replace('-','');}`)

  # shorthand for changing attributes
  #    circle(25,25,5).fill("red")
  for attr in attrs
    do (attr) ->
      Raphael.el[attr] = (value) ->
        obj = {}
        obj[attr] = value
        this.attr obj

  for attr in attrs2
    do (attr) ->
      attr = toCamel attr
      Raphael.el[attr] = (value) ->
        obj = {}
        obj[attr] = value
        this.attr obj
  
  # basic drag and drop
  # not needed with raphael-zpd plugin
  start = ->
    # storing original coordinates
    this.ox = this.attr("cx")
    this.oy = this.attr("cy")
  move = (dx, dy) ->
    # this is not quite right-- but getting closer
    zoom = log(zoomCurrent)/log(2)
    neg_zoom = log(-zoomCurrent)/log(2)
    if zoomCurrent > 0
      this.attr({cx: this.ox + dx/zoom, cy: this.oy + dy/zoom})
    else if zoomCurrent < 0
      this.attr({cx: this.ox + dx*neg_zoom, cy: this.oy + dy*neg_zoom})
    else
      this.attr({cx: this.ox + dx, cy: this.oy + dy})
  up = ->
    # restoring state
  Raphael.el.draggable = ->
    this.drag(move,start,up)

  window.draggable = (object) ->
    object.drag(move,start,up)
  
  # associates size with color
  # for bubble charts, takes values 0-32
  Raphael.el.bubble = (value) ->
    red = 8*(32-value)
    green = 8*value
    this.attr
      r: value/2
      fill: "rgb(#{red}, #{green}, 0)"
      stroke: 0

randomPath = (length, j, dotsy) ->
  random_path = ""
  x = 10
  y = 0
  dotsy[j] = dotsy[j] || []
  for i in [0..length]
    dotsy[j][i] = round(random() * 200)
    if (i)
      random_path += "C" + [x + 10, y, (x += 20) - 10, (y = 240 - dotsy[j][i]), x, y]
    else
      random_path += "M" + [10, (y = 240 - dotsy[j][i])]
  return random_path
