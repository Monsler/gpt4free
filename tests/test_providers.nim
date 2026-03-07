import unittest
import ../src/gpt4free

suite "Provider test":
    test "Provider call":
        let bot = newChatCompletion("stepfun/step-3.5-flash:free", Provider.OpenRouter, @[
            newMessage("system", "you are a helpful ai chat bot. If you don't know the answer to user's question just tell 'I dont know' them"),
            newMessage("user", "hey, when minecraft movie was released?")
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
