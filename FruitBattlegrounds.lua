-- Fruit Battlegrounds
-- AntiAFK
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end
-- Check    
if getgenv().ScriptLoaded then
    getgenv().CharacterAdded:Disconnect()
    getgenv().CharacterDeath:Disconnect()
end
-- Load
getgenv().ScriptLoaded = true
-- Fruit Battlegrounds
-- Important Variables
local Players            =  game:GetService('Players')
local LocalPlayer        =  Players.LocalPlayer
local Backpack           =  LocalPlayer.Backpack
local PlayerGui          =  LocalPlayer.PlayerGui
local ReplicatedStorage  =  game:GetService('ReplicatedStorage')
-- Variables
local MainData  =  LocalPlayer:WaitForChild('MAIN_DATA')
local Fruit     =  MainData:WaitForChild('Fruits'):WaitForChild(MainData:WaitForChild('Slots')[MainData:WaitForChild('Slot').Value].Value)
local UI        =  PlayerGui.UI
local Blacklist =  {"Kurouzu"}
-- Play Button
local Buttons, PlayFunction
for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v, "Buttons") and rawget(v, "Hovering") then
       Buttons = v.Buttons
       break
    end
end
for i,v in pairs(Buttons) do
   if i.Name == "Play" then
       PlayFunction = v.Click
       break
   end
end
local function Play()
    PlayFunction()
end
-- GetStamina
local function GetStamina()
    return (tonumber(Fruit.Level.Value) * 4) + 200
end
-- Percent
local function Percent(Part, Whole)
    return (Part / Whole) * 100
end
-- Character Added
getgenv().CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(Character)
    task.spawn(function()
        while Autofarm do task.wait()
            pcall(function()
                -- Attack
                for i,v in pairs(LocalPlayer:WaitForChild('Backpack'):GetChildren()) do
                    if v.ClassName == 'Tool' then
                        local Attack;
                        if v:GetAttribute('Name') then
                            Attack = v:GetAttribute('Name')
                        else
                            Attack = v.Name:gsub(" ","")
                        end
                        if table.find(Blacklist,Attack) == nil then
                            local args = {
                                [1] = Fruit.Name,
                                [2] = Attack,
                                [3] = {
                                    ["MouseRay"] = {},
                                    ["Ground"] = {
                                        ["Instance"] = Instance.new("Part"),
                                        ["Position"] = Vector3.new(0,0,0)
                                    }
                                }
                            }
                        
                        game:GetService("ReplicatedStorage").Replicator:InvokeServer(unpack(args))
                        end
                    end
                end
                -- Position
                Character:WaitForChild('HumanoidRootPart').CFrame = getgenv().Position
                -- Stamina
                if Percent(Character:WaitForChild('Stats'):GetAttribute("Stamina"),GetStamina()) <= Stamina then
                    Character:BreakJoints()
                end
            end)
        end
    end)
end)
-- Character Death
getgenv().CharacterDeath = LocalPlayer.CharacterAdded:Connect(function(Character)
    Character.ChildAdded:Connect(function(Humanoid)
        if Humanoid.Name == 'Humanoid' then
            Humanoid.Died:Connect(function()
                while Autofarm do task.wait(2)
                    syn.set_thread_identity(Autofarm and 1 or 7)
                    if syn.get_thread_identity() == 1 then
                        if UI.MainMenu.Buttons.Play.Position.X.Scale == .5 then
                            Play()
                            syn.set_thread_identity(7)
                            break
                        end
                    end
                end
            end)
        end
    end)
end)
-- Start
if LocalPlayer.Character then
    LocalPlayer.Character:BreakJoints()
    while Autofarm do task.wait(2)
        syn.set_thread_identity(Autofarm and 1 or 7)
        if syn.get_thread_identity() == 1 then
            if UI.MainMenu.Buttons.Play.Position.X.Scale == .5 then
                Play()
                syn.set_thread_identity(7)
                break
            end
        end
    end
else syn.set_thread_identity(Autofarm and 1 or 7)
    if syn.get_thread_identity() == 1 then
        if UI.MainMenu.Buttons.Play.Position.X.Scale == .5 then
            Play()
            syn.set_thread_identity(7)
        end
    end
end
