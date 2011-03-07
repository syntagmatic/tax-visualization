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
    typeString = type[typeName]
    taxes[typeName] = {}
    return typeString

  getData = (api, key) ->
    Ajax.get(api, (data) ->
      xml = data
      if typeof data == 'string'
        xml = stringToXml(data)
      window.items = xml.getElementsByTagName('item')
      mapTaxes(xml.getElementsByTagName('item'), key)
      #$(window).trigger 'got_items'
      print 'Done.'
    )
 
  window.getTaxes = (typeName, params) ->
    print 'Loading taxes...'
    base = "http://www.whatwepayfor.com/api/"
    if !type[typeName]
      typeName = "budgetAccount"
    api  = base + setType(typeName) + setParams(params)
    getData(api, typeName)
    print '...'

  window.getAllTaxes = (params) ->
    print 'Loading all taxes, please wait...'
    base = "http://www.whatwepayfor.com/api/"
    for key in _.keys(type)
      api  = base + setType(key) + setParams(params)
      getData(api, key)
    print '...'

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

  nabItem = (method, account, attribute) ->
    return items.item(account).attributes.item(attribute)[method]

  mapTaxes = (items, typeName) ->
    # Converts the xml to json object
    print 'mapping ' + typeName
    taxes[typeName] = []
    for item, i in items
      obj = {}
      for a in [0...numItemAttributes i]
          obj[nabItem('name',i,a)] = nabItem('value',i,a)
      taxes[typeName].push obj

  numItemAttributes = (account) ->
    return items.item(account).attributes.length

  numAttributes = (type) ->
    return _.size(taxes[type][0])

  window.showTaxes = (type) ->
    str = "<table>" + getItemHeader(type)
    for i in [0...numAttributes(type)]
      str += getItemRow(type, i)
    str += "</table>"
    printTaxes str

  getItemRow = (type, i) ->
    str = "<tr>"
    for value in _.values(taxes[type][i])
      str += "<td>" + value + "</td>"
    str += "</tr>"
    return str

  getItemHeader = (type) ->
    str = "<tr>"
    for key in _.keys(taxes[type][0])
      str += "<th>" + key + "</th>"
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
