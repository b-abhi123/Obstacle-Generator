local ObbyService = {}

-- SERVICES
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- MODULES
local GenerationService = require(ServerScriptService.ObbyMain.Obby:WaitForChild("Generation"))

-- VARIABLES
local RNG = Random.new()
local Settings = {
	Stages = script.Parent.Settings:WaitForChild("Stages").Value,
	Turnpoint = script.Parent.Settings:WaitForChild("Turnpoint").Value
}
local globalCount = 1
local count = Settings.Stages
local direction = true

-- FUNCTIONS
function ObbyService:GenerateObby()
	globalCount = 1
	direction = true
	local Previous = Instance.new("ObjectValue",ServerStorage)
	Previous.Name = "Previous"
	for currentCount = 1, count, 1 do wait(0.3)
		local RandomColorOne, RandomColorTwo = Color3.fromRGB(RNG:NextInteger(1, 150), RNG:NextInteger(1, 150), RNG:NextInteger(1, 150)), Color3.fromRGB(RNG:NextInteger(1, 250), RNG:NextInteger(1, 250), RNG:NextInteger(1, 250))
		local Stage = GenerationService:GetRandomStage()
		if not Stage then return end
		if globalCount == Settings.Stages then -- if stage end
			GenerationService:CreateStage(Stage, globalCount, RandomColorOne, RandomColorTwo, nil, true,Previous)
			globalCount = globalCount + 1
			break
		elseif currentCount % Settings.Turnpoint == (Settings.Turnpoint * 0.8) then -- turn stage
			if direction then
				direction = false
				for live = 1, Settings.Turnpoint, 1 do wait(0.3)
					if globalCount == Settings.Stages then break end
					local RandomColorOne, RandomColorTwo = Color3.fromRGB(RNG:NextInteger(1, 150), RNG:NextInteger(1, 150), RNG:NextInteger(1, 150)), Color3.fromRGB(RNG:NextInteger(1, 250), RNG:NextInteger(1, 250), RNG:NextInteger(1, 250))
					Stage = GenerationService:GetRandomStage()
					GenerationService:CreateStage(Stage, globalCount, RandomColorOne, RandomColorTwo, 90, false,Previous)
					globalCount = globalCount + 1
				end
			else
				direction = true
				for live = 1, Settings.Turnpoint, 1 do wait(0.3)
					if globalCount == Settings.Stages then break end
					local RandomColorOne, RandomColorTwo = Color3.fromRGB(RNG:NextInteger(1, 150), RNG:NextInteger(1, 150), RNG:NextInteger(1, 150)), Color3.fromRGB(RNG:NextInteger(1, 250), RNG:NextInteger(1, 250), RNG:NextInteger(1, 250))
					Stage = GenerationService:GetRandomStage()
					GenerationService:CreateStage(Stage, globalCount, RandomColorOne, RandomColorTwo, -90, false,Previous)
					globalCount = globalCount + 1
				end
			end
		else -- normal stage
			GenerationService:CreateStage(Stage, globalCount, RandomColorOne, RandomColorTwo, nil, false,Previous)
			globalCount = globalCount + 1
		end
	end
end



return ObbyService