--Skidded nigger sex
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Client = require(LocalPlayer.Packer.Client)
local CurrentRoute
local AutoFarmConnection
local UninjectConnection
local InABattle = false
local KeyBind = "RightShift"
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
for i,v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and string.find(v.Name, "_") and v ~= LocalPlayer.Character then
        CurrentRoute = v
    end
end

--// PREVENT REEXECUTES
if getgenv().executed == true then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Already Executed",
        Text = "Uninject first by pressing comma!",
        Duration = 3,
    })
    return
end
getgenv().executed = true

if type(getgenv().autofarm_settings) ~="table" then getgenv().autofarm_settings = {} end

local function notify(title, text)
    local configTable = {
        Title = title,
        Text = text,
        Duration = 3,
    }
    game:GetService("StarterGui"):SetCore("SendNotification", configTable)
end
local function validatesettings()
    if getgenv().autofarm_settings.catch_when_shiny == getgenv().autofarm_settings.kill_when_shiny and getgenv().autofarm_settings.kill_when_shiny == true then
        notify("Shiny Settings Invalid", "You can't have catch and kill set to true")
        return false
    end
    if getgenv().autofarm_settings.catch_when_skin == getgenv().autofarm_settings.kill_when_skin and getgenv().autofarm_settings.kill_when_skin == true then
        notify("Skin Settings Invalid", "You can't have catch and kill set to true")
        return false
    end
    if getgenv().autofarm_settings.catch_when_tint == getgenv().autofarm_settings.kill_when_tint and getgenv().autofarm_settings.kill_when_tint == true then
        notify("Tint Settings Invalid", "You can't have catch and kill set to true")
        return false
    end
    if getgenv().autofarm_settings.catch_when_havent_caught_before == getgenv().autofarm_settings.kill_when_havent_caught_before and getgenv().autofarm_settings.kill_when_havent_caught_before == true then
        notify("Doodles Not Caught Before Settings Invalid", "You can't have catch and kill set to true")
        return false
    end
    if getgenv().autofarm_settings.catch_when_specific_doodle == getgenv().autofarm_settings.kill_when_specific_doodle and getgenv().autofarm_settings.kill_when_specific_doodle == true then
        notify("Specific Doodle Settings Invalid", "You can't have catch and kill set to true")
        return false
    end
    if getgenv().autofarm_settings.kill_all == getgenv().autofarm_settings.catch_all and getgenv().autofarm_settings.kill_all == true then
        notify("Kill/Catch All Settings Invalid", "You can't have catch and kill set to true")
        return false
    end
    if type(getgenv().autofarm_settings.catch_when_shiny) ~= "boolean" or type(getgenv().autofarm_settings.kill_when_shiny) ~= "boolean" then
        notify("Invalid Shiny Settings", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.catch_when_skin) ~= "boolean" or type(getgenv().autofarm_settings.kill_when_skin) ~= "boolean" then
        notify("Invalid Skin Settings", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.catch_when_tint) ~= "boolean" or type(getgenv().autofarm_settings.kill_when_tint) ~= "boolean" then
        notify("Invalid Tint Settings", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.catch_when_havent_caught_before) ~= "boolean" or type(getgenv().autofarm_settings.kill_when_havent_caught_before) ~= "boolean" then
        notify("Invalid Doodle that hasn't been caught before Settings", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.catch_when_specific_doodle) ~= "boolean" or type(getgenv().autofarm_settings.kill_when_specific_doodle) ~= "boolean" then
        notify("Invalid Specific Doodle Settings", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.autocatchcapsule) ~= "string" then
        notify("Invalid Capsule Setting", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.autoheal) ~= "boolean" then
        notify("Invalid AutoHeal Setting", "Setting hasn't been set")
        return false
    end
    if type(getgenv().autofarm_settings.specific_doodles) ~= "table" then
        notify("Invalid Specific Doodle Table", "Setting hasn't been set")
        return false
    end
    return true
end

