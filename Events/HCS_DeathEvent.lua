HCS_DeathEvent = {}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_DEAD")

f:SetScript("OnEvent", function(self, event, ...)
    -- This code runs when the player dies
    HCScore_Character.deaths = HCScore_Character.deaths + 1
--    HCS_MessageFrameUI.DisplayMessage("You have died.  Try again!")
    print("You have died.  Try again!")
end)