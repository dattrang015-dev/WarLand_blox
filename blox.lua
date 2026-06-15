-- [[ 🚀 WARLAND VN - V102.1: SMOOTH FLY-FARM & SYNTAX FIX (FIXED) ]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local TargetParent = player:WaitForChild("PlayerGui")

if TargetParent:FindFirstChild("WarLand_V101") then TargetParent.WarLand_V101:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_V101"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [ CONFIG BIẾN HỆ THỐNG ]
_G.FlySpeed = 120
_G.Flying = false
_G.AutoFarmLevel = false
_G.SelectWeapon = "Melee" 
_G.FlyTarget = nil -- Quản lý mục tiêu bay tự động
_G.FlyStopDistance = 5 -- Khoảng cách dừng bay (studs)
local flyBV = nil
local flyBG = nil

-- [ DATA QUEST CHUẨN ]
local QuestData = {
	{Min = 1, Max = 9, Name = "Bandit", NPC = "Bandit Quest Giver", QName = "Bandits", Island = "Starter Island"},
	{Min = 10, Max = 19, Name = "Monkey", NPC = "Monkey Quest Giver", QName = "Monkeys", Island = "Jungle"},
	{Min = 20, Max = 34, Name = "Gorilla", NPC = "Monkey Quest Giver", QName = "Gorillas", Island = "Jungle"},
	{Min = 35, Max = 44, Name = "Pirate", NPC = "Pirate Quest Giver", QName = "Pirates", Island = "Pirate Village"},
	{Min = 45, Max = 59, Name = "Brute", NPC = "Pirate Quest Giver", QName = "Brutes", Island = "Pirate Village"},
	{Min = 60, Max = 74, Name = "Desert Bandit", NPC = "Desert Bandit Quest Giver", QName = "DesertBandits", Island = "Desert"},
	{Min = 75, Max = 89, Name = "Desert Officer", NPC = "Desert Bandit Quest Giver", QName = "DesertOfficers", Island = "Desert"},
	{Min = 90, Max = 104, Name = "Snow Bandit", NPC = "Snow Bandit Quest Giver", QName = "SnowBandits", Island = "Frozen Village"},
	{Min = 105, Max = 119, Name = "Snowman", NPC = "Snow Bandit Quest Giver", QName = "Snowmen", Island = "Frozen Village"},
	{Min = 120, Max = 134, Name = "Chief Petty Officer", NPC = "Navy Quest Giver", QName = "ChiefPettyOfficers", Island = "Marine Fortress"},
	{Min = 135, Max = 149, Name = "Navy Sergeant", NPC = "Navy Quest Giver", QName = "NavySergeants", Island = "Marine Fortress"},
	{Min = 150, Max = 174, Name = "Sky Bandit", NPC = "Sky Bandit Quest Giver", QName = "SkyBandits", Island = "Skylands"},
	{Min = 175, Max = 189, Name = "Dark Master", NPC = "Sky Bandit Quest Giver", QName = "DarkMasters", Island = "Skylands"},
	{Min = 190, Max = 249, Name = "God's Guard", NPC = "Sky Bandit Quest Giver", QName = "GodsGuards", Island = "Skylands"},
	{Min = 250, Max = 274, Name = "Prisoner", NPC = "Prisoner Quest Giver", QName = "Prisoners", Island = "Prison"},
	{Min = 275, Max = 299, Name = "Dangerous Prisoner", NPC = "Prisoner Quest Giver", QName = "DangerousPrisoners", Island = "Prison"},
	{Min = 300, Max = 324, Name = "Military Soldier", NPC = "Military Quest Giver", QName = "MilitarySoldiers", Island = "Magma Village"},
	{Min = 325, Max = 374, Name = "Military Spy", NPC = "Military Quest Giver", QName = "MilitarySpies", Island = "Magma Village"},
	{Min = 375, Max = 399, Name = "Fishman Warrior", NPC = "Fishman Quest Giver", QName = "FishmanWarriors", Island = "Underwater City"},
	{Min = 400, Max = 624, Name = "Fishman Commando", NPC = "Fishman Quest Giver", QName = "FishmanCommandos", Island = "Underwater City"},
	{Min = 625, Max = 649, Name = "Galactic Soldier", NPC = "Cyborg/Galactic Quest Giver", QName = "GalacticSoldiers", Island = "Fountain City"},
	{Min = 650, Max = 699, Name = "Cyborg", NPC = "Cyborg/Galactic Quest Giver", QName = "Cyborgs", Island = "Fountain City"},
	-- SECOND SEA
	{Min = 700, Max = 724, Name = "Raider", NPC = "Kingdom of Rose Quest Giver", QName = "Raiders", Island = "Kingdom of Rose"},
	{Min = 725, Max = 774, Name = "Mercenary", NPC = "Kingdom of Rose Quest Giver", QName = "Mercenaries", Island = "Kingdom of Rose"},
	{Min = 775, Max = 874, Name = "Swan Pirate", NPC = "Kingdom of Rose Quest Giver", QName = "SwanPirates", Island = "Kingdom of Rose"},
	{Min = 875, Max = 899, Name = "Marine Captain", NPC = "Marine Quest Giver", QName = "MarineCaptains", Island = "Green Zone"},
	{Min = 900, Max = 924, Name = "Marine Commodore", NPC = "Marine Quest Giver", QName = "MarineCommodores", Island = "Green Zone"},
	{Min = 925, Max = 949, Name = "Amazon", NPC = "Marine Quest Giver", QName = "Amazons", Island = "Green Zone"},
	{Min = 950, Max = 974, Name = "Zombie", NPC = "Zombie Quest Giver", QName = "Zombies", Island = "Graveyard"},
	{Min = 975, Max = 999, Name = "Vampire", NPC = "Zombie Quest Giver", QName = "Vampires", Island = "Graveyard"},
	{Min = 1000, Max = 1049, Name = "Snow Lurker", NPC = "Snow Mountain Quest Giver", QName = "SnowLurkers", Island = "Snow Mountain"},
	{Min = 1050, Max = 1099, Name = "Winter Warrior", NPC = "Snow Mountain Quest Giver", QName = "WinterWarriors", Island = "Snow Mountain"},
	{Min = 1100, Max = 1149, Name = "Magma Ninja", NPC = "Magma Village Quest Giver", QName = "MagmaNinjas", Island = "Magma Village 2"},
	{Min = 1150, Max = 1199, Name = "Lava Pirate", NPC = "Magma Village Quest Giver", QName = "LavaPirates", Island = "Magma Village 2"},
	{Min = 1200, Max = 1249, Name = "Dark Drone", NPC = "Dark Quest Giver", QName = "DarkDrones", Island = "Dark Realm"},
	{Min = 1250, Max = 1299, Name = "Shadow Master", NPC = "Dark Quest Giver", QName = "ShadowMasters", Island = "Dark Realm"},
	{Min = 1300, Max = 1349, Name = "Ice Admiral", NPC = "Ice Quest Giver", QName = "IceAdmirals", Island = "Ice Castle"},
	{Min = 1350, Max = 1399, Name = "Frost Sorcerer", NPC = "Ice Quest Giver", QName = "FrostSorcerers", Island = "Ice Castle"},
	{Min = 1400, Max = 1499, Name = "Dragon Warrior", NPC = "Dragon Quest Giver", QName = "DragonWarriors", Island = "Dragon Island"},
	{Min = 1500, Max = 1599, Name = "Dragon Keeper", NPC = "Dragon Quest Giver", QName = "DragonKeepers", Island = "Dragon Island"},
	{Min = 1600, Max = 1699, Name = "Demon Fox", NPC = "Demon Quest Giver", QName = "DemonFoxes", Island = "Demon Realm"},
	{Min = 1700, Max = 1799, Name = "Demon King Guard", NPC = "Demon Quest Giver", QName = "DemonKingGuards", Island = "Demon Realm"},
	{Min = 1800, Max = 1899, Name = "Angel Guardian", NPC = "Angel Quest Giver", QName = "AngelGuardians", Island = "Heaven"},
	{Min = 1900, Max = 1999, Name = "Seraphim", NPC = "Angel Quest Giver", QName = "Seraphim", Island = "Heaven"},
	{Min = 2000, Max = 2199, Name = "Celestial Knight", NPC = "Celestial Quest Giver", QName = "CelestialKnights", Island = "Celestial Palace"},
	{Min = 2200, Max = 2399, Name = "Cosmic Overlord", NPC = "Celestial Quest Giver", QName = "CosmicOverlords", Island = "Celestial Palace"},
}

local function MakeDraggable(obj)
	local dragging, dragInput, dragStart, startPos
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = obj.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	obj.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and (input == dragInput) then local delta = input.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end

-- [ KHUNG GIAO DIỆN ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0.6, 0, 0.75, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Visible = false; Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 255); Stroke.Thickness = 2
MakeDraggable(Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0.25, 0, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", Sidebar)
local TabList = Instance.new("Frame", Sidebar); TabList.Size = UDim2.new(1, 0, 1, 0); TabList.BackgroundTransparency = 1; local Layout = Instance.new("UIListLayout", TabList); Layout.Padding = UDim.new(0.02, 0)
local Pages = Instance.new("Frame", Main); Pages.Position = UDim2.new(0.27, 0, 0.03, 0); Pages.Size = UDim2.new(0.7, 0, 0.94, 0); Pages.BackgroundTransparency = 1

local function CreateTab(name, isFirst)
	local b = Instance.new("TextButton", TabList); b.Size = UDim2.new(1, 0, 0, 50); b.Text = name; b.Font = Enum.Font.GothamBold; b.TextSize = 16; b.BackgroundColor3 = isFirst and Color3.fromRGB(0,255,255) or Color3.fromRGB(25,25,30); b.TextColor3 = isFirst and Color3.new(0,0,0) or Color3.new(1,1,1); b.BorderSizePixel = 0
	local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = isFirst; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,2,0); local pl = Instance.new("UIListLayout", p); pl.Padding = UDim.new(0.03, 0)
	b.MouseButton1Click:Connect(function()
		for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
		for _, v in pairs(TabList:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25,25,30); v.TextColor3 = Color3.new(1,1,1) end end
		p.Visible = true; b.BackgroundColor3 = Color3.fromRGB(0, 255, 255); b.TextColor3 = Color3.new(0,0,0)
	end)
	return p
end

local PageHome = CreateTab("🏠 Home", true)
local PagePlayer = CreateTab("👤 Player", false)

-- [ CÁC NÚT ĐIỀU KHIỂN CHÍNH ]
local farmBtn = Instance.new("TextButton", PageHome); farmBtn.Size = UDim2.new(0.96, 0, 0, 50); farmBtn.Text = "AUTO FARM LEVEL: OFF"; farmBtn.Font = Enum.Font.GothamBold; farmBtn.TextSize = 16; farmBtn.BackgroundColor3 = Color3.fromRGB(35,35,40); farmBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", farmBtn)
local flyBtn = Instance.new("TextButton", PageHome); flyBtn.Size = UDim2.new(0.96, 0, 0, 45); flyBtn.Text = "FLY (CAMERA): OFF"; flyBtn.Font = Enum.Font.GothamBold; flyBtn.TextSize = 16; flyBtn.BackgroundColor3 = Color3.fromRGB(35,35,40); flyBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", flyBtn)

farmBtn.MouseButton1Click:Connect(function()
	_G.AutoFarmLevel = not _G.AutoFarmLevel
	farmBtn.Text = "AUTO FARM LEVEL: "..(_G.AutoFarmLevel and "ON" or "OFF")
	farmBtn.BackgroundColor3 = _G.AutoFarmLevel and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,40)

	if _G.AutoFarmLevel then
		_G.Flying = true
		flyBtn.Text = "FLY (CAMERA): ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(0,180,100)
	else
		_G.Flying = false
		_G.FlyTarget = nil
		_G.FlySpeed = 120
		flyBtn.Text = "FLY (CAMERA): OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
	end
end)

