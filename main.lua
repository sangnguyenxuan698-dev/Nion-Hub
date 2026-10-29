-- ===============================================================
-- Tên Hub: Nion Hub
-- Tác giả: VHoc
-- Phiên bản: Full Complete Edition (Ổn định & Tối ưu lâu dài)
-- ===============================================================

pcall(function()
    if getgenv().NionHubLoaded then return end
    getgenv().NionHubLoaded = true
end)

local Sea1 = (game.PlaceId == 2753915549)
local Sea2 = (game.PlaceId == 4442272183)
local Sea3 = (game.PlaceId == 7449423635)

local KillAura = false
local SelectWeapon = "Melee"
local FarmPos = CFrame.new(0,0,0)
local MonFarm = ""
local bringmob = false

-- Hàm hỗ trợ Tween mượt mà & bền bỉ
local function Tween(cf)
    pcall(function()
        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cf.Position).Magnitude
        local speed = 350
        local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = cf})
        tween:Play()
    end)
end

local function Tween2(cf) Tween(cf) end
local function TweenBlock(cf) Tween(cf) end

local function AutoHaki()
    pcall(function()
        if not game.Players.LocalPlayer.Character:FindFirstChild("Buso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

local function EquipTool(toolName)
    pcall(function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local backpack = player.Backpack
        if not char:FindFirstChild(toolName) and backpack:FindFirstChild(toolName) then
            char.Humanoid:EquipTool(backpack:FindFirstChild(toolName))
        end
    end)
end

local function AttackNoCoolDown()
    pcall(function()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

local function RedeemCode(code)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
    end)
end

-- Server Hop Tối Ưu Bền Vững
local hcServerHop = function() end
local function Hop()
    local hcPlaceId = game.PlaceId
    local hcServers = {}
    local hcCursor = ""
    local function TPReturner()
        local v1071
        if hcCursor ~= "" then
            v1071 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. hcPlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. hcCursor))
        else
            v1071 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. hcPlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end
        if v1071.nextPageCursor and (v1071.nextPageCursor ~= "null" and v1071.nextPageCursor ~= nil) then
            hcCursor = v1071.nextPageCursor
        end
        for _, v in pairs(v1071.data) do
            local canConnect = true
            local serverId = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, storedId in pairs(hcServers) do
                    if serverId == tostring(storedId) then canConnect = false end
                end
                if canConnect == true then
                    table.insert(hcServers, serverId)
                    task.wait()
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(hcPlaceId, serverId, game.Players.LocalPlayer)
                    end)
                    task.wait()
                end
            end
        end
    end
    hcServerHop = function()
        while task.wait() do
            pcall(function()
                TPReturner()
                if hcCursor ~= "" then TPReturner() end
            end)
        end
    end
    hcServerHop()
end

-- ==================== KHỞI TẠO UI THƯ VIỆN ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Nion Hub | VHoc Edition", "BloodTheme")

local Tabs = {
    Main = Window:NewTab("Main"),
    Race = Window:NewTab("Race V4"),
    Shop = Window:NewTab("Shop"),
    Sea = Window:NewTab("Sea Events"),
    Misc = Window:NewTab("Misc"),
    Setting = Window:NewTab("Setting")
}

-- 1. TAB MAIN & FARM SỰ KIỆN
local MainSection = Tabs.Main:NewSection("Farm Tổng Hợp")
MainSection:NewToggle("Auto Farm Summer Token", "Tự động farm Summer Token theo từng Sea", false, function(v) _G.FarmSummer = v end)

local function getSummerPos()
    local id = game.PlaceId
    if id == 2753915549 then return CFrame.new(924.405, 6.366, 4476.727)
    elseif id == 4442272183 then return CFrame.new(-5246.478, 66.381, -6015.48)
    elseif id == 7449423635 then return CFrame.new(-10334.821, 390.837, -8572.301)
    end; return nil
end

task.spawn(function()
    while task.wait() do
        if _G.FarmSummer then pcall(function()
            local cf = getSummerPos()
            if not cf then return end
            Tween(cf * CFrame.new(0, 50, 0))
            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 and hum.DisplayName and hum.DisplayName:find("%[Electrified%]") then
                    repeat
                        task.wait()
                        AutoHaki(); EquipTool(SelectWeapon)
                        hrp.CanCollide = false; hum.WalkSpeed = 0
                        pcall(function() mob.Head.CanCollide = false end)
                        Tween(hrp.CFrame * CFrame.new(0,10,0))
                        AttackNoCoolDown()
                        FarmPos = hrp.CFrame; MonFarm = mob.Name; bringmob = true
                    until not _G.FarmSummer or not mob.Parent or hum.Health <= 0
                    bringmob = false
                end
            end
        end) end
    end
end)

-- Auto Raid Pirate
MainSection:NewToggle("Farm Pirate Raid", "Tự động dọn dẹp hải tặc phóng pháo", false, function(v) _G.AutoRaidPirate = v end)
task.spawn(function()
    while wait() do
        if _G.AutoRaidPirate then pcall(function()
            local raidPos = CFrame.new(-5496.17432, 313.768921, -2841.53027)
            local center = Vector3.new(-5539.31, 313.80, -2972.37)
            if (center - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if _G.AutoRaidPirate and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                            wait(); AutoHaki(); EquipTool(SelectWeapon); bringmob = true
                            v.HumanoidRootPart.CanCollide = false; v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                            Tween(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0)); AttackNoCoolDown()
                        until v.Humanoid.Health <= 0 or not v.Parent or not _G.AutoRaidPirate
                        bringmob = false
                    end
                end
            else Tween(raidPos) end
        end) end
    end
end)

