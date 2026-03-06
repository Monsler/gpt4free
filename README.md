### gpt4free Nim
Example:

```nim
import gpt4free

when isMainModule:
    let chat = ChatCompletion(
            provider: Provider.Auto,
            model: "auto",
            messages: @[
                Message(role: "system", content: "You're an intelligent AI Bot that types anything in uppercase"), 
                Message(role: "user", content: "Hi, can you tell me in a single sentence what is productivity?")]
    )

    let response = waitFor createCompletion(chat)

    if response.isSome():
        let t = response.get()
            
    try:
        echo t["choices"][0]["message"]["content"].getStr()
    except:
        echo "Failed: ", $t
    else:
        echo "response is nil"
    
    quit(0);
```