-- [ 📦 KHU VỰC CHỌN VŨ KHÍ ]
local wpLabel = Instance.new("TextLabel", PageHome); wpLabel.Size = UDim2.new(0.96, 0, 0, 25); wpLabel.Text = "SELECT WEAPON / CHỌN VŨ KHÍ:"; wpLabel.Font = Enum.Font.GothamBold; wpLabel.TextColor3 = Color3.fromRGB(0,255,255); wpLabel.BackgroundTransparency = 1; wpLabel.TextXAlignment = Enum.TextXAlignment.Left

local wpFrame = Instance.new("Frame", PageHome); wpFrame.Size = UDim2.new(0.96, 0, 0, 45); wpFrame.BackgroundTransparency = 1; local wpLayout = Instance.new("UIListLayout", wpFrame); wpLayout.FillDirection = Enum.FillDirection.Horizontal; wpLayout.Padding = UDim.new(0.02, 0)

local weapons = {"Melee", "Blox Fruit", "Sword"}
local wpButtons = {}

for i, wp in ipairs(weapons) do
	local btn = Instance.new("TextButton", wpFrame)
	btn.Size = UDim2.new(0.31, 0, 1, 0)
	btn.Text = (i == 1 and "1. Combat" or i == 2 and "2. Fruit" or "3. Sword")
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.BackgroundColor3 = (_G.SelectWeapon == wp) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(35,35,40)
	btn.TextColor3 = (_G.SelectWeapon == wp) and Color3.new(0,0,0) or Color3.new(1,1,1)
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		_G.SelectWeapon = wp
		for _, b in pairs(wpButtons) do b.BackgroundColor3 = Color3.fromRGB(35,35,40); b.TextColor3 = Color3.new(1,1,1) end
		btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
		btn.TextColor3 = Color3.new(0,0,0)
	end)
	table.insert(wpButtons, btn)
