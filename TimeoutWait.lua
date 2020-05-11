--[[
	Author: einsteinK, Alphexus
	Purpose: A way of adding a timeout to Event:Wait(). You can also pass a callback function,
--]] 

local EventTimeout = {}

function EventTimeout.new(ev, t, callback)
	local res, con
	con = ev:Connect(function(...)
		res = ...
		con:Disconnect()
	end)
	
   	t = tick() + (t or 30)
	repeat wait() until res or tick() > t
	
	if not res then 
		con:Disconnect()
		return false, callback or nil
	end
	
	return true, res
end


return EventTimeout
