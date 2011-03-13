$ ->
  #data object
  window.taxes = {}
  $(window).bind 'got_items', ->
    showTaxes() 
  
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
 
  window.getTaxes = (typeName, params) ->
    print 'Loading taxes...'
    base = "http://www.whatwepayfor.com/api/"
    if !type[typeName]
      typeName = "budgetAccount"
    api  = base + setType(typeName) + setParams(params)
    getData(api, typeName, true)
    print '...'

  window.apis = {}
  window.getAllTaxes = (params) ->
    print 'Loading all taxes, please wait...'
    base = "http://www.whatwepayfor.com/api/"
    for typeKey in _.keys(type)
      if (typeKey is "budgetTotal")
        #For totals, get each group object
        for i in paramDefaults.budgetGroup
          params =
            group: i
          apiString = base + setType(typeKey) + setParams(params)
          apis[apiString] = typeKey
          params = undefined
      if (typeKey is "receiptTotal")
        #For totals, get each group object
        for i in paramDefaults.receiptGroup
          params =
            group: i
          apiString = base + setType(typeKey) + setParams(params)
          apis[apiString] = typeKey
          params = undefined
      else
        apiString = base + setType(typeKey) + setParams(params)
        apis[apiString] = typeKey
    for key, val of apis
      getData(key, val, false)
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
    return _.size(taxes[type])

  window.showTaxes = (type) ->
    if (_.isUndefined(type))
      # showTaxes works for allTaxes or specific calls
      type = taxes.type
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


