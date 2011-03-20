$ ->
  #data object
  window.taxes = {}
  window.apis = {}
  $(window).bind 'got_items', ->
    showTaxes()
  
  window.defaults =
    year: [1984..2015]
    type: [0..3]
    sortby: [0..3] #don't care about this yet
    sortdir: false #don't care about this yet
    income: 5000000 #can't deal with this yet
    filing: [0..3]
    budgetGroup: ["agency", "bureau", "function", "subfunction"]
    receiptGroup: ["agency", "bureau", "category", "subcategory"]
    showChange: 0
    showExtra: 0
 
  defaultAttribs =
    budgetAccount: ["year", "type", "filing"]
    budgetTotal: ["year", "type", "filing", "budgetGroup"]
    receiptAccount: ["year", "type", "filing"]
    receiptTotal: ["year", "type", "filing", "receiptGroup"]
    taxRates: ["year", "type"]
    population: ["year"]
    inflation: ["year"]
    gdp: ["year"]
    debt: ["year"]

  taxTypes =
    budgetAccount: "getBudgetAccount/"
  ###
    budgetTotal: "getBudgetAggregate/"
    receiptAccount: "getReceiptAccount/"
    receiptTotal: "getReceiptAggregate/"
    population: "getPopulation/"
    inflation: "getInflation/"
    gdp: "getGDP/"
    debt: "getDebt/"
    taxRates: "getTaxRates/"
  ###

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
    typeString = taxTypes[typeName]
    taxes.type = typeName
    taxes[typeName] = {}
    return typeString

  getData = (api, paramInfo, show) ->
    Ajax.get(api, (data) ->
      xml = data
      if typeof data == 'string'
        xml = stringToXml(data)
      window.items = xml.getElementsByTagName('item')
      mapTaxes(xml.getElementsByTagName('item'), paramInfo)
      if (show)
        $(window).trigger 'got_items'
      print 'Done.'
    )
 
  window.apiList = {}
  paramList = (paramNames, base, typeKey) ->
    #Generates a list of api url strings for each value of parameter
    #assumes no parameters have been specified from console
    for paramName in paramNames
      for i in defaults[paramName]
        params = {}
        if paramName in ["budgetGroup", "receiptGroup"]
          #special case for totals
          paramName = "group"
        if not apiList[paramName]?
          apiList[paramName] = []
        params[paramName] = i
        apiList[paramName].push base + setType(typeKey) + setParams(params)
        params = undefined
      # Here it is breaking; params are being remembered for incorrect apis
    return apiList
 
  getVariedParams = ->
    for i of variedParams
      paramList i

  window.getTaxes = (typeName, params) ->
    print 'Loading ' + typeName + '...'
    base = "http://www.whatwepayfor.com/api/"
    if !taxTypes[typeName]
      typeName = "budgetAccount"
    api  = base + setType(typeName) + setParams(params)
    getData(api, typeName, true)
    print '...'

  window.getAllTaxes = (params) ->
    #Get a data from a list of all api calls
    print 'Loading all taxes, please wait...'
    base = "http://www.whatwepayfor.com/api/"
    i = 0
    for typeKey in _.keys(taxTypes)
      apiList = paramList(defaultAttribs[typeKey], base, typeKey)
      for attrib of apiList
        #map type and attributes to api 
        for api in apiList[attrib]
          apis[i] = [api, typeKey, attrib]
          i++
    for a of apis
      getData(_.first(apis[a]), _.rest(apis[a]), false)
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

  mapTaxes = (items, callInfo) ->
    # Converts the xml to json object
    # Call info is type, param
    typeName = callInfo[0]
    params = callInfo[1]
    if not taxes[typeName][0]?
      taxes[typeName] = []
    #TODO: map with multiple params 
    if params is "group"
      if not taxes[typeName][params]?
        taxes[typeName][params] = []
      mapAttribs items, taxes[typeName][params]
    else
      mapAttribs items, taxes[typeName]
  
  window.taxesObject = {}
  mapAttribs = (items, typeObject) ->
    for item, i in items
      for a in [0...numItemAttributes i]
        taxesObject[nabItem('name',i,a)] = nabItem('value',i,a)
      #typeObject.push obj

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
