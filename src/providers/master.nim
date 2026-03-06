import ../types
import tables

proc registerMaster*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.Master] = ProviderConfig(
        url: "https://perplexity.g4f-dev.workers.dev/chat/completions",
        headers: headersDefault()
    )