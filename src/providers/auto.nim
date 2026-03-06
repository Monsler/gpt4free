import ../types
import tables

proc registerAuto*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.Auto] = ProviderConfig(
        url: "https://g4f.space/api/auto/chat/completions",
        headers: headersDefault()
    )