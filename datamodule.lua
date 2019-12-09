local Data = {
	Template = {

  }
}


-- // Services \\ --
local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("Data#FD10dn23a")
local Backup = DataStoreService:GetDataStore("BackupSave")

function Data:Set(key, value)
	local success, err = pcall(function()
		DataStore:SetAsync(key, value)
	end)
	
	if not success then
		wait(1)
		return Data:Set(key, value)
	end
end

function Data:Get(key)
	local PlayerData
	local success, err = pcall(function()
		PlayerData = DataStore:GetAsync(key)
	end)
	
	if success then
		if PlayerData then
			return PlayerData
		else
			success, err = pcall(function()
				PlayerData = Backup:GetAsync(key)
			end)
			
			if success then
				if PlayerData then
					return PlayerData
				else
					return nil
				end
			end
		end
	else
		return nil
	end
end

return Data
