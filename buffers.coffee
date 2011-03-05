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

  window.help = ->
    print "This is Raffi, a data visualization prototyping suite built in CoffeeScript and Raphael. Click the tutorial to learn more.  Try entering these lines into the console:"
    print "- - - - - - - -"
    print "- - Drawing - -"
    print "- - - - - - - -"
    print "c = circle(200,200,50).fill('lavender')"
    print "c.draggable()"
    print "grid(40)"
    print "splat(50)"
    print "clear()"
    print "spiral(75)"
    print "- - - - - - - - -"
    print "- - Functions - -"
    print "- - - - - - - - -"
    print "f = (x,y) -> x*y"
    print "f(2,3)"
    print "f 2,3"

  # Data Vis Competition
  window.paramDefaults =
    year: 2010     # 1984 - 2015
    type: 0        # 0 - 3
    sortdir: false
    income: 5000000
    filing: 0      # 0 - 4
    budgetGroup: ["agency", "bureau", "function", "subfunction"]
    receiptGroup: ["agency", "bureau", "category", "subcategory"]
    showChange: 0
    showExtra: 0
    function: 0
    subfunction: 0
    category: 0
    subcategory: 0
  
  query = (key, val, counter) ->
    if counter is 0
      return "?#{key}=#{val}"
    else
      return "&#{key}=#{val}"

  type =
    budgetAccount: "getBudgetAccount/"
    budgetTotal: "getBudgetAggregate/"
    receiptAccount: "getReceiptAccount/"
    receiptTotal: "getReceiptAggregate/"
    population: "getPopulation/"

  setParams = (params) ->
    paramString = ""
    i = 0
    for key, val of params
      paramString += query(key, val, i)
      i++
    if !params? #default calls year
      paramString += query("year", "2010", 0)
    return paramString

  setType = (typeName) ->
    typeString = ""
    if type[typeName]
      typeString = type[typeName]
    else #default calls budget account
      typeString = type["budgetAccount"]
    return typeString

  window.getTaxes = (typeName, params) ->
    base = "http://www.whatwepayfor.com/api/"
    api  = base + setType(typeName) + setParams(params)
    Ajax.get(api, success)
    
  success = (data) ->
    print 'got items!'
    xml = data
    if typeof data == 'string'
      xml = stringToXml(data)
    window.items = xml.getElementsByTagName('item')
    $(window).trigger 'got_items'

  window.nab = (method, account, attribute) ->
    return items.item(account).attributes.item(attribute)[method]

  methods = (account, attribute) ->
    return items.item(account).attributes.item(attribute)

  window.numAttributes = (account) ->
    return items.item(account).attributes.length

  window.showTaxes = ->
    if (items?)
      str = "<table>" + getItemHeader 0
      for item, i in items
        str += getItemRow i
      str += "</table>"
      printTaxes str
    else
      print "items is not defined.  Please run getTaxes()"

  getItemRow = (x) ->
    str = "<tr>"
    for i in [0...numAttributes x]
      str += "<td>" + nab('value', x, i) + "</td>"
    str += "</tr>"
    return str

  getItemHeader = (x) ->
    str = "<tr>"
    for i in [0...numAttributes x]
      str += "<th>" + nab('name', x, i) + "</th>"
    str += "</tr>"
    return str

  printTaxes = (str) ->
    $('#tables').html str
    if !($('#tables').is(':visible'))
      $('#tables').fadeToggle()
      $('#canvas').fadeToggle()

  $(window).bind 'got_items', ->
    showTaxes()
  
  window.expose = (x) ->
    str = ""
    for i in [0..12]
      str += "<b>" + nab('name', x, i) + "</b>: " + nab('value', x, i) + "<br/>"
    $('#tables').html str

  #data object
  window.taxes =
    budgetAccount:
      year: 2010
      income: 50000
      exacttax: 0
      function: 0
      subfunction: 0
      agency: 0
      bureau: 0
      account: 0
      functionId: 1000
      subfunctionId: 1000
      agencyId: 1000
      bureauId: 1000
      accountId: 1000
      adjustInflationYear: 2010
      type: 0
      sortby: 0
      sortdir: 0
      filing: 0
      selfEmployed: 0
      showExtra: 0
      showChange: 0
      spendingType: 1
      onBudget: true
      total: 0
      deltaTotal: 0
      deltaPercent: 0
      myCost: 0
      perCapita: 0
      gdpPercent: 0
    budgetAggregate:
      group:
        function:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
        subfunction:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
        agency:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
        bureau:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
      year: 2010
      income: 50000
      exacttax: 0
      function: 0
      subfunction: 0
      agency: 0
      bureau: 0
      account: 0
      functionId: 1000
      subfunctionId: 1000
      agencyId: 1000
      bureauId: 1000
      accountId: 1000
      adjustInflationYear: 2010
      type: 0
      sortby: 0
      sortdir: 0
      filing: 0
      selfEmployed: 0
      showExtra: 0
      showChange: 0
      spendingType: 1
      onBudget: true
      total: 0
      deltaTotal: 0
      deltaPercent: 0
      myCost: 0
      perCapita: 0
      gdpPercent: 0
    receiptAccount:
      year: 2010
      exacttax: 0
      category: 0
      subcategory: 0
      agency: 0
      bureau: 0
      account: 0
      categoryId: 1000
      subcategoryId: 1000
      agencyId: 1000
      bureauId: 1000
      accountId: 1000
      adjustInflationYear: 2010
      type: 0
      sortby: 0
      sortdir: 0
      filing: 0
      selfEmployed: 0
      showExtra: 0
      showChange: 0
      spendingType: 1
      onBudget: true
      total: 0
      deltaTotal: 0
      deltaPercent: 0
      myCost: 0
      perCapita: 0
      gdpPercent: 0
    receiptAggregate:
      group:
        category:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
        subcategory:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
        agency:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
        bureau:
          dimensionName: ""
          dimensionId: 0
          spendingType: 0
          total: 0
          deltaTotal: 0
          deltaPercent: 0
          myCost: 0
      year: 2010
      exacttax: 0
      category: 0
      subcategory: 0
      agency: 0
      bureau: 0
      account: 0
      categoryId: 1000
      subcategoryId: 1000
      agencyId: 1000
      bureauId: 1000
      accountId: 1000
      adjustInflationYear: 2010
      type: 0
      sortby: 0
      sortdir: 0
      filing: 0
      selfEmployed: 0
      showExtra: 0
      showChange: 0
      spendingType: 1
      onBudget: true
      total: 0
      deltaTotal: 0
      deltaPercent: 0
      myCost: 0
      perCapita: 0
      gdpPercent: 0