local Window = Library.CreateLib("Doodle World AutoFarm", "DarkTheme")
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main")
local WarningLabel = MainSection:NewLabel("Don't forget to set your settings before enabling\n  (everything is off by default)")
local Enabled = MainSection:NewToggle("Enabled", "", function(state)
    validatesettings()
    local validsettings = validatesettings()
    if validsettings == true then
        if state == true then
            getgenv().autofarm_settings.enabled = true
        elseif state == false then
            getgenv().autofarm_settings.enabled = false
        end
    else
        notify("unable to enable", "invalid settings")
    end
end)
local SettingsTab = Window:NewTab("Settings")
local Misc = SettingsTab:NewSection("Misc")
Misc:NewToggle("Kill All", "Bypasses every other kill setting", function(state)
    if state == true then
        getgenv().autofarm_settings.kill_all = true
    else
        getgenv().autofarm_settings.kill_all = false
    end
end)
Misc:NewToggle("Catch All", "Bypasses every other kill setting", function(state)
    if state == true then
        getgenv().autofarm_settings.catch_all = true
    else
        getgenv().autofarm_settings.catch_all = false
    end
end)
Misc:NewToggle("AutoHeal", "", function(state)
    if state == true then
        getgenv().autofarm_settings.autoheal = true
    else
        getgenv().autofarm_settings.autoheal = false
    end
end)
local Shiny = SettingsTab:NewSection("Shiny")
Shiny:NewDropdown("Mode", "", {"Catch", "Kill", "Run"}, function(mode)
    if mode == "Catch" then
        getgenv().autofarm_settings.kill_when_shiny = false
        getgenv().autofarm_settings.catch_when_shiny = true
    elseif mode == "Kill" then
        getgenv().autofarm_settings.catch_when_shiny = false
        getgenv().autofarm_settings.kill_when_shiny = true
    elseif mode == "Run" then
        getgenv().autofarm_settings.catch_when_shiny = false
        getgenv().autofarm_settings.kill_when_shiny = false
    end
end)
local Skin = SettingsTab:NewSection("Skin")
Skin:NewDropdown("Mode", "", {"Catch", "Kill", "Run"}, function(mode)
    if mode == "Catch" then
        getgenv().autofarm_settings.kill_when_skin = false
        getgenv().autofarm_settings.catch_when_skin = true
    elseif mode == "Kill" then
        getgenv().autofarm_settings.catch_when_skin = false
        getgenv().autofarm_settings.kill_when_skin = true
    elseif mode == "Run" then
        getgenv().autofarm_settings.catch_when_skin = false
        getgenv().autofarm_settings.kill_when_skin = false
    end
end)
local Tint = SettingsTab:NewSection("Tint")
Tint:NewDropdown("Mode", "", {"Catch", "Kill", "Run"}, function(mode)
    if mode == "Catch" then
        getgenv().autofarm_settings.kill_when_tint = false
        getgenv().autofarm_settings.catch_when_tint = true
    elseif mode == "Kill" then
        getgenv().autofarm_settings.catch_when_tint = false
        getgenv().autofarm_settings.kill_when_tint = true
    elseif mode == "Run" then
        getgenv().autofarm_settings.catch_when_tint = false
        getgenv().autofarm_settings.kill_when_tint = false
    end
end)
local DoodlesThatHaventBeenCaughtBefore = SettingsTab:NewSection("Doodles that haven't been caught before")
DoodlesThatHaventBeenCaughtBefore:NewDropdown("Mode", "", {"Catch", "Kill", "Run"}, function(mode)
    if mode == "Catch" then
        getgenv().autofarm_settings.kill_when_havent_caught_before = false
        getgenv().autofarm_settings.catch_when_havent_caught_before = true
    elseif mode == "Kill" then
        getgenv().autofarm_settings.catch_when_havent_caught_before = false
        getgenv().autofarm_settings.kill_when_havent_caught_before = true
    elseif mode == "Run" then
        getgenv().autofarm_settings.catch_when_havent_caught_before = false
        getgenv().autofarm_settings.kill_when_havent_caught_before = false
    end
end)
local SpecificDoodles = SettingsTab:NewSection("Specific Doodle")
SpecificDoodles:NewDropdown("Mode", "", {"Catch", "Kill", "Run"}, function(mode)
    if mode == "Catch" then
        getgenv().autofarm_settings.kill_when_specific_doodle = false
        getgenv().autofarm_settings.catch_when_specific_doodle = true
    elseif mode == "Kill" then
        getgenv().autofarm_settings.catch_when_specific_doodle = false
        getgenv().autofarm_settings.kill_when_specific_doodle = true
    elseif mode == "Run" then
        getgenv().autofarm_settings.catch_when_specific_doodle = false
        getgenv().autofarm_settings.kill_when_specific_doodle = false
    end
end)
local AutoCatch = SettingsTab:NewSection("AutoCatch")
local Capsules = {}
for i,v in pairs(Client.Network:get("PlayerData", "GetItems")["Capsules"]) do
    table.insert(Capsules, i)
end
local CapsuleSelection = AutoCatch:NewDropdown("Capsule", "choose your capsule", Capsules, function(capsule)
    getgenv().autofarm_settings.autocatchcapsule = capsule
end)

