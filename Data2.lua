--[[
	Author: Alphexus
	Purpose: Data class to recursively save/load data with simple data loss prevention.
    It's like the first data module except this one comes with a backup datastore.
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
	self.Name = name
	self.DataStore = DataStoreService:GetDataStore(name)
	self.BackupDataStore = DataStoreService:GetDataStore(name.."Backup")
	self.Template = template or require(script.DataTemplate)

	return self
end

function Data:Set(datastore, key, value, trial)
	if trial == 2 then return end
		
	local Success, ErrorMessage = pcall(function()
		datastore:SetAsync(key, value)
	end)
	
	if not Success then
		warn(ErrorMessage)
		coroutine.wrap(function()
			wait(5)
			self:Set(datastore, key, value, trial + 1)
		end)()
	else
		if datastore == self.DataStore then
			self:Set(self.BackupDataStore, key, value, 1)
		end
	end
end

function Data:Get(datastore, key, trial) 
	if trial == 2 then 
		if datastore == self.BackupDataStore then
			return nil
		else
			return self:Get(self.BackupDataStore, key, trial + 1)
		end
	end
	
	local Success, pData = pcall(function()
		return datastore:GetAsync(key)
	end)
	
	if Success then
		if pData ~= nil then
			for key,value in pairs(self.Template) do -- // Auto adjusts new data being saved
				if not pData[key] then
					pData[key] = value
				end
			end
			
			return pData
		else
			if datastore == self.DataStore then
				coroutine.wrap(function()
					wait(5)
					self:Set(datastore, key, self.Template, 1)
				end)()
				return Deepcopy(self.Template)
			else
				wait(5)
				return self:Get(self.BackupDataStore, trial + 1)
			end
		end
	else
		wait(5)
		return self:Get(datastore, key, trial + 1)
	end
end

return Data
