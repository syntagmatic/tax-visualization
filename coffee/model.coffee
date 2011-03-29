$ ->

  # shapes

  Rect = Backbone.Model.extend
    defaults:
      'x': 100
      'y': 100
      'width': 50
      'height': 50
      'r': 5
      'fill': '#6b6'
      'fill-opacity': 0.7
      'stroke': '#666'
      'stroke-width': 1
      'stroke-opacity': 1
      'cursor': 'auto'

  RectList = Backbone.Collection.extend
    model: Rect
    localStorage: new Store("rects")

  window.rects = new RectList

  # tools

  MorphTool = Backbone.Model.extend
    defaults:
      x: 0
      y: 0
      visible: false
    display: (x, y) ->
      @set visible: true
      @render(x,y)
    render: (x, y) ->
      paper.path(this.icon).translate(x,y).attr
        'stroke': 'yellow'
        'stroke-width': 3

  Resizer = MorphTool.extend
    icon: icon.resize
        
  Rotator = MorphTool.extend
    icon: icon.rotate

  Translator = MorphTool.extend
    icon: icon.translate
      
  window.resizer = new Resizer
  window.rotator = new Rotator
  window.translator = new Translator

  window.RectView = Backbone.View.extend
    events:
      'click this': 'select'
    initialize: ->
      this.model.view = this
      this.object = paper.rect().attr(this.model.toJSON())
      this.object.click =>
        this.select(this)
    alter: (key, value)->
      attr= {}
      attr[key] = value
      this.model.set attr
      this.object.attr attr
      return this
    select: (that) ->
      Dashboard.select(that.model)

  window.DashboardView = Backbone.View.extend
    el: $("#dashboard")
    inputTemplate: _.template($('#input-element').html())
    sliderTemplate: _.template($('#slider-element').html())
    select: (model) ->
      @selected = model

      attrs = model.toJSON()
      html = ""
      for key, value of attrs
        if typeof value is 'number'
          if key in ['fill-opacity', 'stroke-opacity']
            max = 1
            step = 0.02
          else if key is 'r'
            max = _([attrs.width, attrs.height]).max() / 2
            step = 0.5
          else if key is 'stroke-width'
            max = _([attrs.width, attrs.height]).max()
            step = 0.5
          else
            max = 500
            step = 1
          html += this.sliderTemplate({key:key,value:value,max:max,step:step})
        else
          html += this.inputTemplate({key:key,value:value})

      x = @selected.get "x"
      y = @selected.get "y"
      width = @selected.get "width"
      height = @selected.get "height"
      resizer.display(x+width, y+height)
      rotator.display(x+width, y)
      translator.display(x+width/2-5, y+height/2-5)

      @$('.props').html(html)
      @.$('.props input[type=text]').change () ->
        key = $(this).attr('name')
        value = $(this).val()
        model.view.alter key, value
      @$('.props input[type=range]').change () ->
        key = $(this).attr('name')
        value = parseFloat $(this).val()
        model.view.alter key, value

  window.Dashboard = new DashboardView

  window.rect  = (x,y,w,h,r) ->
    rect = rects.create
      x : x
      y : y
      width : w
      height : h
      r : r
    new RectView model : rect
