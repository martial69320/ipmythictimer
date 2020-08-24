local AddonName, Addon = ...

if Addon.season.number ~= 91 then return end

Addon.season.affix = 121

--function Addon.season:GetForces(npcID, isTeeming)
    --if npcID == 148716 or npcID == 148893 or npcID == 148894 then
  --      return nil
    --end
--end

function Addon.season:Prognosis(forces)
    local currentPercent = IPMTDungeon.trash.current / IPMTDungeon.trash.total * 100
    local prognosisPercent = forces / IPMTDungeon.trash.total * 100

    local currentWave = math.floor(currentPercent / 20)
    local prognosisWave = math.floor(prognosisPercent / 20)
    if (prognosisPercent % 20 > 18 or currentWave < prognosisWave) then
        Addon.fMain.prognosis.text:SetTextColor(1,0,0)
    elseif (prognosisPercent % 20 > 15) then
        Addon.fMain.prognosis.text:SetTextColor(1,1,0)
    else
        Addon.fMain.prognosis.text:SetTextColor(1,1,1)
    end
end