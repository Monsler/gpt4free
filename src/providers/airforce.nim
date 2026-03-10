import ../types
import tables

proc registerAirForce*(dest: var Table[Provider, ProviderConfig]) =
    dest[Provider.AirForce] = ProviderConfig(
        url: "https://g4f.space/api/api.airforce/chat/completions",
        headers: headersDefault()
    )