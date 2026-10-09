-- ===============================================================
--          VHOC HUB - BLOX FRUITS [UPDATE 30] (FLUENT UI)
--          Dark Minimalist & Siêu mượt mà cho Mobile/Máy yếu
-- ===============================================================

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("FluentHubUI") then
    CoreGui.FluentHubUI:Destroy()
end

-- Sử dụng Fluent UI (Dark theme siêu ngầu, tối giản, mượt mà)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/Fluent.lua"))()

local Window = Fluent:CreateWindow({
    Title = "VHoc Hub | Blox Fruits [Update 30]",
    SubTitle = "Dark Edition - Max Level 3000",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 340),
    Acrylic = false, -- Tắt hiệu ứng mờ kính để giữ FPS tối đa cho máy yếu
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Khởi tạo các Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Chính / Farm", Icon = "home" }),
    Fruit = Window:AddTab({ Title = "Trái Ác Quỷ", Icon = "gift" }),
    Raid = Window:AddTab({ Title = "Đột Kích (Raid)", Icon = "sword" }),
    Sea = Window:AddTab({ Title = "Sự Kiện Biển", Icon = "compass" }),
    Shop = Window:AddTab({ Title = "Cửa Hàng", Icon = "shopping-cart" }),
    Setting = Window:AddTab({ Title = "Cài Đặt", Icon = "settings" }),
    Misc = Window:AddTab({ Title = "Tiện Ích", Icon = "tool" })
}

local Options = Fluent.Options

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
local MainGroup = Tabs.Main:AddLeftGroupbox("Hệ Thống Cày Cấp")

MainGroup:AddToggle("ToggleFarm", {
    Title = "Bật/Tắt Auto Farm Level",
    Default = false
}):OnChanged(function()
    getgenv().AutoFarm = Options.ToggleFarm.Value
end)

MainGroup:AddDropdown("DropWeapon", {
    Title = "Chọn Vũ Khí Farm",
    Values = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Multi = false,
    Default = 1,
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
                            pcall(function() sethiddenproperty(plr, "SimulationRadius", math.huge) end)
                        until not getgenv().AutoFarm or not enemy.Parent or enemy.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- ================= TAB 2: FRUIT (TRÁI ÁC QUỶ) =================
local FruitGroup = Tabs.Fruit:AddLeftGroupbox("Kho & Cửa Hàng Trái")

FruitGroup:AddButton({
    Title = "Tự Động Cất Trái (Store Fruit)",
    Callback = function()
        pcall(function()
            for _, v in pairs(plr.Backpack:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Fruit") then
                    rs.Remotes.CommF_:InvokeServer("StoreFruit", v.Name)
                end
            end
        end)
    end
})

FruitGroup:AddButton({
    Title = "Random Trái Ác Quỷ",
    Callback = function()
        pcall(function() rs.Remotes.CommF_:InvokeServer("Cousin", "Buy") end)
    end
})

-- ================= TAB 3: RAID (ĐỘT KÍCH) =================
local RaidGroup = Tabs.Raid:AddLeftGroupbox("Chức Năng Đột Kích")

RaidGroup:AddToggle("ToggleAwake", {
    Title = "Tự Động Thức Tỉnh Kỹ Năng",
    Default = false
}):OnChanged(function()
    getgenv().AutoAwaken = Options.ToggleAwake.Value
end)

task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoAwaken then
            pcall(function() rs.Remotes.CommF_:InvokeServer("Awakener", "Awaken") end)
        end
    end
end)

-- ================= TAB 4: SEA (SỰ KIỆN BIỂN) =================
local SeaGroup = Tabs.Sea:AddLeftGroupbox("Di Chuyển Nhanh")

SeaGroup:AddButton({
    Title = "Bay Đến Đảo Gần Nhất",
    Callback = function() Tween(CFrame.new(0, 300, 0)) end
})

-- ================= TAB 5: SHOP (CỬA HÀNG) =================
local ShopGroup = Tabs.Shop:AddLeftGroupbox("Mua Kỹ Năng Cơ Bản")

ShopGroup:AddButton({
    Title = "Mua Buso Haki",
    Callback = function() rs.Remotes.CommF_:InvokeServer("BuyHaki", "Buso") end
})
ShopGroup:AddButton({
    Title = "Mua Soru",
    Callback = function() rs.Remotes.CommF_:InvokeServer("BuyHaki", "Soru") end
})
ShopGroup:AddButton({
    Title = "Mua Ken Haki",
    Callback = function() rs.Remotes.CommF_:InvokeServer("KenTalk", "Buy") end
})

-- ================= TAB 6: SETTING (CÀI ĐẶT) =================
local SettingGroup = Tabs.Setting:AddLeftGroupbox("Auto Nâng Điểm Kỹ Năng")
local _spMelee, _spDef, _spSword, _spGun, _spFruit = false, false, false, false, false

SettingGroup:AddToggle("SPMelee", {Title = "Nâng Melee", Default = false}):OnChanged(function(v) _spMelee = v end)
SettingGroup:AddToggle("SPDef", {Title = "Nâng Defense", Default = false}):OnChanged(function(v) _spDef = v end)
SettingGroup:AddToggle("SPSword", {Title = "Nâng Sword", Default = false}):OnChanged(function(v) _spSword = v end)
SettingGroup:AddToggle("SPGun", {Title = "Nâng Gun", Default = false}):OnChanged(function(v) _spGun = v end)
SettingGroup:AddToggle("SPFruit", {Title = "Nâng Trái Ác Quỷ", Default = false}):OnChanged(function(v) _spFruit = v end)

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

-- ================= TAB 7: MISC (TIỆN ÍCH & TỐI ƯU) =================
local MiscGroup = Tabs.Misc:AddLeftGroupbox("Tối Ưu Hóa & Tiện Ích")

MiscGroup:AddButton({
    Title = "Tối Ưu FPS Boost (Tắt Hiệu Ứng Nặng)",
    Callback = function()
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

MiscGroup:AddButton({
    Title = "Nhập Tất Cả Code Update 30 Mới Nhất",
    Callback = function()
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

Fluent:Notify({
    Title = "VHoc Hub Loaded",
    Content = "Đã tải giao diện Fluent Dark tối giản thành công!",
    Duration = 5
})

print("✅ VHoc Hub [Fluent Dark] đã khởi chạy thành công!")
