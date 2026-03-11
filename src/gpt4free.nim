import tables, options
import json, asyncdispatch
import httpclient, strutils
import types
export types, tables, json, asyncdispatch, options

import providers/[pollination, geminiv1, master, auto, openrouter, ollama, puter, lmarena, airforce]

var providerResolver {.threadvar.}: Table[Provider, ProviderConfig]

proc resolveProvider(provider: Provider): Option[ProviderConfig] {.gcsafe.} =
  if providerResolver.contains(provider):
    some(providerResolver[provider])
  else:
    none(ProviderConfig)

proc createCompletion*(chat_completion: ChatCompletion): Future[Option[ChatResponse]] {.async, gcsafe.} =
  if providerResolver.len == 0:
    providerResolver.registerPollinations()
    providerResolver.registerGeminiV1()
    providerResolver.registerMaster()
    providerResolver.registerAuto()
    providerResolver.registerOpenRouter()
    providerResolver.registerOllama()
    providerResolver.registerPuter()
    providerResolver.registerLMArena()
    providerResolver.registerAirForce()

  let configOpt = resolveProvider(chat_completion.provider)
  
  if configOpt.isNone:
    echo "Unregistered provider; Aborting"
    return none(ChatResponse)

  var config = configOpt.get

  if not chat_completion.apiKey.isEmptyOrWhitespace():
    config.headers["Authorization"] = "Bearer " & chat_completion.apiKey
    
  let client = newAsyncHttpClient()
  client.headers = config.headers

  var body = %* {
    "model": chat_completion.model,
    "messages": chat_completion.messages, 
  }

  if chat_completion.webSearch:
    body["web_search"] = %chat_completion.webSearch

  try:
    let response = await client.request(config.url, httpMethod = HttpPost, body = $body)

    let content = await response.body
    try:
      let raw = parseJson(content)
      try:
        var reasoning = ""

        if raw["choices"][0]["message"].hasKey("reasoning"):
          reasoning = raw["choices"][0]["message"]["reasoning"].getStr()

        let output = newChatResponse(
          raw["choices"][0]["message"]["role"].getStr(),
          raw["choices"][0]["message"]["content"].getStr()  ,
          raw,
          reasoning
        )
          
        return some(output)
      except: 
        echo "Failed to generate ChatResponse. Raw json:\n", content
        return none(ChatResponse)
    except:
      return none(ChatResponse)
  except Exception as e:
    echo "Error: ", e.msg
    return none(ChatResponse)


