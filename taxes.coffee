$ ->
  #data object
  window.taxes = {}
  
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
    inflation: "getInflation/"
    gdp: "getGDP/"
    debt: "getDebt/"
    taxRates: "getTaxRates/"

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
      taxes.type = typeName
      taxes[typeName] = {}
    else #default calls budget account
      typeString = type["budgetAccount"]
      taxes.type = "budgetAccount"
      taxes.budgetAccount = {}
    return typeString

  getType = ->
    return taxes.type
  
  window.getTaxes = (typeName, params) ->
    print 'Loading taxes...'
    base = "http://www.whatwepayfor.com/api/"
    api  = base + setType(typeName) + setParams(params)
    Ajax.get(api, success)
    print '...'
   
  success = (data) ->
    xml = data
    if typeof data == 'string'
      xml = stringToXml(data)
    window.items = xml.getElementsByTagName('item')
    mapTaxes(items)
    $(window).trigger 'got_items'
    print 'Done.'

  # Shortcut functions
  window.getPopulation = (params) ->
    getTaxes("population", params)

  window.getInflation = (params) ->
    getTaxes("inflation", params)

  window.getGdp = (params) ->
    getTaxes("gdp", params)

  window.getDebt = (params) ->
    getTaxes("debt", params)

  window.getTaxRates = (params) ->
    getTaxes("taxRates", params)

  nab = (method, account, attribute) ->
    return items.item(account).attributes.item(attribute)[method]

  methods = (account, attribute) ->
    return items.item(account).attributes.item(attribute)

  mapTaxes = (items) ->
    # Converts the xml to json object
    typeString = taxes.type
    taxes[typeString] = []
    for item, i in items
      obj = {}
      for a in [0...numAttributes i]
          obj[nab('name',i,a)] = nab('value',i,a)
      taxes[typeString].push obj

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

    
