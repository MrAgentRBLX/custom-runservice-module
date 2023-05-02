local module = table.create(1)
module.__index = module


-- SERVICES --
local RunService = game:GetService("RunService")


-- CONNECTION HANDLER --
module.connections = table.create(1)


-- CONNECTION FUNCTIONS --
function module.bind(method, callback)
	table.insert(module.connections, RunService[method]:Connect(callback))
end

function module.unbind(orderid)
	module.connections[orderid]:Disconnect()
end

function module.unbindall()
	for _,  connection in next, module.connections do
		connection:Disconnect()
	end
end

function module:Flush()
	module.unbindall()
end


return module
