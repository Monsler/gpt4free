### gpt4free Nim
This is an implementation of python library called as same as this one.
Provides free access to popular LLMs (And more soon!)

Install:
```
nimble add gpt4free
```

Example:

```nim
import gpt4free

when isMainModule:
    let bot = newChatCompletion("openrouter/free", Provider.OpenRouter, @[
                newMessage("system", "you are a helpful ai chat bot."),
                newMessage("user", "hello, can you tell me a funny story?")
            ], true)

    let response = waitFor bot.createCompletion()

    if response.isSome():
        let t = response.get()
                
        try:
            echo "Model answer: \n\n", t.message.content, "\n\nReasoning:\n\n", t.reasoning
        except:
            echo "Failed: ", $t.raw
        else:
            echo "response is nil"
    
    quit(0)
    
```