end

flyBtn.MouseButton1Click:Connect(function() 
	_G.Flying = not _G.Flying 
	flyBtn.Text = "FLY (CAMERA): "..(_G.Flying and "ON" or "OFF")
	flyBtn.BackgroundColor3 = _G.Flying and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,40)
	if not _G.Flying then _G.FlyTarget = nil end
end)

-- [ HÀM ĐEO VŨ KHÍ ]
local function GetWeapon()
	for _, v in pairs(player.Backpack:GetChildren()) do
		if v:IsA("Tool") and v.ToolTip == _G.SelectWeapon then return v end
	end
	for _, v in pairs(player.Character:GetChildren()) do
		if v:IsA("Tool") and v.ToolTip == _G.SelectWeapon then return v end
	end
	for _, v in pairs(player.Backpack:GetChildren()) do if v:IsA("Tool") then return v end end
end

-- [ LẤY LEVEL TỪ LEADERSTATS ]
local function GetQuest()
	local leaderstats = player:FindFirstChild("leaderstats")
	local lv = 1
	if leaderstats then
		local levelStat = leaderstats:FindFirstChild("Level")
		if levelStat then lv = levelStat.Value end
	end
	for _, q in pairs(QuestData) do if lv >= q.Min and lv <= q.Max then return q end end
	return QuestData[1]
