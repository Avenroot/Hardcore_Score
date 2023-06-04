local AceGUI = LibStub("AceGUI-3.0")

HCS_ScoreboardSummaryUI = {};

-- Frame 1
local txtCoreScore1
-- Frame 2
local txt_equippedgear
local txt_equippedgear_score
local txt_leveling
local txt_leveling_score
local txt_mobskilled
local txt_mobskilled_score
local txt_professions
local txt_professions_score
local txt_questing
local txt_questing_score
local txt_reputation
local txt_reputation_score
local txt_discovery
local txt_discovery_score

local frame2scoreposition = 50
local labelwidth = 100
local labelwidthscore = 75


-- Create the frame
function HCS_ScoreboardSummaryUI:CreateFrame()

    ScoreboardSummaryFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    ScoreboardSummaryFrame:SetWidth(250)
    ScoreboardSummaryFrame:SetHeight(50)
    ScoreboardSummaryFrame:SetPoint("CENTER")
    
    -- Set backdrop with gradient background and border
    ScoreboardSummaryFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    ScoreboardSummaryFrame:SetBackdropColor(0, 0, 0, 1)
    ScoreboardSummaryFrame:SetBackdropBorderColor(1, 1, 1)
    
    ScoreboardSummaryFrame:SetMovable(true)
    ScoreboardSummaryFrame:EnableMouse(true)
    ScoreboardSummaryFrame:RegisterForDrag("LeftButton")
    ScoreboardSummaryFrame:SetScript("OnDragStart", ScoreboardSummaryFrame.StartMoving)
--    frame1:SetScript("OnDragStop", frame1.StopMovingOrSizing)
    ScoreboardSummaryFrame:SetScript("OnDragStart", ScoreboardSummaryFrame.StartMoving)

    ScoreboardSummaryFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Save the new position
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()

        Hardcore_Score.db.profile.framePosition = {
            point = point,
            relativeTo = relativeTo, --"UIParent",
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs,
        }        
    end)
    
    -- Create the round image
    local image1 = ScoreboardSummaryFrame:CreateTexture(nil, "OVERLAY")
    image1:SetSize(32, 32)
    image1:SetTexture("Interface\\Addons\\Hardcore_Score\\Media\\hcs-logo-32.blp")  -- Replace with your image texture path
    image1:SetPoint("LEFT", 10, 0)
    
    -- Create the label
    txtCoreScore1 = ScoreboardSummaryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txtCoreScore1:SetPoint("LEFT", image1, "RIGHT", 10, 0)
    txtCoreScore1:SetText("Your Hardcore Score - " .. string.format("%.2f", HCScore_Character.scores.coreScore))
   
    ScoreboardSummaryFrame:Show()
  
    local frame2 = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    frame2:SetWidth(250)
    frame2:SetHeight(140)
    frame2:SetPoint("TOP", ScoreboardSummaryFrame, "BOTTOM", 0, -10)
    
    -- Set backdrop with gradient background and border
    frame2:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame2:SetBackdropColor(0, 0, 0, 1)
    frame2:SetBackdropBorderColor(1, 1, 1)
    
    frame2:SetMovable(true)
    frame2:EnableMouse(true)
    frame2:RegisterForDrag("LeftButton")
    frame2:SetScript("OnDragStart", frame2.StartMoving)
    frame2:SetScript("OnDragStop", frame2.StopMovingOrSizing)
        
    -- Equipped Gear
    txt_equippedgear = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_equippedgear:SetPoint("TOPLEFT",  10, -10)
    txt_equippedgear:SetText("Equipped Gear")
    txt_equippedgear:SetJustifyH("LEFT")
    txt_equippedgear:SetWidth(labelwidth)

    -- Equipped Gear Score
    txt_equippedgear_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_equippedgear_score:SetPoint("LEFT", txt_equippedgear, "RIGHT", frame2scoreposition, 0)
    txt_equippedgear_score:SetJustifyH("RIGHT")
    txt_equippedgear_score:SetWidth(labelwidthscore)


    -- Leveling
    txt_leveling = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_leveling:SetPoint("TOPLEFT", txt_equippedgear, "BOTTOMLEFT", 0, -5)
    txt_leveling:SetJustifyH("LEFT")
    txt_leveling:SetWidth(labelwidth)

    -- Leveling Score
    txt_leveling_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_leveling_score:SetPoint("LEFT", txt_leveling, "RIGHT", frame2scoreposition, 0)
    txt_leveling_score:SetJustifyH("RIGHT")
    txt_leveling_score:SetWidth(labelwidthscore)

    -- Questing
    txt_questing = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_questing:SetPoint("TOPLEFT", txt_leveling, "BOTTOMLEFT", 0, -5)
    txt_questing:SetJustifyH("LEFT")
    txt_questing:SetWidth(labelwidth)

    -- Questing Score
    txt_questing_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_questing_score:SetPoint("LEFT", txt_questing, "RIGHT", frame2scoreposition, 0)
    txt_questing_score:SetJustifyH("RIGHT")
    txt_questing_score:SetWidth(labelwidthscore)

    -- Mobs Killed
    txt_mobskilled = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_mobskilled:SetPoint("TOPLEFT", txt_questing, "BOTTOMLEFT", 0, -5)
    txt_mobskilled:SetJustifyH("LEFT")
    txt_mobskilled:SetWidth(labelwidth)
    
    -- Mobs Killed Score
    txt_mobskilled_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_mobskilled_score:SetPoint("LEFT", txt_mobskilled, "RIGHT", frame2scoreposition, 0)
    txt_mobskilled_score:SetJustifyH("RIGHT")
    txt_mobskilled_score:SetWidth(labelwidthscore)

    -- Professions
    txt_professions = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_professions:SetPoint("TOPLEFT", txt_mobskilled, "BOTTOMLEFT", 0, -5)
    txt_professions:SetJustifyH("LEFT")
    txt_professions:SetWidth(labelwidth)

    -- Professions Score
    txt_professions_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_professions_score:SetPoint("LEFT", txt_professions, "RIGHT", frame2scoreposition, 0)
    txt_professions_score:SetJustifyH("RIGHT")
    txt_professions_score:SetWidth(labelwidthscore)

    -- Reputations (Factions)
    txt_reputation = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_reputation:SetPoint("TOPLEFT", txt_professions, "BOTTOMLEFT", 0, -5)
    txt_reputation:SetJustifyH("LEFT")
    txt_reputation:SetWidth(labelwidth)

    -- Reputations Score
    txt_reputation_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_reputation_score:SetPoint("LEFT", txt_reputation, "RIGHT", frame2scoreposition, 0)
    txt_reputation_score:SetJustifyH("RIGHT")
    txt_reputation_score:SetWidth(labelwidthscore)

    -- Discovery
    txt_discovery = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_discovery:SetPoint("TOPLEFT", txt_reputation, "BOTTOMLEFT", 0, -5)
    txt_discovery:SetJustifyH("LEFT")
    txt_discovery:SetWidth(labelwidth)

    -- Discovery Score
    txt_discovery_score = frame2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt_discovery_score:SetPoint("LEFT", txt_discovery, "RIGHT", frame2scoreposition, 0)
    txt_discovery_score:SetJustifyH("RIGHT")
    txt_discovery_score:SetWidth(labelwidthscore)

    frame2:Hide()

    -- mouseover show/hide frame2
    ScoreboardSummaryFrame:SetScript("OnEnter", function()
        frame2:Show()
    end)

    ScoreboardSummaryFrame:SetScript("OnLeave", function()
        frame2:Hide()
    end)

