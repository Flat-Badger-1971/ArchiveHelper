local AH = _G.ArchiveHelper
AH.Sounds = {
    Gw = { sound = _G.SOUNDS.BATTLEGROUND_ONE_MINUTE_WARNING, cycle = 1 },
    Marauder = { sound = _G.SOUNDS.DUEL_START, cycle = 5 },
    Terrain = { sound = _G.SOUNDS.DUEL_START, cycle = 1 },
    Tomeshell = { sound = _G.SOUNDS.CHAMPION_POINTS_COMMITTED, cycle = 1 },
}

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