end

-- [ THEO DÕI QUEST + TỰ ĐỘNG NỘP QUEST KHI HOÀN THÀNH ]
local currentQuestInfo = nil

-- Dùng WaitForChild thay vì FindFirstChild để đảm bảo tìm thấy RemoteEvent
local questEvents = ReplicatedStorage:WaitForChild("QuestEvents", 10)
local completeQuestEvent = questEvents and questEvents:WaitForChild("CompleteQuest", 10)
local acceptQuestEvent = questEvents and questEvents:WaitForChild("AcceptQuest", 10)
local punchEvent = ReplicatedStorage:WaitForChild("PunchEvent", 10)

if questEvents then
	local questUpdate = questEvents:WaitForChild("QuestUpdate", 10)
	if questUpdate then
		questUpdate.OnClientEvent:Connect(function(name, qName, kills, required, island)
			if name and name ~= "" then
				currentQuestInfo = {Name = name, QName = qName, Kills = kills, Required = required, Island = island}
				-- TỰ ĐỘNG NỘP QUEST khi đủ kill
				if kills >= required and completeQuestEvent then
					task.wait(0.3)
					completeQuestEvent:FireServer()
				end
			else
				currentQuestInfo = nil
			end
		end)
	end
	local questCompleted = questEvents:WaitForChild("QuestCompleted", 10)
	if questCompleted then
		questCompleted.OnClientEvent:Connect(function() currentQuestInfo = nil end)
	end
end

