import httpclient

type
  Provider* = enum
    Pollinations
    GeminiV1
    Master
    Auto

type
  ProviderConfig* = object
    url*: string
    headers*: HttpHeaders
  
type
  Message* = object
    role*: string
    content*: string

type
  ChatCompletion* = object
    provider*: Provider
    model*: string
    messages*: seq[Message]

proc headersDefault*(): HttpHeaders =
  return newHttpHeaders({"Content-Type": "application/json"})
