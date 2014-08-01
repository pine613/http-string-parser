parseRequest = (requestString) ->
  request = {}
  lines = requestString.split('\r\n')

  parsedRequestLine = parseRequestLine lines.shift()
  request['method'] = parsedRequestLine['method']
  request['uri'] = parsedRequestLine['uri']
  
  #TODO refactor this part to be tested
  headerLines = []
  while lines.length > 0
    line = lines.shift()
    break if line == ""
    headerLines.push line
  
  request['headers'] = parseHeaders headerLines
  request['body'] = lines.join '\r\n'
  
  request

parseResponse = (responseString) ->
  response = {}
  lines = responseString.split('\r\n')
  
  parsedStatusLine = parseStatusLine lines.shift()
  response['statusCode'] = parsedStatusLine['statusCode']
  response['statusMessage'] = parsedStatusLine['statusMessage']
  
  #TODO refactor this part to be tested
  headerLines = []
  while lines.length > 0
    line = lines.shift()
    break if line == ""
    headerLines.push line
  
  response['headers'] = parseHeaders headerLines
  response['body'] = lines.join '\r\n'
  
  response

parseHeaders = (headerLines) ->
  headers = {}
  for line in headerLines
    parts = line.split(":")
    key = parts.shift()
    headers[key] = parts.join(":").trim()

  headers

parseStatusLine = (statusLine) ->
  parts = statusLine.split ' '
  parsed = {}

  parsed['protocol'] = parts[0]
  parsed['statusCode'] = parts[1]
  parsed['statusMessage'] = parts[2]

  parsed
  
parseRequestLine = (requestLineString) ->
  parts = requestLineString.split(' ')
  parsed = {}

  parsed['method'] = parts[0]
  parsed['uri'] = parts[1]
  parsed['protocol'] = parts[2]

  parsed

if module?.exports
  module.exports.parseRequest = parseRequest
  module.exports.parseResponse = parseResponse
  module.exports.parseRequestLine = parseRequestLine
  module.exports.parseStatusLine = parseStatusLine
  module.exports.parseHeaders = parseHeaders
else
  @HttpStringParser =
    parseRequest: parseRequest
    parseResponse: parseResponse
    parseRequestLine: parseRequestLine
    parseStatusLine: parseStatusLine
    parseHeaders: parseHeaders
