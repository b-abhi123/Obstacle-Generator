local Obby = require(script:WaitForChild("Obby"))
local Bear = workspace:WaitForChild("Lobby"):WaitForChild("Bear"):WaitForChild("DialogTxt"):WaitForChild("Interface"):WaitForChild("Frame"):WaitForChild("Box"):WaitForChild("Message")

spawn(function()
	Obby:GenerateObby()
end)


while true do
	for i = 100,0,-1 do
		task.wait(1)
		Bear.Text = "Play the obby and get cool rewards! Resetting in "..tostring(i)
		if i == 1 then
			workspace.Stages:ClearAllChildren()
			game.ServerStorage:WaitForChild("Previous"):Destroy()
			spawn(function()
				Obby:GenerateObby()
			end)
		end
	end

end