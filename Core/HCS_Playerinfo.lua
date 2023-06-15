HCS_Playerinfo = {}

CurrentXP = 0
CurrentMaxXP = 0
MobCombatKill = false
MobName = ""
MobLevel = 0
ZoneChanged = false

function HCS_Playerinfo:LoadCharacterData()  
    
    HCS_Playerinfo:GetHCS_Playerinfo()
--    print("Got Player Info")

    HCScore_Character.scores.levelingScore = HCS_PlayerLevelingScore:GetLevelScore()
--    print("Got Level Score")

    HCScore_Character.scores.equippedGearScore = HCS_PlayerEquippedGearScore:GetEquippedGearScore()
--    print("Got Player GetEquippedGearScore")

    --HCScore_Character.scores.questingScore = HCS_PlayerQuestingScore:GetQuestingScore();
    --print("Got Questing Score")

    HCScore_Character.scores.coreScore = HCS_PlayerCoreScore:GetCoreScore()
--    print("Got Core Score")

    HCS_ReputationScore:UpdateRepScore()
    --SaveHCScoreData:SaveVariables()
    --  SaveVariables("HCScore_StoredVariables")
    -- HCS_ScoreboardUI:UpdateUI()

end

function HCS_Playerinfo:GetHCS_Playerinfo()
    HCScore_Character.name = UnitName("player")
    HCScore_Character.class = UnitClass("player")
    HCScore_Character.level = UnitLevel("player")
    HCScore_Character.faction = UnitFactionGroup("player")
    HCScore_Character.version = HCS_Version
    if HCScore_Character.deaths == nil then HCScore_Character.deaths = 0 end
    if HCScore_Character.milestones == nil then HCScore_Character.milestones = {} end

    
   -- _G["CurrentXP"] = UnitXP("player")  -- CurrentXP
   -- _G["CurrentMaxXP"] = UnitXPMax("player") -- CurrentMaxXP

    --print("CurrentXP: "..CurrentXP)

end