-- [[ ⚔️ HỆ THỐNG NOCLIP ]]
RunService.Stepped:Connect(function()
	if _G.AutoFarmLevel and player.Character then
		for _, v in pairs(player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
	end
end)

local comboCount = 1
local lastPunchTime = 0

-- [[ ⚔️ LOGIC VẬN HÀNH AUTO FARM CHÍNH (ĐÃ FIX TOÀN BỘ) ]]
local questAcceptDebounce = false
local islandsFolder = workspace:FindFirstChild("Islands")

-- Hàm tìm NPC nhanh theo đường dẫn: Islands.[Đảo].NPCs.[Tên]
local function FindNPC(npcName, islandName)
	if not islandsFolder then islandsFolder = workspace:FindFirstChild("Islands") end
	if not islandsFolder then return nil end
	local island = islandsFolder:FindFirstChild(islandName)
	if not island then return nil end
	local npcsFolder = island:FindFirstChild("NPCs")
	if not npcsFolder then return nil end
	local npc = npcsFolder:FindFirstChild(npcName)
	if npc and npc:FindFirstChild("HumanoidRootPart") then return npc end
	return nil
end

-- Hàm tìm quái gần nhất trên đảo
local function FindNearestMob(questName, islandName)
	if not islandsFolder then islandsFolder = workspace:FindFirstChild("Islands") end
	if not islandsFolder then return nil end
	local island = islandsFolder:FindFirstChild(islandName)
	if not island then return nil end
	local enemiesFolder = island:FindFirstChild("Enemies")
	if not enemiesFolder then return nil end

	local bestMob = nil
	local bestDist = math.huge
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	for _, v in pairs(enemiesFolder:GetChildren()) do
		if v.Name == questName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
			local mobDist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
			if mobDist < bestDist then
				bestMob = v
				bestDist = mobDist
			end
			end
		end
	return bestMob
end

task.spawn(function()
	while task.wait(0.1) do
		if _G.AutoFarmLevel and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local q = GetQuest()
			local tool = GetWeapon()
			local hrp = player.Character.HumanoidRootPart

			if tool then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid and tool.Parent ~= player.Character then humanoid:EquipTool(tool) end
			end

			-- Tăng tốc bay khi auto farm
			_G.FlySpeed = 200

			-- KIỂM TRA QUEST ĐÃ HOÀN THÀNH CHƯA → TỰ NỘP
			if currentQuestInfo and currentQuestInfo.Kills >= currentQuestInfo.Required and completeQuestEvent then
				completeQuestEvent:FireServer()
				task.wait(0.5)
				continue
			end

			local hasQuest = currentQuestInfo ~= nil

			if not hasQuest then
				-- CHƯA CÓ QUEST → Bay đến NPC nhận quest
				local npcModel = FindNPC(q.NPC, q.Island)

				if npcModel and npcModel:FindFirstChild("HumanoidRootPart") then
					local npcPos = npcModel.HumanoidRootPart.Position
					local dist = (hrp.Position - npcPos).Magnitude

					-- Bay đến NGAY CHÂN NPC (cùng chiều cao, cách 2 studs)
					_G.FlyTarget = CFrame.new(npcPos + Vector3.new(0, 8, 0))
					_G.FlyStopDistance = 5

					-- Khi đến gần NPC → nhận quest
					if dist < 15 and not questAcceptDebounce then
						questAcceptDebounce = true
						-- Xoay mặt hướng về NPC
						hrp.CFrame = CFrame.new(hrp.Position, npcPos)
						if acceptQuestEvent then
							acceptQuestEvent:FireServer(q.NPC)
						end
						task.wait(1.5)
						questAcceptDebounce = false
					end
				else
					-- Không tìm thấy NPC → bay đến đảo chờ
					if islandsFolder then
						local island = islandsFolder:FindFirstChild(q.Island)
						if island then
							local spawnArea = island:FindFirstChild("EnemySpawn")
							if spawnArea and spawnArea:IsA("BasePart") then
								_G.FlyTarget = CFrame.new(spawnArea.Position + Vector3.new(0, 5, 0))
							end
						end
					end
				end
			else
				-- ĐÃ CÓ QUEST → Tìm quái đánh
				local targetMob = FindNearestMob(q.Name, q.Island)

				if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
					local mobPos = targetMob.HumanoidRootPart.Position
					local dist = (hrp.Position - mobPos).Magnitude

					-- Bay đến trên đầu quái, nhưng dừng ở cách 15 studs
					_G.FlyTarget = CFrame.new(mobPos + Vector3.new(0, 8, 0))
					_G.FlyStopDistance = 15

					-- Khi đủ gần (20 studs) → xoay mặt + đánh
					if dist < 20 then
						-- Xoay mặt hướng về quái
						hrp.CFrame = CFrame.new(hrp.Position, mobPos)

						-- Combo xoay vòng 1→2→3→4
						local now = tick()
						if now - lastPunchTime > 0.4 then
							comboCount = comboCount + 1
							if comboCount > 4 then comboCount = 1 end
							lastPunchTime = now
						end
						if punchEvent then punchEvent:FireServer("Punch", comboCount) end
					end
				else
					-- Không tìm thấy quái → bay về khu spawn chờ
					if islandsFolder then
						local island = islandsFolder:FindFirstChild(q.Island)
						if island then
							local spawnArea = island:FindFirstChild("EnemySpawn")
							if spawnArea and spawnArea:IsA("BasePart") then
								_G.FlyTarget = CFrame.new(spawnArea.Position + Vector3.new(0, 5, 0))
							end
						end
					end
				end
			end
		else
			-- Clean-up khi tắt Auto Farm
			_G.FlySpeed = 120
			_G.FlyTarget = nil
		end
	end
end)



-- [ LOGIC FLY THEO CAMERA + FLY TARGET (BodyVelocity/BodyGyro) ]
task.spawn(function()
	while task.wait() do
		if _G.Flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			-- Tạo BodyVelocity + BodyGyro nếu chưa có
			if not flyBV or not flyBV.Parent then
				flyBV = Instance.new("BodyVelocity", hrp)
				flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
				flyBV.Velocity = Vector3.new(0, 0, 0)
				flyBG = Instance.new("BodyGyro", hrp)
				flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
				flyBG.CFrame = Camera.CFrame
				if humanoid then humanoid.PlatformStand = true end
			end

			if _G.FlyTarget then
				-- Chế độ Auto Farm: Bay đến target
				local targetPos = _G.FlyTarget.Position
				local dir = (targetPos - hrp.Position)
				local dist = dir.Magnitude
				local stopDist = _G.FlyStopDistance or 5

				if dist > stopDist then
					-- Bay về phía target
					flyBV.Velocity = dir.Unit * _G.FlySpeed
					flyBG.CFrame = CFrame.new(hrp.Position, targetPos)
				else
					-- Đã đến gần target → dừng lại, giữ vị trí
					flyBV.Velocity = Vector3.new(0, 0, 0)
					flyBG.CFrame = CFrame.new(hrp.Position, targetPos)
				end
			else
				-- Chế độ tự do: Bay theo camera (chỉ khi bấm phím di chuyển)
				if humanoid and humanoid.MoveDirection.Magnitude > 0 then
					flyBV.Velocity = Camera.CFrame.LookVector * _G.FlySpeed
				else
					flyBV.Velocity = Vector3.new(0, 0, 0)
				end
				flyBG.CFrame = Camera.CFrame
			end
		else
			-- Tắt fly: dọn dẹp BodyVelocity + BodyGyro
			if flyBV then flyBV:Destroy(); flyBV = nil end
			if flyBG then flyBG:Destroy(); flyBG = nil end
			if player.Character then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.PlatformStand = false end
			end
		end
	end
end)

-- Reset fly khi character respawn
player.CharacterAdded:Connect(function()
	_G.FlyTarget = nil
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if flyBG then flyBG:Destroy(); flyBG = nil end
end)

-- NÚT BẬT MENU
local Toggle = Instance.new("TextButton", ScreenGui); Toggle.Size = UDim2.new(0, 60, 0, 60); Toggle.Position = UDim2.new(0.02, 0, 0.45, 0); Toggle.Text = "WL"; Toggle.Font = Enum.Font.GothamBold; Toggle.TextSize = 18; Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Toggle.TextColor3 = Color3.fromRGB(0, 255, 255); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)
