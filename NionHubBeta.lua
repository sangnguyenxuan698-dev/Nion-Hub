-- Khoi tao Thu vien Redz Lib (Version Moinhat / Fix bug)
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))()

-- Tao Cua so Menu chinh (Window)
local Window = RedzLib:MakeWindow({
    Title = "Nion Hub | Blox Fruits",
    SubTitle = "By VHoc",
    SaveFolder = "NionHubConfig"
})

-- Tạo nút thu nhỏ/mở lại Menu trên màn hình điện thoại (Icon Toggle Button)
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://18751493361", BackgroundTransparency = 0.5 },
    Corner = { CornerRadius = UDim.new(0, 6) }
})

-- ===================================================
-- TAB 1: THÔNG TIN (INFO)
-- ===================================================
local TabInfo = Window:MakeTab({"Thông Tin", "info"})

TabInfo:AddSection({"Thông tin Script"})
TabInfo:AddDiscordInvite({
    Title = "Nion Hub Community",
    Desc = "Tham gia Discord để cập nhật script mới nhất!",
    Logo = "rbxassetid://18751493361",
    Invite = "https://discord.gg/nionhub"
})

TabInfo:AddParagraph({"Tác Giả", "Script được phát triển bởi VHoc"})
TabInfo:AddParagraph({"Trạng Thái", "Hoạt động tốt trên Mobile / Cloud Phone!"})

-- ===================================================
-- TAB 2: AUTO FARM (TỰ ĐỘNG CÀY)
-- ===================================================
local TabFarm = Window:MakeTab({"Auto Farm", "swords"})

TabFarm:AddSection({"Tự Động Cày Level"})

-- Toggle Auto Farm Level
TabFarm:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmLevel = Value
        print("Auto Farm Level: ", Value)
        
        -- Vòng lặp Auto Farm mẫu
        task.spawn(function()
            while _G.AutoFarmLevel do
                task.wait(0.1)
                -- Code Auto Farm Level của bạn đặt ở đây
            end
        end)
    end
})

-- Dropdown Chọn Vũ Khí
TabFarm:AddDropdown({
    Name = "Chọn Vũ Khí Sử Dụng",
    Options = {"Melee", "Sword", "Demon Fruit"},
    Default = "Melee",
    Callback = function(Select)
        _G.SelectWeapon = Select
        print("Vũ khí đã chọn: ", Select)
    end
})

TabFarm:AddSection({"Tính Năng Khác"})

-- Button Gom Quái
TabFarm:AddButton({
    Name = "Gom Quái (Bring Mob)",
    Callback = function()
        print("Đã bật Gom Quái!")
    end
})

-- ===================================================
-- TAB 3: TRÁI ÁC QUỶ (FRUIT)
-- ===================================================
local TabFruit = Window:MakeTab({"Trái Ác Quỷ", "apple"})

TabFruit:AddSection({"Tự Động Mua & Nhặt Trái"})

TabFruit:AddButton({
    Name = "Tự Động Mua Trái Ngẫu Nhiên (Random Fruit)",
    Callback = function()
        -- Code Mua Trái Random
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
    end
})

TabFruit:AddToggle({
    Name = "Tự Động Cất Trái Vào Rương (Auto Store)",
    Default = true,
    Callback = function(Value)
        _G.AutoStoreFruit = Value
    end
})

-- ===================================================
-- TAB 4: CÀI ĐẶT & TỐI ƯU (SETTINGS)
-- ===================================================
local TabSettings = Window:MakeTab({"Cài Đặt", "settings"})

TabSettings:AddSection({"Tối Ưu Cloud Phone / Giảm Lag"})

TabSettings:AddButton({
    Name = "Bật Chế Độ Giảm Lag (Fast Mode)",
    Callback = function()
        -- Mẫu Code Xóa Đồ Họa Nặng Để Tăng FPS
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
        end
        print("Đã tối ưu đồ họa cho Cloud Phone!")
    end
})

TabSettings:AddButton({
    Name = "Hủy Menu (Destroy UI)",
    Callback = function()
        RedzLib:Destroy()
    end
})