end

function HCS_ScoreboardSummaryUI:UpdateUI()
    local totProfessions = HCS_ProfessionsScore:GetNumberOfProfessions()
    local totReputations = HCS_ReputationScore:GetNumFactions()
    local totMobTypesKilled = HCS_KillingMobsScore:GetNumMobTypes()
    local totQuests = HCS_PlayerQuestingScore:GetNumberOfQuests()
    local totDiscovery = HCS_DiscoveryScore:GetNumberOfDiscovery()
    local leveling = UnitLevel("player")
    
    local equippedgearScore = HCScore_Character.scores.equippedGearScore
    local levelingScore = HCScore_Character.scores.levelingScore
    local questingScore = HCScore_Character.scores.questingScore
    local mobskilledScore = HCScore_Character.scores.mobsKilledScore
    local professionsScore = HCScore_Character.scores.professionsScore
    local reputationScore = HCScore_Character.scores.reputationScore
    local discoveryScore = HCScore_Character.scores.discoveryScore

    local coreScore = HCScore_Character.scores.coreScore

    --ScoreboardSummaryFrame
    txtCoreScore1:SetText("Your Hardcore Score - ".. string.format("%.2f", coreScore))
    --Frame 2
    txt_equippedgear_score:SetText(string.format("%.2f", equippedgearScore))    
    txt_leveling:SetText("Leveling ("..leveling..")")
    txt_leveling_score:SetText(string.format("%.2f",levelingScore))
    txt_questing:SetText("Questing ("..totQuests..")")
    txt_questing_score:SetText(string.format("%.2f", questingScore))
    txt_mobskilled:SetText("Mobs Killed ("..totMobTypesKilled..")")
    txt_mobskilled_score:SetText(string.format("%.2f", mobskilledScore))
    txt_professions:SetText("Professions ("..totProfessions..")")
    txt_professions_score:SetText(string.format("%.2f", professionsScore))
    txt_reputation:SetText("Reputation ("..totReputations..")")
    txt_reputation_score:SetText(string.format("%.2f", reputationScore))
    txt_discovery:SetText("Discovery ("..totDiscovery..")")
    txt_discovery_score:SetText(string.format("%.2f", discoveryScore))

end