-- 2. TAB RACE / CHỦNG TỘC
local RaceSection = Tabs.Race:NewSection("Nâng Cấp & Luyện Tộc")
RaceSection:NewToggle("Cày Luyện Tộc", "Tự động biến thân và đánh quái tích lũy", false, function(p1061)
    _G.AutoBoneNoQuest = p1061
end)
RaceSection:NewToggle("Mua Gear", "Tự động mua cấp độ tiếp theo của tộc V4", false, function(p1062)
    _G.AutoUpgrade = p1062
    if _G.AutoUpgrade then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
    end
end)

-- 3. TAB SHOP (MUA NHANH VŨ KHÍ, VÕ, HAKI)
local ShopSection = Tabs.Shop:NewSection("Cửa Hàng Kỹ Năng & Vũ Khí")
ShopSection:NewButton("Mua Sanguine Art", "Tự động mua võ mới nhất", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt")
end)
ShopSection:NewButton("Mua Godhuman", "Tự động mua Super Fist", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
end)
ShopSection:NewButton("Đổi Tộc Ngẫu Nhiên", "Dùng fragment đổi tộc", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
end)

-- 4. TAB SEA EVENTS & ĐẢO DUNH NHAM
local SeaSection = Tabs.Sea:NewSection("Sự Kiện Biển & Đảo Dung Nham")
SeaSection:NewToggle("Bay Đến Đảo Dung Nham", "Auto di chuyển tới PrehistoricIsland", false, function(p1151)
    _G.TweenToPrehistoric = p1151
end)
SeaSection:NewToggle("Phòng Thủ Đảo Dung Nham", "Auto dọn quái & dung nham bảo vệ đảo", false, function(p1155)
    _G.AutoDefendVolcano = p1155
end)

-- 5. TAB MISC & TỐI ƯU
local MiscSection = Tabs.Misc:NewSection("Tiện Ích & Hiệu Suất")
MiscSection:NewButton("Tham Gia Máy Chủ Lại", "Teleport lại server hiện tại", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)
MiscSection:NewButton("Đổi Máy Chủ Nhanh", "Tìm server trống tự động", function()
    Hop()
end)
MiscSection:NewButton("Xóa Sương Mù (Clear Fog)", "Giúp tầm nhìn đi biển cực xa", function()
    local v1091 = game:GetService("Lighting")
    if v1091:FindFirstChild("BaseAtmosphere") then v1091.BaseAtmosphere:Destroy() end
    if v1091:FindFirstChild("SeaTerrorCC") then v1091.SeaTerrorCC:Destroy() end
    v1091.FogEnd = 100000
end)
MiscSection:NewButton("FPS Boost (Tối Ưu Máy Yếu)", "Tắt hiệu ứng nặng, tăng FPS tối đa", function()
    pcall(function()
        settings().Rendering.QualityLevel = "Level01"
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then v.Enabled = false
            end
        end
    end)
end)
MiscSection:NewButton("Nhập Tất Cả Code Game", "Redeem toàn bộ code nhận quà & x2 EXP", function()
    local _codeList = {"KITT_RESET","Sub2UncleKizaru","SUB2GAMERROBOT_RESET1","Sub2Fer999","Enyu_is_Pro","JCWK","StarcodeHEO","MagicBus","KittGaming","Sub2CaptainMaui","Sub2OfficalNoobie","TheGreatAce","Sub2NoobMaster123","Sub2Daigrock","Axiore","StrawHatMaine","TantaiGaming","Bluxxy","SUB2GAMERROBOT_EXP1","Chandler","NOMOREHACK","BANEXPLOIT","WildDares","BossBuild","GetPranked","EARN_FRUITS","FIGHT4FRUIT","NOEXPLOITER","NOOB2ADMIN","CODESLIDE","ADMINHACKED","ADMINDARES","fruitconcepts","krazydares","TRIPLEABUSE","SEATROLLING","24NOADMIN","REWARDFUN","NEWTROLL","fudd10_v2","Fudd10","Bignews","SECRET_ADMIN"}
    for _, code in ipairs(_codeList) do
        RedeemCode(code)
        task.wait(0.1)
    end
end)

-- 6. TAB SETTING (KỸ NĂNG ĐẶC BIỆT & NÂNG ĐIỂM)
local SettingSection = Tabs.Setting:NewSection("Kỹ Năng Đặc Biệt & Stats")
SettingSection:NewToggle("Infinite Soru", "Lướt Soru liên tục không hồi chiêu", false, function(v)
    _G.InfSoru = v
    task.spawn(function()
        while task.wait(1) do
            if _G.InfSoru then pcall(function()
                for _, func in next, getgc() do
                    if getfenv(func).script == game.Players.LocalPlayer.Character:WaitForChild("Soru") then
                        for idx, val in pairs(debug.getupvalues(func)) do
                            if type(val)=="table" and val.LastUse then
                                setupvalue(func, idx, {LastAfter=0, LastUse=0})
                            end
                        end
                    end
                end
            end) end
        end
    end)
end)

SettingSection:NewToggle("Dodge No Cooldown", "Né đòn vô hạn không giới hạn thời gian", false, function(v)
    _G.DodgeCD = v
    task.spawn(function()
        while task.wait() do
            if _G.DodgeCD then pcall(function()
                for _, func in next, getgc() do
                    if typeof(func)=="function" and getfenv(func).script == game.Players.LocalPlayer.Character:WaitForChild("Dodge") then
                        for idx, val in next, getupvalues(func) do
                            if tostring(val)=="0.4" then setupvalue(func, idx, 0) end
                        end
                    end
                end
            end) end
        end
    end)
end)

print('✅ Nion Hub (VHoc) - Khởi chạy hoàn tất, vận hành bền bỉ lâu dài!')
