HCS_KillingMobsScore = {}

local function between(x, a, b)
    return x >= a and x <= b
end
  
local function GetMobKillHCScore(mobLevel)
    local xpGain = HCS_XPUpdateEvent:GetXPGain() -- Gives the current XP gain
    local score = 0

    local playerLevel = UnitLevel("player")
    local mobDifficulty = mobLevel - playerLevel
  
    -- Multiplier lookup table. Replace these values with your own multipliers.
    local multipliers = {
        [-6] = 0.0000,
        [-5] = 0.0003,
        [-4] = 0.0004,
        [-3] = 0.0005,
        [-2] = 0.0006,
        [-1] = 0.0007,
        [0] = 0.0010,
        [1] = 0.0012,
        [2] = 0.0015,
        [3] = 0.0020,
        [4] = 0.0025,
        [5] = 0.0030,
        [6] = 0.0035,
    }

    -- Increase by 25%
    local percentIncrease = 1.25
  
    -- Look up the multiplier and apply it to the score.
    if multipliers[mobDifficulty] then
        score = xpGain * multipliers[mobDifficulty] * percentIncrease
    elseif mobDifficulty > 6 then
        score = xpGain * multipliers[6] * percentIncrease
    elseif mobDifficulty < -6 then
        score = xpGain * multipliers[-6] * percentIncrease
    end
    
    -- Overrides all the other calculations above.
    -- If mobLevel is 0 it means the mob could not be determined so 
    -- the player gets a default multiplier
    if mobLevel == 0 then
        score = xpGain * multipliers[-5] * percentIncrease -- Changed from EASY to a specific level
    end

    return {score, mobDifficulty, xpGain}
end

local function AddDangerousMobKill(mobScore, mobName)

    if not HCScore_Character.dangerousMobsKilled then
        HCScore_Character.dangerousMobsKilled = {}  -- Create an empty table
    end

    if mobName == "" then
        mobName = "None"
        _G["MobName"] = mobName
    end

    local found = false

    for _, mob in pairs(HCScore_Character.dangerousMobsKilled) do
        if mob.id == mobName and mob.difficulty == mobScore[2] then
            mob.kills = mob.kills + 1
            mob.score = mob.score + mobScore[1]
            mob.xp = mob.xp + mobScore[3]
            found = true
            break
        end
    end

    if not found then
        -- add mob details
        local newMob = {
            id = mobName,
            kills = 1,
            score = mobScore[1],
            difficulty = mobScore[2],
            xp = mobScore[3]
        }
        table.insert(HCScore_Character.dangerousMobsKilled, newMob)
    end

end

local function AddMobsKillMap(mobScore)

    if not HCScore_Character.mobsKilledMap then
        HCScore_Character.mobsKilledMap = {}  -- Create an empty table
    end

    local found = false

    for _, dif in pairs(HCScore_Character.mobsKilledMap) do
        if dif.difficulty == mobScore[2] then
            dif.score = dif.score + mobScore[1]
            dif.xp = dif.xp + mobScore[3]
            dif.kills = dif.kills + 1
            found = true
            break
        end
    end

    if not found then
        -- add new
        local newDif = {            
            difficulty = mobScore[2],
            score = mobScore[1],
            xp = mobScore[3],
            kills = 1,
        }
        table.insert(HCScore_Character.mobsKilledMap, newDif)
    end
end

function HCS_KillingMobsScore:UpdateMobsKilled()

    local mobScore = GetMobKillHCScore(_G["MobLevel"])
    local mobName = _G["MobName"]

    if not HCScore_Character.mobsKilled then
        HCScore_Character.mobsKilled = {}  -- Create an empty table
    end

    if mobName == "" then
        mobName = "None"
        _G["MobName"] = mobName
    end

    local found = false

    for _, mob in pairs(HCScore_Character.mobsKilled) do
        if mob.id == mobName then
            mob.kills = mob.kills + 1
            mob.score = mob.score + mobScore[1]
            mob.xp = (mob.xp or 0) + (mobScore[3] or 0) 
            found = true
            break
        end
    end

    if not found then
        -- add mob details
        local newMob = {
            id = mobName,
            kills = 1,
            score = mobScore[1],
            xp = mobScore[3],
        }
        table.insert(HCScore_Character.mobsKilled, newMob)
    end

    -- Add a Dangerous Kill
    if mobScore[2] >= 3 then AddDangerousMobKill(mobScore, mobName) end
    -- Add Killmap
    AddMobsKillMap(mobScore)

    local desc = mobName.." killed"
    _G["ScoringDescriptions"].mobsKilledScore = desc
    HCS_CalculateScore:RefreshScores(ScoringDescriptions)
end

function HCS_KillingMobsScore:GetNumMobTypes()
    return #HCScore_Character.mobsKilled
end

function HCS_KillingMobsScore:GetTotalMobsKilled()
    local totalKills = 0

    for _, mob in pairs(HCScore_Character.mobsKilled) do
        totalKills = totalKills + mob.kills
    end

    return totalKills
end

function HCS_KillingMobsScore:GetMobsKilledScore()
    local score = 0

    for _, mob in pairs(HCScore_Character.mobsKilled) do
        score = score + mob.score
    end   
    
    return score

end

function HCS_KillingMobsScore:GetNumberDangerousKills()
    local totalKills = 0

    for _, mob in pairs(HCScore_Character.dangerousMobsKilled) do
        totalKills = totalKills + mob.kills
    end

    return totalKills

end

function HCS_KillingMobsScore:GetToolTip(tooltip)
    local totalKilltypes = HCS_KillingMobsScore:GetNumMobTypes()
    local totalDangerousKills = HCS_KillingMobsScore:GetNumberDangerousKills()
    
    tooltip:AddLine(string.format("%.0f", (totalKilltypes)) .. " Kill Types", nil, nil, nil, true)
    tooltip:AddLine(string.format("%.0f", (totalDangerousKills)) .. " Dangerous Kills", nil, nil, nil, true)
end

