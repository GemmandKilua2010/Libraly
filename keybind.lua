local config = {
    key = "G",
    lib = "redz Library V5",
    hub = "Hub"
}

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local connection
local keybind = {}

local function update()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local library = CoreGui:WaitForChild(config.lib)
    local hub = library:WaitForChild(config.hub)
    local keyCode = Enum.KeyCode[config.key]

    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or input.KeyCode ~= keyCode then return end
        hub.Visible = not hub.Visible
    end)
end

setmetatable(keybind, {
    __index = config,
    __newindex = function(_, key, value)
        config[key] = value
        if key == "key" or key == "lib" or key == "hub" then
            task.spawn(update)
        end
    end
})

update()
return keybind
