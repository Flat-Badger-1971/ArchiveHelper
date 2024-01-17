local AH = _G.ArchiveHelper
AH.Sounds = {
    Horn = {sound = _G.SOUNDS.BATTLEGROUND_ONE_MINUTE_WARNING, cycle = 1},
    Marauder = {sound = _G.SOUNDS.DUEL_START, cycle = 5},
    Tomeshell = {sound = _G.SOUNDS.CHAMPION_POINTS_COMMITTED, cycle = 1}
}

AH.bosses = {}

local function isMarauder(name)
    local bossName = name:lower()

    for _, marauder in ipairs(AH.Marauders) do
        if (bossName:find(marauder)) then
            return true
        end
    end

    return false
end

local function bossHandled(unitTag, name)
    if (AH.bosses[unitTag] == name) then
        return true
    end

    AH.bosses[unitTag] = name

    return false
end

function AH.OnNewBoss(_, unitTag)
    if (not AH.Vars.MarauderPlay) then
        return
    end

    if (not IsInstanceEndlessDungeon() or ((unitTag or "") == "")) then
        return
    end

    local bossName = GetUnitName(unitTag)

    if (bossHandled(unitTag, bossName)) then
        return
    end

    if (isMarauder(bossName)) then
        AH.PlayAlarm(AH.Sounds.Marauder)
        AH.MARAUDER = bossName
    end
end

function AH.PlayAlarm(sound)
    PlaySound(sound.sound)
    local count = 1

    if (sound.cycle > 1) then
        EVENT_MANAGER:RegisterForUpdate(
            AH.Name .. "_alarm",
            250,
            function()
                PlaySound(sound.sound)
                count = count + 1

                if (count == sound.cycle) then
                    EVENT_MANAGER:UnregisterForUpdate(AH.Name .. "_alarm")
                end
            end
        )
    end
end
