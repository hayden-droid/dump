--[[
	Author: Alphexus
	Purpose: Handles temporary data for each player to make it easy to manipulate.
--]] 

local SessionData = {
	Players = {
		
	}
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SessionRemote = ReplicatedStorage:WaitForChild("SessionData")

function SessionData:Add(player, data)
	SessionData.Players[player] = data
end

function SessionData:Remove(player)
	SessionData.Players[player] = nil
end

function SessionData:CreateHybrid(player, instName, value, name)	
	if not player:FindFirstChild("HybridData") then
		local HybridData = Instance.new("Folder")
		HybridData.Name = "HybridData"
		HybridData.Parent = player
	end
	
	local Hybrid = Instance.new(instName)
	Hybrid.Name = name
	Hybrid.Value = value
	Hybrid.Parent = player.HybridData
	
	return Hybrid
end

function SessionData:Get(player)
	repeat wait(0.05) until SessionData.Players[player] ~= nil
	return SessionData.Players[player]
end

function SessionData:SyncToClient(player, newData)
	SessionRemote:FireClient(player, newData)
end


return SessionData
