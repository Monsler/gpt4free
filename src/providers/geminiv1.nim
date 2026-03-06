import ../types
import tables

proc registerGeminiV1*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.GeminiV1] = ProviderConfig(
        url: "https://g4f.space/api/gemini-v1beta/chat/completions",
        headers: headersDefault()
    )