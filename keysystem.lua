local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/yue-os/ObsidianUi/refs/heads/main/Library.lua"))()
local apiUrl = "https://keysystem-k4y3.onrender.com/api/verify-key"
local keyLink = "https://keysystem-k4y3.onrender.com"
local botUrl = "https://botcounter-ly3x.onrender.com/count"

if setclipboard then
    setclipboard(keyLink)
    Library:Notify("Key link copied! Paste it in your browser to get the key.")
else
    Library:Notify("Copy this link for the key:\n" .. keyLink)
end

local window = Library:CreateWindow({
    Title = "Key System",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(230, 250),
    ShowCustomCursor = false,
    ToggleKeybind = Enum.KeyCode.LeftControl
})
local tab = window:AddTab("Key")
local group = tab:AddLeftGroupbox("Enter Key")

local HttpService = game:GetService("HttpService")

local keyFile = "Y-Hub/Y-Hub-key.txt"

local response = request({
    Url = botUrl,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer Ratbu"
    },
    Body = HttpService:JSONEncode({count = 1})
})

local savedKey = nil
if isfile and isfile(keyFile) then
    local ok, content = pcall(readfile, keyFile)
    if ok and content and #content > 0 then
        savedKey = content
    end
end

local verified = false

local function getHWID()
    local success, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    return success and hwid or "unknown"
end

local function verifyKey(inputKey)
    if verified then
        return false
    end
    local url = apiUrl
    local hwid = getHWID()
    local body = HttpService:JSONEncode({key = inputKey, hwid = hwid})
    local headers = {["Content-Type"] = "application/json"}
    local req = http_request or syn and syn.request
    if not req then
        Library:Notify("Your executor does not support HTTP POST requests.")
        return false
    end
    local res = req({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    local responseBody = res and (res.Body or res.body)
    if responseBody then
        local data = HttpService:JSONDecode(responseBody)
        if data.valid then
            verified = true
            -- Save key to file
            if writefile then
                pcall(writefile, keyFile, inputKey)
            end
        elseif data.reason then
            Library:Notify(data.reason)
        end
        return data.valid
    end
    return false
end

local scriptMap = {
    ["109983668079237"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/stealabrainrot",
    ["126884695634066"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/gag",
    ["111989938562194"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/brainrotEvo",
    ["137925884276740"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/buildaplane.lua",
    ["15514727567"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/gunfightarena",
    ["15000687579"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/gunfightarena",
	["15514734207"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/gunfightarena",
    ["79546208627805"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/99nights",
    ["126509999114328"] = "https://raw.githubusercontent.com/yue-os/script/refs/heads/main/99nights",
}

local function unlockAndRunScript()
    local scriptUrl = scriptMap[tostring(game.PlaceId)]
    if scriptUrl then
        local success, err = pcall(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)

        if not success then
            warn("❌ Script failed to run:", err)
            Library:Notify("Script load failed: " .. tostring(err))
            Library:Notify("Please notify the creator on discord.")
        end
    else
        local MarketplaceService = game:GetService("MarketplaceService")
        local succ, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if succ and info and info.Name then
            Library:Notify("No script for this game:" .. info.Name)
            Library:Notify("Please contact the owner on discord.")
        end
    end
end

if savedKey and not verified then
    Library:Notify("Checking saved key, please wait...")
    local isValid = verifyKey(savedKey)
    if isValid then
        Library:Notify("Correct key! Script unlocked.")
        task.wait(0.5)
        for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:IsA("ScreenGui") then
                local obsidian = gui:FindFirstChild("Obsidian")
                if obsidian and obsidian:IsA("Frame") then
                    obsidian:Destroy()
                end
            end
        end
        unlockAndRunScript()
        return
    else
        Library:Notify("Saved key invalid or expired. Please enter a new key.")
        if delfile then pcall(delfile, keyFile) end
    end
end

group:AddInput("key_input", {
    Text = "Key",
    Placeholder = "Enter key...",
    Callback = function(input)
        if verified then
            return
        end
        Library:Notify("Checking key, please wait...")
        local isValid = verifyKey(input)
        if isValid then
            Library:Notify("Correct key! Script unlocked.")
            task.wait(0.5)
            for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
                if gui:IsA("ScreenGui") then
                    local obsidian = gui:FindFirstChild("Obsidian")
                    if obsidian and obsidian:IsA("Frame") then
                        obsidian:Destroy()
                    end
                end
            end
            unlockAndRunScript()
        else
            Library:Notify("Invalid or expired key!")
        end
    end
})

group:AddButton({
    Text = "Copy Key Link",
    Func = function()
        if setclipboard then
            setclipboard(keyLink)
            Library:Notify("Key link copied! Paste it in your browser to get the key.")
        else
            Library:Notify("Copy this link for the key:\n" .. keyLink)
        end
    end
})

group:AddButton({
    Text = "Check Key",
    Func = function()
        if verified then
            return
        end
        local input = Library.Options.key_input and Library.Options.key_input.Value
        Library:Notify("Checking key, please wait...")
        local isValid = verifyKey(input)
        if isValid then
            Library:Notify("Correct key! Script unlocked.")
            task.wait(0.5)
            for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
                if gui:IsA("ScreenGui") then
                    local obsidian = gui:FindFirstChild("Obsidian")
                    if obsidian and obsidian:IsA("Frame") then
                        obsidian:Destroy()
                    end
                end
            end
            unlockAndRunScript()
        else
            Library:Notify("Invalid or expired key!")
        end
    end
})

group:AddButton({
    Text = "Join Discord Server",
    Func = function()
        setclipboard("https://discord.gg/WswepWXvr9")
        Library:Notify("Discord link copied! Paste in browser to join.")
        pcall(function()
            if syn and syn.request then
                syn.request({Url = "https://discord.gg/WswepWXvr9", Method = "GET"})
            else
                game:HttpGet("https://discord.gg/WswepWXvr9")
            end
        end)
    end
})

task.spawn(function()
    while true do
        if verified then
            Library.Options.key_input:SetValue("")
            break
        end
        task.wait(1)
    end
end)
