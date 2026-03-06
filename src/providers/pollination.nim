import ../types
import tables

proc registerPollinations*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.Pollinations] = ProviderConfig(
        url: "https://g4f.space/api/pollinations/chat/completions",
        headers: headersDefault()
    )