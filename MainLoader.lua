local BaseURL = "https://raw.githubusercontent.com/deproxies/Deproxware/refs/heads/main/"

local Loadstrings = {
    [119987266683883] = BaseURL .. "Brainrotshit.lua",
}

for place, url in Loadstrings do
    if place == game.PlaceId then
        loadstring(game:HttpGet(url))()
    else
        loadstring(game:HttpGet(BaseURL .. "UniversalAimbot.lua"))()
    end
end
