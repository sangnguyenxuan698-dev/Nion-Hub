-- ===============================================================
--          VHOC HUB - BLOX FRUITS [UPDATE 30] (FIXED)
-- ===============================================================

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("FluentHubUI") then
    CoreGui.FluentHubUI:Destroy()
end

-- Sử dụng link Raw trực tiếp của Fluent UI để tránh lỗi chuyển hướng trên máy ảo
local successLoad, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Main.lua"))()
end)

if not successLoad or not Fluent then
    warn("Không thể tải được Fluent UI! Kiểm tra lại mạng máy ảo.")
    return
end

local Window = Fluent:CreateWindow({
    Title = "VHoc Hub | Blox Fruits [Update 30]",
    SubTitle = "Dark Edition - Max Level 3000",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 340),
    Acrylic = false,
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
getgenv().SelectWeapon = "Melee"
getgenv().Fast_Delay = 0.05

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

-- ================= TAB 2: FRUIT =================
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

-- ================= TAB 7: MISC =================
local MiscGroup = Tabs.Misc:AddLeftGroupbox("Tối Ưu Hóa & Tiện Ích")
MiscGroup:AddButton({
    Title = "Tối Ưu FPS Boost (Tắt Hiệu Ứng Nặng)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = "Level01"
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
                end
            end
        end)
    end
})

Fluent:Notify({
    Title = "VHoc Hub Loaded",
    Content = "Đã tải giao diện thành công!",
    Duration = 5
})

print("✅ VHoc Hub [Fluent Dark Raw] đã khởi chạy thành công!")
