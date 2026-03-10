import ../types
import tables

proc registerLMArena*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.LMArena] = ProviderConfig(
        url: "https://g4f.space/custom/srv_mm0u3dj0b6a1d9becaaf/chat/completions",
        headers: headersDefault()
    )