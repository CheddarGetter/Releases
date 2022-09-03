local Signal = raw_require("https://gist.githubusercontent.com/stravant/b75a322e0919d60dde8a0316d1f09d2f/raw/f6a8900676185457211ec25d22d681c20ee792cb/GoodSignal.lua")


local function WaitForChild(Parent, ChildName, Timeout)
    local Child = Parent:FindFirstChild(ChildName)
    if (Child) then
        return Child
    end

    local ChildFound = Signal.new()
    local TimeoutThread
    local ChildAddedConnection

    ChildAddedConnection = Parent.ChildAdded:Connect(function(Child)
        if (Child.Name == ChildName) then
            ChildAddedConnection:Disconnect()

            if (TimeoutThread) then
                task.cancel(TimeoutThread)
            end

            ChildFound:Fire(Child)
        end
    end)

    TimeoutThread = task.delay(Timeout or 1, function()
        ChildAddedConnection:Disconnect()

        ChildFound:Fire()
    end)

    return ChildFound:Wait()
end


return WaitForChild
