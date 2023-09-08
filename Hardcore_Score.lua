local AceDB = LibStub("AceDB-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Namespaces
local _;  
Hardcore_Score = {}

-- Globals
HCS_Version = "1.0.6" --GetAddOnMetadata("Hardcore Score", "Version")
HCScore_Character = {
    name = "",
    class = "",
    classid = 0,
    level = 0,
    race = "",
    faction = "",
    version = 0,
    deaths = 0,
    scores = {
        coreScore = 0,
        equippedGearScore = 0,
        achievementScore = 0,
        levelingScore = 0,
        questingScore = 0,
        mobsKilledScore = 0,
        professionsScore = 0,
        dungeonsScore = 0,
        reputationScore = 0,
        discoveryScore = 0,
        milestonesScore = 0,
    },
    quests = {},
    professions = {
        alchemy = 0,
        blacksmithing = 0,
        enchanting = 0,
        engineering = 0,
        herbalism = 0,
        leatherworking = 0,
        lockpicking = 0,
        mining = 0,
        skinning = 0,
        tailoring = 0,
        fishing = 0,
        cooking = 0,
        firstaid = 0,
    },
    reputations = {},
    mobsKilled = {},
    discovery = {},
    milestones = {},
    levelScores = {},
    dangerousMobsKilled = {},
    achievements = {},
}

-- Define your options table
local options = {
    name = "Hardcore Score",
    type = "group",
    args = {
        showScore = {
            name = "Show main score",
            desc = "Enables / disables the main score view",
            type = "toggle",
            order = 1,
            set = function(info,val) 
                Hardcore_Score.db.profile.framePosition.show = val
                if val then
                    ScoreboardSummaryFrame:Show()
                    if Hardcore_Score.db.profile.showDetails then
                        ScoreboardSummaryDetailsFrame:Show()  
                    end
                else
                    ScoreboardSummaryFrame:Hide()
                    ScoreboardSummaryDetailsFrame:Hide()
                end
            end,  -- set
            get = function(info) return Hardcore_Score.db.profile.framePosition.show end  -- get
        },
        shareScore = {
            name = "Share your score",
            desc = "Enables / disables sharing your score with others",
            type = "toggle",
            order = 2,
            set = function(info,val) Hardcore_Score.db.profile.shareDetails = val end,  -- update your set function
            get = function(info) return Hardcore_Score.db.profile.shareDetails end  -- update your get function
        },
        showMessages = {
            name = "Show Messages",
            desc = "Enables / disables reward messages",
            type = "toggle",
            order = 3,
            set = function(info,val) 
                    Hardcore_Score.db.profile.framePositionMsg.show = val 
                end,  -- update your set function
            get = function(info) return Hardcore_Score.db.profile.framePositionMsg.show end  -- update your get function
        },
        Space1 = {
            name = "",
            desc = "",
            type = "description",
            fontSize = "medium",
            order = 4
        },
        PointsLogHeader = {
            name = "Points Log",
            type = "header",
            order = 5
        },
        showPointsLog = {
            name = "Show Points Log",
            desc = "Enables / disables showing Points Log",
            type = "toggle",
            order = 6,
            set = function(info,val) 
                    Hardcore_Score.db.profile.framePositionLog.show = val 
                    HCS_PointsLogUI:SetVisibility()
                end,  -- update your set function
            get = function(info) return Hardcore_Score.db.profile.framePositionLog.show end  -- update your get function
        },
        showPointsLogTimeStamp = {
            name = "Show Timestamp",
            desc = "Displays showing the timestamp in Points log",
            type = "toggle",
            order = 7,
            set = function(info,val) Hardcore_Score.db.profile.framePositionLog.showTimestamp = val end,
            get = function(info) return Hardcore_Score.db.profile.framePositionLog.showTimestamp end
        },

        editBoxFontSize = {
            name = "Font Size",
            desc = "Adjusts the font size in the Points Log edit box",
            type = "range",
            order = 8,
            min = 10,
            max = 24,
            step = 1,
            set = function(info,val)
                Hardcore_Score.db.profile.framePositionLog.fontSize = val
                local fontName, _, fontFlags = HCS_PointsLogUI.EditBox:GetFont()
                HCS_PointsLogUI.EditBox:SetFont(fontName, val, fontFlags)
            end,
            get = function(info) return Hardcore_Score.db.profile.framePositionLog.fontSize end
        },

        Space2 = {
            name = "",
            desc = "",
            type = "description",
            fontSize = "medium",
            order = 9
        },
        LinksHeader = {
            name = "Connect for more information",
            type = "header",
            order = 10
        },
        twitterLink = {
            name = " Follow us on Twitter at https://twitter.com//HardcoreScore",
            desc = "https://twitter.com//HardcoreScore",
            type = "description",
            fontSize = "medium",
            image = "Interface\\Addons\\Hardcore_Score\\Media\\TwitterLogo.blp",
            order = 11
        },
        discordLink = {
            name = " Join our Discord server at https://discord.gg/j92hrVZU2Q",
            desc = "https://discord.gg/j92hrVZU2Q",
            type = "description",
            fontSize = "medium",
            image = "Interface\\Addons\\Hardcore_Score\\Media\\DiscordLogo.blp",
            order = 12
        },
        websiteLink = {
            name = " Website  https://avenroothcs.wixsite.com/hardcore-score",
            desc = "https://avenroothcs.wixsite.com/hardcore-score",
            type = "description",
            fontSize = "medium",
            image = "Interface\\Addons\\Hardcore_Score\\Media\\www_icon.blp",
            order = 13
        },
        Space3 = {
            name = "",
            desc = "",
            type = "description",
            fontSize = "medium",
            order = 14
        },

        addonInfoHeader = {
            name = "Note from the author(s)",
            type = "header",
            order = 15
        },
        addonInfo1 = {
            name = "Thank you for trying out Hardcore Score. We would love your feedback. Please report feedback and bugs to our Discord.",
            desc = "Addon Information",
            type = "description",
            fontSize = "medium",
            order = 16
        },            
        Space4 = {
            name = "",
            desc = "",
            type = "description",
            fontSize = "medium",
            order = 17
        },
        addonInfo2 = {
            name = "We have a lot of things planned for Hardcore Score. Look for annoucements in our Discord and on our website. Enjoy challenging yourself to get the best Hardcore Score possible and share your results with us. Thank you and have fun!!",
            desc = "Addon Information",
            type = "description",
            fontSize = "medium",
            order = 18
        },            

        Space5 = {
            name = "",
            desc = "",
            type = "description",
            fontSize = "medium",
            order = 19
        },
        addonInfoNote = {
            name = "version 1.0.6 - authors: Avenroot, Caith",
            desc = "Addon Information",
            type = "description",
            fontSize = "medium",
            order = 20
        },            

    },
}

-- Custom Slash Command
Hardcore_Score.commands = {

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

function Hardcore_Score:CreateDB()

    -- Create a new database for your addon    
    self.db = AceDB:New("Hardcore_Score_Settings", {
        profile = {
            framePosition = {
                point = "CENTER",  --"CENTER",
                relativeTo = "UIParent",
                relativePoint = "CENTER", -- "CENTER",
                xOfs = 0,
                yOfs = 0,
                show = true,
            },
            -- Points Log
            framePositionLog = {
                point = "CENTER",  --"CENTER",
                relativeTo = "UIParent",
                relativePoint = "CENTER", -- "CENTER",
                xOfs = 0,
                yOfs = 0,
                show = false,
                showTimestamp = true,
                fontSize = 14,
            },
            -- Notification / pop up Milestone Message 
            framePositionMsg = {
                point = "CENTER",  --"CENTER",
                relativeTo = "UIParent",
                relativePoint = "CENTER", -- "CENTER",
                xOfs = 0,
                yOfs = 0,
                show = true,
            },
            -- Notification / Message 
            framePositionCharsInfo = {
                point = "CENTER",  --"CENTER",
                relativeTo = "UIParent",
                relativePoint = "CENTER", -- "CENTER",
                xOfs = 0,
                yOfs = 0,
                --show = true,
            },
            
            minimap = {},
            showDetails = false,
            shareDetails = true,
        },
        global = {
            -- Shared data...
            characterScores = {},
        }
    })

end

function Hardcore_Score:CreateMiniMapButton()
    local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("HCScoreMinimapButton", {
        type = "data source",
        icon = "Interface\\Addons\\Hardcore_Score\\Media\\MM_logo_2.tga",
        OnClick = function(self, button)

            -- Check if left mouse button was clicked
            if button == "LeftButton" then

                -- Open Hardcore_Score section of the options menu
                InterfaceOptionsFrame_OpenToCategory("Hardcore Score");
                InterfaceOptionsFrame_OpenToCategory("Hardcore Score"); -- yes, you need to call it twice.
                --HCS_WelcomeUI:ToggleMyFrame()

                -- Check if right mouse button was clicked
            elseif button == "RightButton" then
                -- Display your frame
                HCS_CharactersInfoUI.frame:Show()                 
            end
        end,

        OnTooltipShow = function(tooltip)
            --tooltip:SetText("")  -- This should help ensure the title's style isn't applied to the first line
            tooltip:AddLine("Hardcore Score "..tostring(HCS_Version))
            tooltip:AddLine("|cFFFFA500Left-Click|r to show options")  -- Sets "Left-Click" to grey
            tooltip:AddLine("|cFFFFA500Right-Click|r to show all scores")  -- Sets "Right-Click" to grey

            if Hardcore_Score.db.profile.framePosition.show == false then
                tooltip:AddLine(" ")
                if HCScore_Character ~= nil then
                    local txt = HCS_Utils:GetTextWithClassColor(HCScore_Character.classid, HCScore_Character.name ).. "  "..string.format("%.2f", HCScore_Character.scores.coreScore)
                    tooltip:AddLine(txt)
                else
                    tooltip:AddLine("Hardcore Score "..tostring(HCS_Version))
                end                    
            end
        end,
    })

    local icon = LibStub("LibDBIcon-1.0")
    icon:Register("Hardcore_Score", LDB, Hardcore_Score.db.profile.minimap)
end


-- Load Saved Frame Position
function Hardcore_Score:LoadSavedFramePosition()
    local framePosition = Hardcore_Score.db.profile.framePosition
    local showDetails = Hardcore_Score.db.profile.showDetails
    local framePointsLog = Hardcore_Score.db.profile.framePositionLog
    local frameCharsInfo = Hardcore_Score.db.profile.framePositionCharsInfo

    if framePosition then
        local relativeTo = _G[framePosition.relativeTo]
        if relativeTo then
            ScoreboardSummaryFrame:SetPoint(framePosition.point, relativeTo, framePosition.relativePoint, framePosition.xOfs, framePosition.yOfs)
        end
        if showDetails then
            ScoreboardSummaryDetailsFrame:Show()
        end
        if framePosition.show then
            ScoreboardSummaryFrame:Show()
        else
            ScoreboardSummaryFrame:Hide()
            ScoreboardSummaryDetailsFrame:Hide()
        end
    end

    if framePointsLog then
        local relativeTo = _G[framePointsLog.relativeTo]
        if relativeTo then
            HCS_PointsLogUI.frame:SetPoint(framePointsLog.point, relativeTo, framePointsLog.relativePoint, framePointsLog.xOfs, framePointsLog.yOfs)
        end
        HCS_PointsLogUI:SetVisibility()
    end

    if frameCharsInfo then
        local relativeTo = _G[frameCharsInfo.relativeTo]
        if relativeTo then
            HCS_CharactersInfoUI.frame:SetPoint(frameCharsInfo.point, relativeTo, frameCharsInfo.relativePoint, frameCharsInfo.xOfs, frameCharsInfo.yOfs)
        end
        HCS_CharactersInfoUI.frame:Hide() --HCS_CharactersInfoUI:ToggleMyFrame()
    end
end

function Hardcore_Score:init(event, name)
    if event == "ADDON_LOADED" then
        if name ~= "Hardcore_Score" then return end

        Hardcore_Score.events:UnregisterEvent("ADDON_LOADED")

        -- allows using left and right buttons to move through chat 'edit' box
        for i = 1, NUM_CHAT_WINDOWS do
            _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
        end

        -- Register Slash Commands!
        SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
        SlashCmdList.RELOADUI = ReloadUI;

        SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
        SlashCmdList.FRAMESTK = function ()
            LoadAddOn("Blizzard_DebugTools");
            FrameStackTooltip_Toggle();        
        end

        -- initalization Hardcore_Score_Settings
        if Hardcore_Score_Settings == nil then Hardcore_Score_Settings = {} end

        -- Turn printing to message window off while loading and re-calculating
        HCS_print = false

        HCS_Playerinfo:LoadCharacterData()

        HCS_ScoreboardSummaryUI:CreateFrame()

        Hardcore_Score:CreateDB()
        
        -- Hides any messages that may be shown by recalcuating tables / scores (1) - Change settings
        local saveShowMessages = Hardcore_Score.db.profile.framePositionMsg.show
        Hardcore_Score.db.profile.framePositionMsg.show = false

        -- Create minimap button
        Hardcore_Score:CreateMiniMapButton()

        -- Get frame saved position
        Hardcore_Score:LoadSavedFramePosition()    

        -- Register the options table
        AceConfig:RegisterOptionsTable("Hardcore_Score", options)

        -- Add the options table to the Blizzard interface options
        AceConfigDialog:AddToBlizOptions("Hardcore_Score", "Hardcore Score")

        HCS_PointsLogUI:SetVisibility()

        HCS_PlayerCompletingQuestEvent:RecalculateQuests()
        
        HCS_MilestonesScore:ClearMilestones()

        HCS_CalculateScore:RefreshScores()

        -- Hides any messages that may be shown by recalcuating tables / scores (2) - Restores settings
        Hardcore_Score.db.profile.framePositionMsg.show = saveShowMessages
        
        -- Turn printing to message window back on
        --HCS_print = true

        -- Clear Points Log
        HCS_PointsLogUI:ClearPointsLog()

    elseif event == "PLAYER_LOGIN" then
        
        HCS_print = true
        local playerName

        local fontSize = Hardcore_Score.db.profile.framePositionLog.fontSize or 14
        Hardcore_Score.db.profile.framePositionLog.fontSize = fontSize

        local showTimestamp = Hardcore_Score.db.profile.framePositionLog.showTimestamp
        if showTimestamp == nil then
            showTimestamp = true
            Hardcore_Score.db.profile.framePositionLog.showTimestamp = showTimestamp
        end

        local showMainScore = Hardcore_Score.db.profile.framePosition.show
        if showMainScore == nil then
            showMainScore = true
            Hardcore_Score.db.profile.framePosition.show = showTimestamp
        end

        local fontName, _, fontFlags = HCS_PointsLogUI.EditBox:GetFont()
        HCS_PointsLogUI.EditBox:SetFont(fontName, fontSize, fontFlags)

        playerName = HCS_Utils:GetTextWithClassColor(HCScore_Character.classid, HCScore_Character.name)

        -- Clear Points Log
        HCS_PointsLogUI:ClearPointsLog()

        -- Print fun stuff for the player
        print("|cff81b7e9".."Hardcore Score: ".."|r".."Welcome "..playerName.." to Hardcore Score v1.0.6.  Lets GO!")
                
        -- Localization Example
        ---- Load AceLocale-3.0
        --local AceLocale = LibStub:GetLibrary("AceLocale-3.0")

        ---- Get the localization instance for our addon
        --local L = AceLocale:GetLocale("Hardcore_Score")

        ---- Use the localized string
        --print(L["Hello"])  -- Will print "Hello, World!" or "Hallo, Welt!" depending on the locale

    end

end

Hardcore_Score.events = CreateFrame("Frame")
Hardcore_Score.events:RegisterEvent("ADDON_LOADED")
Hardcore_Score.events:RegisterEvent("PLAYER_LOGIN")
Hardcore_Score.events:SetScript("OnEvent", Hardcore_Score.init)