local GUISettings = Window:NewTab("GUI Settings")
local GUISettingsSection = GUISettings:NewSection("Settings")
local ToggleGUIConnection 
local KeybindChoose = GUISettingsSection:NewTextBox("Toggle GUI Keybind", "", function(txt)
    if Enum.KeyCode[txt] ~= nil then
        KeyBind = txt
    elseif Enum.KeyCode[txt:upper()] ~= nil then
        KeyBind = txt:upper()
    else
        notify("Invalid KeyBind", "")
    end
    if ToggleGUIConnection ~= nil then ToggleGUIConnection:Disconnect() end
    ToggleGUIConnection = game:GetService("UserInputService").InputBegan:Connect(function(key)
        if key.KeyCode == Enum.KeyCode[txt:upper()] or key.KeyCode == Enum.KeyCode[txt] then
            Library:ToggleUI()
        end
    end)
end)
local MiscTab = Window:NewTab("Misc")
local MainMiscSection = MiscTab:NewSection("Main")
local HideIdentity = MainMiscSection:NewButton("Hide Identity", "Hides player list and overhead name GUI", function()
    LocalPlayer.PlayerGui.MainGui:FindFirstChild(LocalPlayer.Name).Visible = false
    LocalPlayer.PlayerGui.MainGui:FindFirstChild(LocalPlayer.Name):GetPropertyChangedSignal("Visible"):Connect(function(value)
        if LocalPlayer.PlayerGui.MainGui:FindFirstChild(LocalPlayer.Name).Visible == true then
            LocalPlayer.PlayerGui.MainGui:FindFirstChild(LocalPlayer.Name).Visible = false
        end
    end)
    LocalPlayer.PlayerGui.MainGui.PlayerList.Visible = false
    LocalPlayer.Character.Head.Nametag.Username.Visible = false
end)
local OpenShop = MainMiscSection:NewButton("Open Shop", "Opens the shop GUI", function()
    Client.NormalShop.new()
end)
local OpenPC = MainMiscSection:NewButton("Open PC", "Opens the PC GUI", function()
    Client.PC.new()
end)
local FightGlubbie = MainMiscSection:NewButton("Fight Glubbie", "Starts a glubbie fight", function()
    Client.Battle:WildBattle("GenericIndoors", "GlubbieSpecial")
end)

local function run()
    repeat
        repeat
            task.wait()
            if string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "^You r") then return end
        until getconnections(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Run.MouseButton1Click)[1] ~= nil
        getconnections(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Run.MouseButton1Click)[1]:Fire()
        print("ran")
        task.wait(2)
    until string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "^You r")
end
local function catch()
    local breakloop = false
    while string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "was caught") ~= "was caught" do
        if breakloop == true or string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "was caught") == "was caught" then break end
        if string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "^What will") == "What will" and LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Visible == true then
            Client.Network:post("BattleAction", {{
                ActionType = "Item",
                Action = getgenv().autofarm_settings.autocatchcapsule,
                User = Client.Network:get("PlayerData", "GetParty")[1]["ID"]
            }})
            print("capsule thrown")
            Client.SelectedAction:Fire(true)
        end
        if breakloop == true or string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "was caught") == "was caught" then break end
        wait(2)
        if breakloop == true or string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "was caught") == "was caught" then break end
    end
    print("broke the autocatch loop")
    breakloop = true
    return
end
local function catch2()
    repeat 
        repeat
            task.wait()
        until string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "was caught") ~= "was caught" 
        if string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "^What will") == "What will" and LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Visible == true then
            Client.Network:post("BattleAction", {{
                ActionType = "Item",
                Action = getgenv().autofarm_settings.autocatchcapsule,
                User = Client.Network:get("PlayerData", "GetParty")[1]["ID"]
            }})
            print("capsule thrown")
            Client.SelectedAction:Fire(true)
        end
        task.wait(1)
    until string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "was caught") == "was caught" 
