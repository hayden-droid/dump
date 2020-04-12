local Module = {}

-- // Services \\ --
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- // Methods \\ --
return function()
	if UserInputService.TouchEnabled 
	and not UserInputService.KeyboardEnabled 
	and not UserInputService.MouseEnabled
  	and not UserInputService.GamepadEnabled 
	and not GuiService:IsTenFootInterface() then
	  	 return "Mobile"
	elseif not UserInputService.TouchEnabled 
	and UserInputService.KeyboardEnabled 
  	and not UserInputService.GamepadEnabled 
	and not GuiService:IsTenFootInterface() then
		return "Computer"
	elseif not UserInputService.TouchEnabled 
	and not UserInputService.MouseEnabled
	and not UserInputService.KeyboardEnabled 
  	and UserInputService.GamepadEnabled 
	and GuiService:IsTenFootInterface() then 
		return "Console"
	end
end

return Module
