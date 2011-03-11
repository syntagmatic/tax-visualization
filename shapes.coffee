window.shapes = []
window.conns = {}
window.dragged = false
window.selected = false

[Raphael.fn.createShape, Raphael.fn.createConn] = do ->

  # shapes

  createShape = (xpos=50,ypos=50,width=50,height=50) ->
    shapes.push this.rect(xpos, ypos, width, height, 3)
    newShape(shapes.length-1)

  selectShape = (i) ->
    selected = i
    shapes[i].animate({"fill-opacity": 0.9}, 500)

  deselectShape = (i) ->
    selected = false
    shapes[i].animate({"fill-opacity": 0.8}, 140)

  destroyShape = (i) ->
    # TODO

  newShape = (i) ->
    color = Raphael.getColor()
    shapes[i].attr
      "fill" : color
      "fill-opacity" : 0.8
      "stroke" : color
      "stroke-width" : 1
      "stroke-opacity" : 0.8
    shapes[i].node.style.cursor = "move"
    conns[i] = {}
  

  # connections

  selectConn = (a,b) ->
    if conns[a][b] is undefined
      createConn(a,b)
    else
      destroyConn(a,b)

  destroyConn = (a,b) ->
    conn = conns[a][b]
    connObj = shapes[conn]
    connObj.line.remove()
    delete conns[a][b]
    delete conns[b][a]

  syncConnections = (a) ->
    for b of conns[a]
      conn = conns[a][b]
      shapes[conn].line.remove()
      shapes[conn] = drawConn(shapes[a],shapes[b],"#eee")


  # links

  createConn = (a,b, connColor = "#eee") ->
    i = shapes.length
    shapes.push(drawConn(shapes[a],shapes[b],connColor))
    conns[a][b] = i
    conns[b][a] = i
    paper.safari()

  drawConn = (a, b, color) ->
    bb1 = a.getBBox()
    bb2 = b.getBBox()
    path = ["M", bb1.x+(bb1.width/2), bb1.y+(bb1.height/2),
            "L", bb2.x+(bb2.width/2), bb2.y+(bb2.height/2)].join(",")
    return {
      line: paper.path(path).attr
        stroke: color
        fill: "none"
        "stroke-width": 2
        "stroke-dasharray": "."
        "stroke-opacity":0.8
      from: a
      to: b
    }

  return [createShape, createConn]
