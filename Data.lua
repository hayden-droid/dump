--[[
	Author: Alphexus
	Purpose: Data class to recursively save/load data with simple data loss prevention
--]] 

local Data = {}
Data.__index = Data

local DataStoreService = game:GetService("DataStoreService")

-- // Private \\ --
local function Deepcopy(tbl)
    local ret = {}

    for k, v in pairs(tbl) do
        ret[k] = type(v) == "table" and Deepcopy(v) or v
    end

    return ret
end

-- // Public \\ --
function Data.new(name, template)
	local self = setmetatable({}, Data)
	self.DataStore = DataStoreService:GetDataStore(name)
	self.Template = template or require(script.DataTemplate)

	return self
end

function Data:Set(key, value, trial)
	if trial == 4 then return end
	local DataStore = self.DataStore
	
	local Success, ErrorMessage = pcall(function()
		DataStore:SetAsync(key, value)
	end)
	
	if not Success then
		warn(ErrorMessage)
		wait(6)
		return self:Set(key, value, trial + 1)
	end
end

function Data:Get(key, trial) 
	if trial == 4 then return nil end
	local DataStore = self.DataStore
	
	local Success, pData = pcall(function()
		return DataStore:GetAsync(key)
	end)
	
	if Success then
		if pData ~= nil then
			for key,value in pairs(self.Template) do
				if not pData[key] then
					pData[key] = value
				end
			end
			return pData
		else
			self:Set(key, self.Template, 1)
			return Deepcopy(self.Template)
		end
	else
		wait(6)
		return self:Get(key, trial + 1)
	end
end

return Data

