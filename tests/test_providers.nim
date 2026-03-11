import unittest
import ../src/gpt4free

suite "Provider test":
    test "Provider call":
        let bot = newChatCompletion("claude-sonnet-4.6", Provider.AirForce, @[
            newMessage("system", "you are a helpful ai chat bot. If you don't know the answer to user's question just tell 'I dont know' them"),
            newImageMessage("user", "привет, когда выйдет фильм по этой игре?", webImage("https://upload.wikimedia.org/wikipedia/ru/e/e7/Steve_%28Minecraft%29.png"))
        ], true)

        let response = waitFor bot.createCompletion()

        if response.isSome():
            let t = response.get()
            
            try:
                echo "Model answer: \n\n", t.content, "\n\nReasoning:\n\n", t.reasoning
            except:
                echo "Failed: ", $t.raw
        else:
            echo "response is nil"