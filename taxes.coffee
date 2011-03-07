$ ->
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
    else #default calls budget account
      typeString = type["budgetAccount"]
    return typeString

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