end
local function kill()
    local notsupereffectivemoves = {}
    local foundsupereffective = false
    repeat
        repeat
            task.wait()
            if string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "The wild "..LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.Text.." fainted") then return end
        until getconnections(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Fight.MouseButton1Click)[1] ~= nil
        for i,v in pairs(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Moves:GetChildren()) do
            getconnections(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Fight.MouseButton1Click)[1]:Fire()
            if v.Effective.Visible == true and tonumber(string.split(v.Uses.Text, "/")[1]) ~= 0 and tonumber(string.split(v.Uses.Text, "/")[1]) <= tonumber(string.split(v.Uses.Text, "/")[2]) and v.Effective.Image ~= 4597964542 and v.Effective.Image ~= 4597964185 then
                getconnections(v.MouseButton1Click)[1]:Fire()
                foundsupereffective = true
                break
            elseif v.Effective.Visible == false and tonumber(string.split(v.Uses.Text, "/")[1]) ~= 0 and tonumber(string.split(v.Uses.Text, "/")[1]) <= tonumber(string.split(v.Uses.Text, "/")[2]) then
                if notsupereffectivemoves[v.MoveName.Text] == nil then
                    repeat task.wait() until LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Visible == true
                    getconnections(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Switch.MouseButton1Click)[1]:Fire()
                    repeat task.wait() until LocalPlayer.PlayerGui.MainGui.PartyUI.Visible == true
                    getconnections(LocalPlayer.PlayerGui.MainGui.PartyUI.Party1.Activated)[1]:Fire()
                    repeat task.wait() until LocalPlayer.PlayerGui.MainGui:FindFirstChild("PartyChoice")
                    getconnections(LocalPlayer.PlayerGui.MainGui.PartyChoice.Stats.MouseButton1Click)[1]:Fire()
                    repeat task.wait() until LocalPlayer.PlayerGui.MainGui.Stats.Visible == true
                    getconnections(LocalPlayer.PlayerGui.MainGui.Stats.Tabs.Moves.MouseButton1Click)[1]:Fire()
                    repeat task.wait() until LocalPlayer.PlayerGui.MainGui.Stats.PaperFront.Moves.Visible == true
                    local movebutton
                    for i2,v2 in pairs(LocalPlayer.PlayerGui.MainGui.Stats.PaperFront.Moves.Holder:GetChildren()) do
                        if v2:IsA("ImageButton") and v2:FindFirstChild("MoveName") and v2.MoveName.Text == v.MoveName.Text then
                            movebutton = v2
                            break
                        end
                    end
                    repeat
                        task.wait()
                        VirtualInputManager:SendMouseMoveEvent(movebutton.AbsolutePosition.X + movebutton.AbsoluteSize.X / 2, movebutton.AbsolutePosition.Y + movebutton.AbsoluteSize.Y / 2, movebutton)
                    until LocalPlayer.PlayerGui.MainGui.Stats.PaperFront.Moves.MoveDescription.MoveName.Label.Text == v.MoveName.Text
                    local movepower = LocalPlayer.PlayerGui.MainGui.Stats.PaperFront.Moves.MoveDescription.StatHolder.Power.Desc.Label.Text
                    if movepower == "--" or movepower == "Varies" then movepower = 0 end
                    movepower = tonumber(movepower)
                    local movename = LocalPlayer.PlayerGui.MainGui.Stats.PaperFront.Moves.MoveDescription.MoveName.Label.Text
                    notsupereffectivemoves[movename] = movepower
                    getconnections(LocalPlayer.PlayerGui.MainGui.Stats.Close.MouseButton1Click)[1]:Fire()
                    getconnections(LocalPlayer.PlayerGui.MainGui.PartyUI.CloseBar.Cancel.MouseButton1Click)[1]:Fire()
                end
            end
        end
        if foundsupereffective == false then
            local strongestmove 
            local num = 0
            for i,v in pairs(notsupereffectivemoves) do
                if v > num then
                    num = v
                    strongestmove = i
                end
            end
            getconnections(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Fight.MouseButton1Click)[1]:Fire()
            for i,v in pairs(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Moves:GetChildren()) do
                if v.MoveName.Text == strongestmove then
                    getconnections(v.MouseButton1Click)[1]:Fire()
                    break
                end
            end
        end
        print("attacked")
    until string.match(LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Say.Text, "The wild "..LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.Text.." fainted")
end

notify("AutoFarm Loaded", "Press comma to uninject")

getgenv().autofarm_settings.enabled = false

