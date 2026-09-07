local config = {
    key = "G",
    lib = "redz Library V5",
    hub = "Hub"
}

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local connection
local keybind = {}

local function getKeyCode()
    local key = tostring(config.key):upper()
    return Enum.KeyCode[key]
end

local function update()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local library = CoreGui:FindFirstChild(config.lib)
    if not library then return end

    local hub = library:FindFirstChild(config.hub)
    if not hub then return end

    local keyCode = getKeyCode()
    if not keyCode then return end

    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode ~= keyCode then return end
        hub.Visible = not hub.Visible
    end)
end
setmetatable(keybind, {
    __index = function(_, key)
        return config[key]
    end,
    __newindex = function(_, key, value)
        config[key] = value
        if key == "key" or key == "lib" or key == "hub" then
            task.defer(update)
        end
    end
})

task.defer(update)
return keybind
