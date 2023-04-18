
-- Namespaces
local _, Hardcore_Score = ...; 
-- Define your addon's namespace

-- Globals
HCScore_Character = {
    name = "",
    class = "",
    level = 0,
    scores = {
        coreScore = 0,
        equippedGearScore = 0,
        hcAchievementScore = 0,
        levelingScore = 0,
        timeBonusScore = 0,
        questingScore = 0,
        mobsKilledScore = 0,
        professionsScore = 0,
        dungeonsScore = 0,
    },
    quests = {},
}    


-- Custom Slash Command
Hardcore_Score.commands = {
 --   ["show"] = Hardcore_Score.Scoreboard.Toggle, -- this is a function (no knowledge of Config object)

    ["help"] = function ()
        print(" ");
        Hardcore_Score:Print("List of slash commands:");
        Hardcore_Score:Print("|cff00cc66/lb show|r - shows show menu");
        Hardcore_Score:Print("|cff00cc66/lb help|r - shows help info");
        print(" ");
    end,

    ["example"] = {
        ["test"] = function(...)
            Hardcore_Score:Print("My Value:", tostringall(...));
        end
    }
};


function Hardcore_Score.HandleSlashCommands(str)
    if (#str == 0) then
        
        --User just entered "/hlb" with no additional args.
        Hardcore_Score.commands.help();
        return;
    end

    local args = {}; -- What we will iterate over using the loop (arguments).
    for _, arg in pairs({ string.split(' ', str) }) do
        if (#arg > 0) then -- if string length is greater than 0
            table.insert(args, arg);
        end
    end

    local path = Hardcore_Score.commands; -- required for updating found table

    for id, arg in ipairs(args) do
        arg = string.lower(arg);

        if (path[arg]) then
            if (type(path[arg] == "function")) then
                
                -- all remaining args passed to our function!
                path[arg] (select(id + 1, unpack(args)));
                return;

            elseif (type(path[arg]) == "table") then
                path = path[arg]; -- another sub-table found!
            else
                -- does not exist
                Hardcore_Score.commands.help();
                return;
            end
        else
            -- does not exist!
            Hardcore_Score.commands.help();
            return;
        end
    end
end

function Hardcore_Score:Print(...)
    local hex = select(4, Scoreboard:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Hardcore Scoreboard:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, tostringall(...)));    
end

-- WARNING: self automatically becomes events frame!
function Hardcore_Score:init(event, name)
    if (name ~= "Hardcore_Score") then return end

    -- allows using left and right buttons to move through chat 'edit' box
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
    end

    -- Register Slash Commands!
    SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
    SlashCmdList.RELOADUI = ReloadUI;

    -- Register Slash Commands!
--    SLASH_GETGEARINFO1 = "/gearinfo"; -- new slash command for getting gearinfo
--    SlashCmdList.SLASH_GETGEARINFO = PlayerEquippedGearScore:GetEquippedGearScore()
    
    SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
    SlashCmdList.FRAMESTK = function ()
        LoadAddOn("Blizzard_DebugTools");
        FrameStackTooltip_Toggle();        
    end

--    SLASH_Scoreboard1 = "/lb";
--    SlashCmdList.Scoreboard = HandleSlashCommands;

    -- Load the saved variables data for your addon
 --   HCScore_Character = _G[ADDON_NAMESPACE] or {}

    -- Set the default values for your addon's saved variables
--    HCScore_StoredVariables = HCScore_StoredVariables or {}

    -- Save the updated values back to the store variables file
--    _G[ADDON_NAMESPACE] = HCScore_StoredVariables
 --   CharacterInfo = HCScore_StoredVariables.CharacterInfo

    if HCScore_Character.name == "" then
        PlayerInfo:LoadCharacterData()
    end

    Hardcore_Score:Print("Psst, ", UnitName("player").. "! "..  HCScore_Character.scores.coreScore.. " is a great Hardcore score!");

    Scoreboard:CreateUI()
    Hardcore_Score:Print("Psst, ", UnitName("player").. "! "..  HCScore_Character.scores.coreScore.. " is a great Hardcore score!");
    
--    Scoreboard:UpdateUI()
    Hardcore_Score:Print("Psst, ", UnitName("player").. "! "..  HCScore_Character.scores.coreScore.. " is a great Hardcore score!");
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", Hardcore_Score.init);



--[[
events:SetScript("OnEvent", function(self, event, addonName)
    if addonName == ADDON_NAME then
        print(addonName)
        core.init(addonName)
        -- Access the saved variable data and update your UI here
        local characterInfo = Backup_CharacterInfo
        print(characterInfo.name)
        print(characterInfo.class)
        print(characterInfo.level)
        print(characterInfo.scores.coreScore)
        print(characterInfo.quests.quest.questId)
        CharacterInfo = characterInfo       
        events:UnregisterEvent("ADDON_LOADED")
    end
end)
]]

--[[
-- Define your addon's namespace
local ADDON_NAME = "Hardcore_Score"
local ADDON_NAMESPACE = "Hardcore_ScoreNamespace"

-- Create a table to store your addon's saved variables
local Hardcore_Score_SavedVariables = {}

-- Define a function to initialize your addon's saved variables
local function InitSavedVariables()
    -- Load the saved variables data for your addon
    Hardcore_Score_SavedVariables = _G[ADDON_NAMESPACE] or {}

    -- Set the default values for your addon's saved variables
    Hardcore_Score_SavedVariables.CharacterInfo = Hardcore_Score_SavedVariables.CharacterInfo or {
        name = "",
        class = "",
        level = 0,
        scores = {
            coreScore = 0,
            equippedGearScore = 0,
            hcAchievementScore = 0,
            levelingScore = 0,
            timeBonusScore = 0,
            questingScore = 0,
            mobsKilledScore = 0,
            professionsScore = 0,
            dungeonsScore = 0,
        },
        quests = {
            quest = {
                questId = 0,
            },
        },
    }

    -- Save the updated values back to the store variables file
    _G[ADDON_NAMESPACE] = Hardcore_Score_SavedVariables
end

-- Register an event handler to initialize your addon's saved variables when the addon is loaded
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == ADDON_NAME then
        InitSavedVariables()
        -- Access the saved variable data and update your UI here
        local characterInfo = Hardcore_Score_SavedVariables.CharacterInfo
        print(characterInfo.name)
        print(characterInfo.class)
        print(characterInfo.level)
        print(characterInfo.scores.coreScore)
        print(characterInfo.quests.quest.questId)
        eventFrame:UnregisterEvent("ADDON_LOADED")
    end
end)
]]

