 
import ../types
import tables

proc registerOpenRouter*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.OpenRouter] = ProviderConfig(
        url: "https://g4f.space/api/openrouter/chat/completions",
        headers: headersDefault()
    )