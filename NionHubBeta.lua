-- ===============================================================
--                 VHOC HUB - BLOX FRUITS [UPDATE 30]
--          Tối ưu hóa siêu mượt cho máy yếu / Mobile / Roblox
-- ===============================================================

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("VHocHubUI") then
    CoreGui.VHocHubUI:Destroy()
end

-- Sử dụng Rayfield UI (Cực kỳ ổn định và nhẹ mượt cho máy yếu)
local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
    Title = "VHoc Hub | Blox Fruits [Update 30]",
    SubTitle = "Tối Ưu Máy Yếu - Max Level 3000",
    TabWidth = 160,
    Size = UDim2.new(0, 560, 0, 320),
    Acrylic = false, -- Tắt hiệu ứng mờ nặng để cứu FPS cho máy yếu
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Khởi tạo các Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Chính / Farm", Icon = "rbxassetid://6034328889" }),
    Fruit = Window:AddTab({ Title = "Trái Ác Quỷ", Icon = "rbxassetid://6023426915" }),
    Raid = Window:AddTab({ Title = "Đột Kích (Raid)", Icon = "rbxassetid://6023426915" }),
    Sea = Window:AddTab({ Title = "Sự Kiện Biển", Icon = "rbxassetid://6034328889" }),
    Shop = Window:AddTab({ Title = "Cửa Hàng", Icon = "rbxassetid://6034328889" }),
    Setting = Window:AddTab({ Title = "Cài Đặt", Icon = "rbxassetid://6023426915" }),
    Misc = Window:AddTab({ Title = "Tiện Ích", Icon = "rbxassetid://6034328889" })
}

-- Biến toàn cục
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().SelectWeapon = "Melee"
getgenv().Fast_Delay = 0.05
getgenv().AntiBand = true

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")