AutoFarmConnection = RunService.RenderStepped:Connect(function()
    if InABattle == true or getgenv().autofarm_settings.enabled == false then return end
    if getgenv().autofarm_settings.enabled == true then
        InABattle = true
        if getgenv().autofarm_settings.autoheal == true then
            print("healing")
            Client.Network:post("PlayerData", "Heal")
        end
        for i,v in pairs(Client.Network:get("PlayerData", "GetItems")["Capsules"]) do
            table.insert(Capsules, i)
        end
        CapsuleSelection:Refresh(Capsules)
        print("starting battle")
        if CurrentRoute.Name == "007_Lakewood" then
            --Client.Network:post("RequestWild", CurrentRoute.Name, "Lake")
            Client.Battle:WildBattle("RequestWild", "Lake", "Lake")
        elseif CurrentRoute.Name == "011_Sewer" then
            --Client.Network:post("RequestWild", "011_RealSewer", "Sewer")
            Client.Battle:WildBattle("RequestWild", "Sewer", "Sewer")
        else
            Client.Battle:WildBattle("RequestWild", "WildGrass", "WildGrass")
        end
        repeat task.wait() until LocalPlayer.PlayerGui.MainGui.MainBattle.Visible == true
        task.wait(1)
        if LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.Shiny.Visible == true and getgenv().autofarm_settings.catch_when_shiny == true or LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.Shiny.Visible == true and getgenv().autofarm_settings.kill_when_shiny == true then
            print("found shiny doodle")
            notify("AutoFarm Found:", "Shiny Doodle")
            if getgenv().autofarm_settings.kill_when_shiny == true or getgenv().autofarm_settings.kill_all == true then
                kill()
            elseif getgenv().autofarm_settings.catch_when_shiny == true then
                catch()
            end
        elseif tostring(LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.UIGradient.Color.Keypoints[1]) ~= "0 1 1 1 0 " and getgenv().autofarm_settings.catch_when_skin == true or tostring(LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.UIGradient.Color.Keypoints[1]) ~= "0 1 1 1 0 " and getgenv().autofarm_settings.kill_when_skin == true then
            print("found skin")
            notify("AutoFarm Found:", "Skin")
            if getgenv().autofarm_settings.kill_when_skin == true or getgenv().autofarm_settings.kill_all == true then
                kill()
            elseif getgenv().autofarm_settings.catch_when_skin == true then
                catch()
            end
        elseif LocalPlayer.PlayerGui.MainGui.MainBattle.DoodleFront.NewSprite:FindFirstChild("ColorChanger") and getgenv().autofarm_settings.catch_when_tint == true or LocalPlayer.PlayerGui.MainGui.MainBattle.DoodleFront.NewSprite:FindFirstChild("ColorChanger") and getgenv().autofarm_settings.kill_when_tint == true then
            print("found tint")
            notify("AutoFarm Found:", "Tint")
            if getgenv().autofarm_settings.kill_when_tint == true or getgenv().autofarm_settings.kill_all == true then
                kill()
            elseif getgenv().autofarm_settings.catch_when_tint == true then
                catch()
            end
        elseif LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.AlreadyCaught.Visible == false and getgenv().autofarm_settings.catch_when_havent_caught_before == true or LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.AlreadyCaught.Visible == false and getgenv().autofarm_settings.kill_when_havent_caught_before == true then
            print("found doodle that hasnt been caught before")
            notify("AutoFarm Found:", "Doodle that hasn't been caught before")
            if getgenv().autofarm_settings.kill_when_havent_caught_before == true or getgenv().autofarm_settings.kill_all == true then
                kill()
            elseif getgenv().autofarm_settings.catch_when_havent_caught_before == true then
                catch()
            end
        elseif table.find(getgenv().autofarm_settings.specific_doodles, LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.Text) and getgenv().autofarm_settings.catch_when_specific_doodle == true or table.find(getgenv().autofarm_settings.specific_doodles, LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.Text) and getgenv().autofarm_settings.kill_when_specific_doodle == true then
            print("found specific doodle")
            notify("AutoFarm Found:", "Specific Doodle")
            if getgenv().autofarm_settings.kill_when_specific_doodle == true or getgenv().autofarm_settings.kill_all == true then
                kill()
            elseif getgenv().autofarm_settings.catch_when_specific_doodle == true then
                catch()
            end
        else
            if getgenv().autofarm_settings.kill_all == true then
                kill()
            elseif getgenv().autofarm_settings.catch_all == true then
                catch()
            else
                run()
            end
        end
        print("waiting till battle gui gone")
        repeat
            task.wait()
        until LocalPlayer.PlayerGui.MainGui.MainBattle.Visible == false
    end
    InABattle = false
end)

--// UNINJECT
UninjectConnection = UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.Comma then
        notify("AutoFarm", "Uninjecting...")
        getgenv().executed = false
        notify("AutoFarm", "Uninjected") 
        AutoFarmConnection:Disconnect()  
        local function isNumeric(value)
            if value == tostring(tonumber(value)) then
                return true
            else
                return false
            end
        end
        for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
            if isNumeric(v.Name) then
                v:Destroy()
            end
        end
        getgenv().autofarm_settings.enabled = false
        UninjectConnection:Disconnect()
    end
end)
