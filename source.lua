local module = {}
module.__index = module


_G.ENV = {
    Settings = {
        Flushables = {excluded = true, connections = true},-- Clear types (what should be disconnected)
        connection_limit = 10,-- Allowed connections
        connection_types = {"Heartbeat", "Stepped", "RenderStepped"}-- Allowed types
    },
    Excluded = {},-- excluded (will not stop when re-execute)
    Connections = {}-- cleared when execute (stopped)
}


-- flush types --
module.set_flushables = function(types)
   for index, boolean in next, types do
      if not type(boolean) == "boolean" then error("Boolean expected (set flushables)") end
      if not type(index) == "string" then error("String expected (set flushables)") end
      if not _G.ENV.Settings.Flushables[index] then error("Index doesn't match property name (set flushables)") end
      _G.ENV.Settings.Flushables[index] = boolean
   end
end


-- on cleanup event --
if _G.ENV and #_G.ENV.Connections>0 then
    if _G.ENV.Settings.Flushables.connections then
        module:Flush(_G.ENV.Settings.Flushables.excluded)
    end
end


-- services --
local RunService = game:GetService("RunService")


-- bind/ connect --
function module:Bind(Type, Callback, Exclude)
    if #_G.ENV.Connections >= _G.ENV.Settings.connection_limit or not (Type == _G.ENV.Settings.connection_types[1] or Type == _G.ENV.Settings.connection_types[2] or Type == _G.ENV.Settings.connection_types[3]) then return end
    if Exclude and Exclude == true then
        table.insert(_G.ENV.Exclude, RunService[method]:Connect(callback)))
    end
    table.insert(_G.ENV.Connections, RunService[method]:Connect(callback)))
end


-- unbind/ clear --
function module:Unbind(orderid)
    if orderid and type(orderid) == "number" then
        _G.ENV.Connections[orderid]:Disconnect()
    end
    _G.ENV.Connections[#_G.ENV.Connections]:Disconnect()
end


-- flush/ clear --
function module:Flush(flush_excluded)
    local flush_success = pcall(function()
        for _, connection in next, _G.ENV.Connections do
            if connection then connection:Disconnect() end
        end
        if flush_excluded == true then
            for _, connection in next, _G.ENV.Exclude do
                if connection then connection:Disconnect() end
            end
        end
    end)
    if flush_success then
        return true
    else
        return false
    end
end


return module