-- Hàm hỗ trợ cốt lõi
function AutoHaki()
    pcall(function()
        if plr.Character and not plr.Character:FindFirstChild("HasBuso") then
            rs.Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

function EquipTool(toolName)
    pcall(function()
        local char = plr.Character
        local backpack = plr.Backpack
        if char and not char:FindFirstChildOfClass("Tool") then
            local tool = backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
            if tool then char.Humanoid:EquipTool(tool) end
        end
    end)
end

function Tween(cf)
    pcall(function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cf
        end
    end)
end

-- ================= TAB 1: MAIN (FARM & CÀY CẤP) =================
Tabs.Main:AddSection("Hệ Thống Farm (Hỗ trợ Update 30 - Max 3000)")
Tabs.Main:AddToggle("ToggleFarm", {
    ["Title"] = "Bật/Tắt Auto Farm Level",
    ["Default"] = false
}):OnChanged(function(v)
    getgenv().AutoFarm = v
end)

Tabs.Main:AddDropdown("DropWeapon", {
    ["Title"] = "Chọn Vũ Khí Farm",
    ["Values"] = {"Melee", "Sword", "Gun", "Blox Fruit"},
    ["Default"] = "Melee"
}):OnChanged(function(v)
    getgenv().SelectWeapon = v
end)

task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            pcall(function()
                AutoHaki()
                EquipTool(getgenv().SelectWeapon)
                for _, enemy in pairs(ws.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        repeat
                            task.wait(getgenv().Fast_Delay)
                            Tween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                            enemy.HumanoidRootPart.CanCollide = false
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        until not getgenv().AutoFarm or not enemy.Parent or enemy.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- ================= TAB 2: FRUIT (TRÁI ÁC QUỶ) =================
Tabs.Fruit:AddSection("Kho & Lưu Trữ Trái")
Tabs.Fruit:AddButton({
    ["Title"] = "Tự Động Cất Trái (Store Fruit)",
    ["Callback"] = function()
        pcall(function()
            for _, v in pairs(plr.Backpack:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Fruit") then
                    rs.Remotes.CommF_:InvokeServer("StoreFruit", v.Name)
                end
            end
        end)
    end
})

Tabs.Fruit:AddButton({
    ["Title"] = "Random Trái Ác Quỷ",
    ["Callback"] = function()
        pcall(function()
            rs.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        end)
    end
})

-- ================= TAB 3: RAID (ĐỘT KÍCH) =================
Tabs.Raid:AddSection("Chức Năng Đột Kích")
Tabs.Raid:AddToggle("ToggleAwake", {
    ["Title"] = "Tự Động Thức Tỉnh Kỹ Năng",
    ["Default"] = false
}):OnChanged(function(v)
    getgenv().AutoAwaken = v
end)

task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoAwaken then
            pcall(function()
                rs.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
            end)
        end
    end
end)

-- ================= TAB 4: SEA (SỰ KIỆN BIỂN) =================
Tabs.Sea:AddSection("Tính Năng Di Chuyển & Biển")
Tabs.Sea:AddButton({
    ["Title"] = "Bay Đến Đảo Gần Nhất",
    ["Callback"] = function()
        Tween(CFrame.new(0, 300, 0))
    end
})

-- ================= TAB 5: SHOP (CỬA HÀNG) =================
Tabs.Shop:AddSection("Mua Khả Năng Cơ Bản")
Tabs.Shop:AddButton({
    ["Title"] = "Mua Buso Haki",
    ["Callback"] = function() rs.Remotes.CommF_:InvokeServer("BuyHaki", "Buso") end
})
Tabs.Shop:AddButton({
    ["Title"] = "Mua Soru",
    ["Callback"] = function() rs.Remotes.CommF_:InvokeServer("BuyHaki", "Soru") end
})
Tabs.Shop:AddButton({
    ["Title"] = "Mua Ken Haki",
    ["Callback"] = function() rs.Remotes.CommF_:InvokeServer("KenTalk", "Buy") end
})

-- ================= TAB 6: SETTING (CÀI ĐẶT) =================
Tabs.Setting:AddSection("Nâng Điểm Kỹ Năng Tự Động")
local _spMelee, _spDef, _spSword, _spGun, _spFruit = false, false, false, false, false
Tabs.Setting:AddToggle("SPMelee", {["Title"] = "Melee", ["Default"] = false}):OnChanged(function(v) _spMelee = v end)
Tabs.Setting:AddToggle("SPDef", {["Title"] = "Defense", ["Default"] = false}):OnChanged(function(v) _spDef = v end)
Tabs.Setting:AddToggle("SPSword", {["Title"] = "Sword", ["Default"] = false}):OnChanged(function(v) _spSword = v end)
Tabs.Setting:AddToggle("SPGun", {["Title"] = "Gun", ["Default"] = false}):OnChanged(function(v) _spGun = v end)
Tabs.Setting:AddToggle("SPFruit", {["Title"] = "Trái Ác Quỷ", ["Default"] = false}):OnChanged(function(v) _spFruit = v end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if plr.Data.Points.Value >= 1 then
                local function ap(s) rs.Remotes.CommF_:InvokeServer("AddPoint", s, 1) end
                if _spMelee then ap("Melee") end
                if _spDef then ap("Defense") end
                if _spSword then ap("Sword") end
                if _spGun then ap("Gun") end
                if _spFruit then ap("Demon Fruit") end
            end
        end)
    end
end)

-- ================= TAB 7: MISC (TIỆN ÍCH & TỐI ƯU MÁY YẾU) =================
Tabs.Misc:AddSection("Tối Ưu Hóa Máy Yếu & FPS")
Tabs.Misc:AddButton({
    ["Title"] = "Tối Ưu FPS Boost (Tắt Hiệu Ứng Nặng)",
    ["Callback"] = function()
        pcall(function()
            settings().Rendering.QualityLevel = "Level01"
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Fire") or v:IsA("Smoke") then v.Enabled = false
                end
            end
        end)
    end
})

Tabs.Misc:AddButton({
    ["Title"] = "Đổi Server Nhanh (Server Hop)",
    ["Callback"] = function()
        pcall(function()
            local Http = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(Servers.data) do
                if s.playing < s.maxPlayers then
                    TPS:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                    break
                end
            end
        end)
    end
})

Tabs.Misc:AddButton({
    ["Title"] = "Nhập Tất Cả Code Update 30 Mới Nhất",
    ["Callback"] = function()
        local codeList = {
            "SUB2GAMERROBOT_RESET1", "ADMINDARES", "NOOB2ADMIN", "KITT_RESET", 
            "Sub2Fer999", "Enyu_is_Pro", "MagicBus", "KittGaming", "Sub2CaptainMaui",
            "Sub2OfficialNoobie", "TheGreatAce", "Sub2NoobMaster123", "Sub2Daigrock", "Axiore"
        }
        for _, code in ipairs(codeList) do
            pcall(function() rs.Remotes.Redeem:InvokeServer(code) end)
            task.wait(0.1)
        end
    end
})

print("✅ VHoc Hub [Update 30] đã load thành công toàn bộ tính năng mượt mà!")
