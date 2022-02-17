CommandPrefix    = "/"
CommandSeperator = "; "

Commands = {}

function Commands:CallCommandsFromString(str)
	for i, line in ipairs(str:split(CommandSeperator)) do
		local prefix = line:split(CommandPrefix)
		
		if (prefix[1] ~= "") then
			return
		end
		
		local args = prefix[2]:split(" ")
		local command = Commands[args[1]:lower()]

		if (command) then
			table.remove(args, 1)

			command._called:Fire(unpack(args))
		else
			warn(args[1] .. " is not a command")
		end
	end
end


Command = {}
Command.__index = Command

function Command.new(names, description, callback)
	local called = Instance.new("BindableEvent")
	local destroying = Instance.new("BindableEvent")

	if (callback) then
		called.Event:Connect(callback)
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

