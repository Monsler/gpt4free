import httpclient
import json

type
  Provider* = enum
    Pollinations
    GeminiV1
    Master
    OpenRouter
    Ollama
    Puter
    Auto
    AirForce
    LMArena

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
    webSearch*: bool
    apiKey*: string

type
  ChatResponse* = object
    raw*: JsonNode
    message*: Message
    reasoning*: string

proc newChatCompletion*(model: string="auto", provider: Provider=Provider.Auto, messages: seq[Message] = @[], webSearch: bool = false, apiKey: string = ""): ChatCompletion =
  return ChatCompletion(
    model: model,
    provider: provider,
    messages: messages,
    webSearch: webSearch,
    apiKey: apiKey
  )

proc newMessage*(role: string = "user", content: string = ""): Message = 
  return Message(
    role: role,
    content: content
  )

proc newChatResponse*(message: Message, rawData: JsonNode, reasoning: string = ""): ChatResponse =
  return ChatResponse(
    message: message,
    raw: rawData,
    reasoning: reasoning
  )

proc headersDefault*(): HttpHeaders =
  return newHttpHeaders({"Content-Type": "application/json"})
