-- Fruit Battlegrounds
-- AntiAFK
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
-- Important Variables
local Players            =  game:GetService('Players')
local LocalPlayer        =  Players.LocalPlayer
local Backpack           =  LocalPlayer.Backpack
local PlayerGui          =  LocalPlayer.PlayerGui
local ReplicatedStorage  =  game:GetService("ReplicatedStorage")
-- Variables
local VirtualInputManager  =  game:GetService('VirtualInputManager')
local Data                 =  LocalPlayer['MAIN_DATA']
local UI                   =  PlayerGui.UI
-- Tables
local Numbers = {
    ["1"] = 49,
    ["2"] = 50,
    ["3"] = 51,
    ["4"] = 52,
    ["5"] = 53,
    ["6"] = 54,
    ["7"] = 55,
    ["8"] = 56,
    ["9"] = 57
}
-- GetLevel
local function GetLevel()
    return tostring(Data.Fruits[tostring(Data.Slots[tostring(Data.Slot.Value)].Value)].Level.Value)
end
-- GetStamina
local function GetStamina()
    return (tonumber(GetLevel()) * 4) + 200
end
-- Percent
local function Percent(Part, Whole)
    return (Part / Whole) * 100
end
-- Respawn
local function Respawn()
    require(ReplicatedStorage.Loader).ServerEvent('Core', 'LoadCharacter', {})
    require(ReplicatedStorage.Loader).ServerEvent('Main', 'LoadCharacter')
    if (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) and LocalPlayer.Character:WaitForChild('Humanoid',2) then
        Workspace.CurrentCamera.CameraSubject =  LocalPlayer.Character.Humanoid
        game:GetService('StarterGui'):SetCoreGuiEnabled('Backpack',false)
        game:GetService('StarterGui'):SetCoreGuiEnabled('PlayerList',true)
        game:GetService('StarterGui'):SetCoreGuiEnabled('Chat',true)
        UI.MainMenu.Visible  =  false
        UI.HUD.Visible       =  true
    end
end
-- AutoFarm : Attack
task.spawn(function()
    while AutoFarm do task.wait()
        if (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) and LocalPlayer.Character:WaitForChild('HumanoidRootPart',2) then
            for i,v in pairs(UI.Hotbar:GetChildren()) do
                if tonumber(v.Name) then
                    VirtualInputManager:SendKeyEvent(true,Numbers[v.Name],false,game)
                    if LocalPlayer.Character:FindFirstChildOfClass('Tool') and task.wait(0.1) then
                        VirtualInputManager:SendMouseButtonEvent(0,0,0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0,0,0, false, game, 1)
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end)
-- AutoFarm : Position
task.spawn(function()
    while AutoFarm do task.wait()
        if (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) and LocalPlayer.Character:WaitForChild('HumanoidRootPart',2) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-304, 697, -1241)
        end
    end
end)
-- AutoFarm : Respawn : 1/3
task.spawn(function()
    while AutoFarm do task.wait()
        -- Hide Gui On Death
        if LocalPlayer.Character == nil then
            UI.HUD.Visible       =  false
            UI.Safezone.Visible  =  false
        end
        -- Hide Gui On Spawn
        if (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) and LocalPlayer.Character:WaitForChild('Humanoid',2) then
            game:GetService('StarterGui'):SetCoreGuiEnabled('Backpack',false)
            game:GetService('StarterGui'):SetCoreGuiEnabled('PlayerList',true)
            game:GetService('StarterGui'):SetCoreGuiEnabled('Chat',true)
            UI.MainMenu.Visible  =  false
            UI.HUD.Visible       =  true
        end
        -- Fix Camera On Spawn
        if (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) and LocalPlayer.Character:WaitForChild('Humanoid',2) then
            Workspace.CurrentCamera.CameraSubject =  LocalPlayer.Character.Humanoid
            Workspace.CurrentCamera.CameraType    =  Enum.CameraType.Custom
        end
    end
end)
-- AutoFarm : Respawn : 2/3
task.spawn(function()
    while AutoFarm do task.wait()
        if (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) then
            if Percent(LocalPlayer.Character:WaitForChild('Stats',2):GetAttribute("Stamina"),GetStamina()) <= getgenv().Stamina then
                LocalPlayer.Character:BreakJoints()
            end
        end
    end
end)
-- AutoFarm : Respawn : 3/3
task.spawn(function()
    while AutoFarm do task.wait()
        if LocalPlayer.Character == nil and UI.HUD.Visible == false then
            Respawn()
        end
    end
end)
