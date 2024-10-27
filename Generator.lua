local GenerationService = {}

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- VARIABLES
local StagePlacement = game.Workspace:WaitForChild("Stages")
--local CheckpointPlacement = game.Workspace:WaitForChild("Checkpoints")
local Stages = ServerStorage:WaitForChild("Stages")
local StageStorage = Stages:WaitForChild("All")
local Children = StageStorage:GetChildren()

local Connections = {}
-- FUNCTIONS

local function kill(hit)
	--print('ran this thing')
	local Player = Players:GetPlayerFromCharacter(hit.Parent)
	if Player then
		if hit:IsA("BasePart") and not hit:IsA("Accessory") and Player then
			local Humanoid = Player.Character:FindFirstChild("Humanoid")
			if Humanoid then
				if Humanoid.Health > 0 then
					Humanoid.Health = 0
				end
			else
				return print("[SERVER] - Character could not be found.")
			end
		end
	end
end

function GenerationService:GetRandomStage()
	if not Children or #Children < 1 then warn("[SERVER] - Could not find any stages!") return end
	local Stage = tostring(Children[math.random(1, #Children)])
	return Stage
end

function GenerationService:CreateStage(typ, stagNR, one, two, angle, last,Previous)
	if not Children or #Children < 1 then warn("[SERVER] - Unable to create stage!") return end
	local Stage
	if not last then
		Stage = StageStorage[typ]:Clone()
	else
		Stage = Stages.Finish:Clone()
	end
	if not Stage:FindFirstChild("Colored") then
		return warn("[SERVER] - " .. typ .. " " .. stagNR .. " failed to get colored!")
	end
	for _, part in pairs(Stage.Colored.One:GetChildren()) do
		if one then
			if part:IsA("BasePart") or part:IsA("WedgePart") or part:IsA("TrussPart") then
				part.Color = one
			end
		end
	end
	for _, part in pairs(Stage.Colored.Two:GetChildren()) do
		if two then
			if part:IsA("BasePart") or part:IsA("WedgePart") or part:IsA("TrussPart") then
				part.Color = two
			end
		end
	end
	
	Stage.Parent = StagePlacement
	
	if Stage:FindFirstChild("Lava") then
		for _, lavaObj in pairs(Stage.Lava:GetChildren()) do
			CollectionService:AddTag(lavaObj, "Lava")
			if one then
				lavaObj.Color = Color3.fromRGB(255,0,0)
				lavaObj.CanCollide = false
			end
			if not lavaObj.Anchored and not lavaObj:IsDescendantOf(game.Workspace) then
				print("set network owner to nil")
				lavaObj:SetNetworkOwner(nil)
			else
				lavaObj.Touched:Connect(kill)
			end
		end
	end
	if Previous.Value ~= nil then
		if angle then
			Stage:SetPrimaryPartCFrame(CFrame.new(Previous.Value.Next.Position) * CFrame.Angles(0, math.rad(angle)+math.rad(270), 0))
		else
			Stage:SetPrimaryPartCFrame(CFrame.new(Previous.Value.Next.Position) * CFrame.Angles(0,math.rad(270),0))
		end
		Previous.Value.Next:Destroy()
	else
		Stage:SetPrimaryPartCFrame(CFrame.new(98.4, 121.1, 24)*CFrame.Angles(0,math.rad(270),0))
	end
	
	Previous.Value = Stage
	
	--[[local Checkpoint = Stage.Checkpoint
	if Checkpoint then
		if one then
			Checkpoint.Color = one
		end
		Checkpoint.Name = "Checkpoint " .. stagNR
		Checkpoint.Parent = CheckpointPlacement
		if stagNR == 1 then
			return
		end
	end--]]
	local Checkpoint = Stage.Checkpoint
	if Checkpoint then
		Checkpoint.Touched:Connect(function(h)
			--print('ea')
			if h and h.Parent and h.Parent:FindFirstChild("Humanoid") then
				local success,errmsg = pcall(function()
					--h.Parent.Humanoid.WalkSpeed = 18
					print("Yes")
					
				end)
			end
		end)
	end
end


-- CONNECTIONS
--[[CollectionService:GetInstanceAddedSignal("Lava"):Connect(function()
	for _, lavaObj in pairs(CollectionService:GetTagged("Lava")) do
		lavaObj.Touched:Connect(kill)
	end
end)--]]

return GenerationService