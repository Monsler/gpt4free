import ../types
import tables

proc registerPuter*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.Puter] = ProviderConfig(
        url: "https://g4f.space/api/puter/chat/completions",
        headers: headersDefault()
    )