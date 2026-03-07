import ../types
import tables

proc registerOllama*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.Ollama] = ProviderConfig(
        url: "https://g4f.space/api/ollama/chat/completions",
        headers: headersDefault()
    )