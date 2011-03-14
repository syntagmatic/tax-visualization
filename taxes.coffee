$ ->
  #data object
  window.taxes = {}
  window.apis = {}
  $(window).bind 'got_items', ->
    showTaxes()
  
  # Data Vis Competition
  window.paramDefaults =
    year: [1984..2015]
    type: [0..3]
    sortby: [0..3] #don't care about this yet
    sortdir: false #don't care about this yet
    income: 5000000
    filing: [0..4]
    budgetGroup: ["agency", "bureau", "function", "subfunction"]
    receiptGroup: ["agency", "bureau", "category", "subcategory"]
    showChange: 0
    showExtra: 0
  
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

  query = (key, val, counter) ->
    if counter is 0
      return "?#{key}=#{val}"
    else
      return "&#{key}=#{val}"

  setParams = (params) ->
    paramString = ""
    i = 0
    for key, val of params
      paramString += query(key, val, i)
      i++
    if not params? #default calls year
      paramString += query("year", "2010", 0)
    else if not _.include(_.keys(params), "year") #if year was not included
      paramString += query("year", "2010", 1)
    return paramString

  setType = (typeName) ->
    typeString = type[typeName]
    taxes.type = typeName
    taxes[typeName] = {}
    return typeString

  getData = (api, key, show) ->
    Ajax.get(api, (data) ->
      xml = data
      if typeof data == 'string'
        xml = stringToXml(data)
      window.items = xml.getElementsByTagName('item')
      mapTaxes(xml.getElementsByTagName('item'), key)
      if (show)
        $(window).trigger 'got_items'
      print 'Done.'
    )
 
  paramList = (paramName, base, typeKey) ->
    #Returns api call for each value of parameter
    #assumes no parameters have been specified from console
    print paramName
    for i in paramDefaults[paramName]
      print 'key: ' + i
      params = {}
      if paramName in ["budgetGroup", "receiptGroup"]
        #special case for totals
        paramName = "group"
      params[paramName] = i
      apiString = base + setType(typeKey) + setParams(params)
      params = undefined
      return apiString
 
  getVariedParams = ->
    for i of variedParams
      paramList i

  window.getTaxes = (typeName, params) ->
    print 'Loading taxes...'
    base = "http://www.whatwepayfor.com/api/"
    if !type[typeName]
      typeName = "budgetAccount"
    api  = base + setType(typeName) + setParams(params)
    getData(api, typeName, true)
    print '...'

  window.getAllTaxes = (params) ->
    print 'Loading all taxes, please wait...'
    base = "http://www.whatwepayfor.com/api/"
    for typeKey in _.keys(type)
      if (typeKey is "budgetTotal")
        #For totals, group object has specific name
        apiString = paramList("budgetGroup", base, typeKey)
        print 'bT: ' + apiString
        apis[apiString] = typeKey
      ###
      else if (typeKey is "receiptTotal")
        #For totals, group object has specific name
        apiString = paramList("receiptGroup", base, typeKey)
        print 'rT: ' + apiString
        apis[apiString] = typeKey
      else if (typeKey is "taxRates")
        apiString = paramList("type", base, typeKey)
        print 'tR: ' + apiString
        apis[apiString] = typeKey
      else
        #population, gdp, debt, inflation
        apiString = base + setType(typeKey) + setParams(params)
        apis[apiString] = typeKey
      ###
    #for key, val of apis
    #  print key
    #  getData(key, val, false)
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
    if not taxes[typeName][0]?
      taxes[typeName] = []
      print 'mapping ' + typeName
    #TODO: map totals with subobjects
    for item, i in items
      obj = {}
      for a in [0...numItemAttributes i]
          obj[nabItem('name',i,a)] = nabItem('value',i,a)
      taxes[typeName].push obj

  numItemAttributes = (account) ->
    return items.item(account).attributes.length

  numAttributes = (type) ->
    return _.size(type)

  window.showTaxes = (typeObj) ->
    if (_.isUndefined(typeObj))
      # showTaxes works for allTaxes or specific calls
      typeObj = taxes.type
    str = "<table>" + getItemHeader(typeObj)
    for i in [0...numAttributes(typeObj)]
      str += getItemRow(typeObj, i)
    str += "</table>"
    printTaxes str

  getItemRow = (type, i) ->
    str = "<tr>"
    for value in _.values(type[i])
      str += "<td>" + value + "</td>"
    str += "</tr>"
    return str

  getItemHeader = (type) ->
    str = "<tr>"
    for key in _.keys(type[0])
      str += "<th>" + key + "</th>"
    str += "</tr>"
    return str

  printTaxes = (str) ->
    $('#tables').html str
    if !($('#tables').is(':visible'))
      $('#tables').fadeToggle()
      $('#canvas').fadeToggle()

  window.getColumn = (typeObj, attr) ->
    # This outputs a list for graphing
    col = []
    for i of typeObj
      col.push typeObj[i][attr]
    return col
