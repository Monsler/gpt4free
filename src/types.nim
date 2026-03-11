import httpclient
import json, strformat
import std/[base64, os]
import asyncdispatch

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
    content*: JsonNode

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
    content: %content
  )

proc localImage*(imagePath: string): string =
  var output: string

  if fileExists(imagePath):
    let content = base64.encode(readFile(imagePath))
    output = &"data:image/jpeg;base64,{content}"

  return output

proc webImage*(imageUrl: string): string =
  let client = newHttpClient()
  let response = client.request(imageUrl, HttpMethod.HttpGet, "")

  let content = response.body

  let encoded = base64.encode(content)

  return &"data:image/jpeg;base64,{encoded}"

proc newImageMessage*(role: string = "user", content: string = "", imageUrl: string = ""): Message =
  return Message(
    role: role,
    content: %* [
      {
        "type": "text",
        "text": content
      },
      {
        "type": "image_url",
        "image_url": {
          "url": imageUrl
        }
      }
    ]
  )

proc newChatResponse*(message: Message, rawData: JsonNode, reasoning: string = ""): ChatResponse =
  return ChatResponse(
    message: message,
    raw: rawData,
    reasoning: reasoning
  )

proc headersDefault*(): HttpHeaders =
  return newHttpHeaders({"Content-Type": "application/json"})
