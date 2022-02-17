--[[
	Put at the top of your script:

	if (not isfile("CommandsFramework.lua")) then
		writefile("CommandsFramework.lua", game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/Releases/main/CommandsFramework.lua"))
	end
	
	coroutine.wrap(function()
		local src = game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/Releases/main/CommandsFramework.lua")
		
		if (src ~= readfile("CommandsFramework.lua")) then
			writefile("CommandsFramework.lua", src)
			
			warn("Updated CommandsFramework.lua because it was outdated, consider re-executing.")
		end
	end)()
	
	loadstring(readfile("CommandsFramework.lua"))()
]]

--[[
	Usage example:
	
	if (not isfile("CommandsFramework.lua")) then
		writefile("CommandsFramework.lua", game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/Releases/main/CommandsFramework.lua"))
	end
	
	coroutine.wrap(function()
		local src = game:HttpGetAsync("https://raw.githubusercontent.com/CheddarGetter/Releases/main/CommandsFramework.lua")
		
		if (src ~= readfile("CommandsFramework.lua")) then
			writefile("CommandsFramework.lua", src)
			
			warn("Updated CommandsFramework.lua because it was outdated, consider re-executing.")
		end
	end)()
	
	loadstring(readfile("CommandsFramework.lua"))()
	
	
	-- Use the CommandsFramework
	Command.new({"print", "output"}, "prints stuff", function(...)
		print(...)
	end)
	
	Command.new({"walkspeed", "ws", "speed"}, "sets your walkspeed", function(new_speed)
		game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(new_speed)
	end)
	
	game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
		Commands:CallCommandsFromString(message)
	end)
]]




CommandPrefix    = "/"
CommandSeperator = " ; "

Commands = {}

function Commands:CallCommandsFromString(str)
	for i, line in ipairs(str:split(CommandSeperator)) do
		local split = line:split(" ")
		
		if (split[1]:sub(1, #CommandPrefix) ~= CommandPrefix) then
			return
		end
		
		local found_command = Commands[split[1]:sub(#CommandPrefix + 1):lower()]
		
		if (found_command) then
			table.remove(split, 1)
			
			found_command._called:Fire(unpack(split))
		else
			warn(split[1]:sub(#CommandPrefix + 1) .. " is not a valid command Lol!")
		end
	end
end


Command = {}
Command.__index = Command

function Command.new(names, description, called_callback)
	local called = Instance.new("BindableEvent")
	local destroying = Instance.new("BindableEvent")

	if (called_callback) then
		called.Event:Connect(called_callback)
	end

	local new_command = setmetatable({
		Names = names;
		Description = description;

		Called = called.Event;
		_called = called;

		Destroying = destroying.Event;
		_destroying = destroying;
	}, Command)

	for i, name in ipairs(names) do
		Commands[name:lower()] = new_command
	end

	return new_command
end

function Command:Destroy()
	self._destroying:Fire()
	self._destroying:Destroy()
	self._called:Destroy()

	for _, name in ipairs(self.Names) do
		Commands[name] = nil
	end

	table.clear(self)
end
