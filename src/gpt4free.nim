import tables, options
import json, asyncdispatch
import httpclient
import types
export types

import providers/[pollination, geminiv1, master, auto]

var providerResolver = initTable[Provider, ProviderConfig]()

providerResolver.registerPollinations
providerResolver.registerGeminiV1
providerResolver.registerMaster
providerResolver.registerAuto

proc resolveProvider(provider: Provider): Option[ProviderConfig] =
  if providerResolver.contains(provider):
    some(providerResolver[provider])
  else:
    none(ProviderConfig)

import asyncdispatch, httpclient, json, options # Добавь это

proc createCompletion*(chat_completion: ChatCompletion): Future[Option[JsonNode]] {.async.} =
  let configOpt = resolveProvider(chat_completion.provider)
  
  if configOpt.isNone:
    echo "Unregistered provider; Aborting"
    return none(JsonNode)

  let config = configOpt.get
  let client = newAsyncHttpClient()
  client.headers = config.headers

  let body = %* {
    "model": chat_completion.model,
    "messages": chat_completion.messages
  }

  try:
    let response = await client.request(config.url, httpMethod = HttpPost, body = $body)
    let content = await response.body
    return some(parseJson(content))
  except Exception as e:
    echo "Error: ", e.msg
    return none(JsonNode)


