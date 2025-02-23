local AH = ArchiveHelper
local tomeName = GetString(ARCHIVEHELPER_TOMESHELL):lower()
local lastStun = 0
local lastMapId = 0
local lib = AH.LIA

local function onSelectorHiding()
    if (AH.Notice) then
        AH.Release("Notice")
    end

    if (AH.QuestReminder) then
        AH.Release("QuestReminder")
    end
end

local function encode(abilityId, count)
    return tonumber(string.format("%06d%d", abilityId, count))
end

local function onChoiceCommitted(_, selectedBuff, name, unitName)
    if (selectedBuff) then
        local avatar = lib:IsAvatar(AH.SelectedBuff)

        if (avatar) then
            AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + 1

            if (AH.Vars.AvatarVisionCount[avatar] == 4) then
                AH.Vars.AvatarVisionCount[avatar] = 0
            end
        end

        zo_callLater(
            function()
                local abilityInfo = AH.ABILITIES[selectedBuff]
                local abilityType = abilityInfo.type or AH.TYPES.VERSE
                local count

                if (avatar) then
                    count = AH.Vars.AvatarVisionCount[avatar] or 0
                else
                    local counts = ENDLESS_DUNGEON_MANAGER:GetAbilityStackCountTable(abilityType)
                    count = counts[selectedBuff] or 0
                end

                AH.GroupChat(encode(selectedBuff, count), name, unitName)
                --AH.ShareData(AH.SHARE.ABILITY, selectedBuff, nil, count) -- already shared
            end,
            500
        )

        AH.SelectedBuff = nil
    end
end

local function checkNotice()
    local message = nil
    local stageCounter, cycleCounter = ENDLESS_DUNGEON_MANAGER:GetProgression()
    local stageTarget, cycleTarget = 2, 5

    if (AH.IsInUnknown()) then
        stageTarget = 3
    end

    if (stageCounter == stageTarget and cycleCounter ~= cycleTarget) then
        message = AH.LC.Format(ARCHIVEHELPER_CYCLE_BOSS)
    elseif (cycleCounter == cycleTarget and stageCounter == stageTarget) then
        message = AH.LC.Format(ARCHIVEHELPER_ARC_BOSS)
    end

    if (message) then
        AH.ShowNotice(message)
    end

    AH.ShowQuestReminder()
end

local function onShowing()
    AH.OnBuffSelectorShowing()
    AH.ShowingBuffs = true
    checkNotice()
end

local function auditorCheck()
    if (not IsInstanceEndlessDungeon()) then
        return
    end

    if (AH.Vars.Auditor and IsCollectibleUsable(AH.AUDITOR) and (not IsUnitInCombat("player")) and not AH.IsInUnknown()) then
        if (not AH.IsAuditorActive()) then
            local cooldown = GetCollectibleCooldownAndDuration(AH.AUDITOR)

            if (cooldown == 0) then
                UseCollectible(AH.AUDITOR)
            end
        end
    end
end

local function onUnknownPortalStateChange(_, mapId, mapName, state)
    -- Herd the Ghost Lights
    if (mapId == lib.MAPS.ECHOING_DEN.id) then
        if (state == lib.UNKNOWN_PORTAL_STATE_STARTED) then
            if (AH.Vars.ShowTimer) then
                AH.DenDone = false
                AH.StartTimer()
            end
        elseif (state == lib.UNKNOWN_PORTAL_STATE_FAILED or lib.UNKNOWN_PORTAL_STATE_STARTED or lib.UNKNOWN_PORTAL_STATE_ENDED) then
            AH.StopTimer()
            AH.DenDone = true
        end
    end

    -- Treacherous Crossing
    if (mapId == lib.MAPS.TREACHEROUS_CROSSING.id) then
        if (state == lib.UNKNOWN_PORTAL_STATE_FAILED or lib.UNKNOWN_PORTAL_STATE_STARTED or lib.UNKNOWN_PORTAL_STATE_ENDED) then
            AH.HideCrossingHelper()
        end
    end

    -- Filer's Wing
    if (mapId == lib.MAPS.FILERS_WING.id) then
        if (state == lib.UNKNOWN_PORTAL_STATE_STARTED) then
            local message = ZO_CachedStrFormat(ARCHIVEHELPER_TOMESHELL_COUNT, lib:GetMaxTomes())

            AH.ShowTomeshellCount()
            AH.TomeCount:SetText(message)
        elseif (state == lib.UNKNOWN_PORTAL_STATE_ENDED) then
            if (AH.TomeCount) then
                AH.TomeCount:SetHidden(true)
                AH.Release("TomeCount")
            end
        end
    end

    -- check for loyal auditor
    auditorCheck()
end

local function onPlayerActivated()
    ZO_ClearNumericallyIndexedTable(AH.Shards)

    for _, info in pairs(AH.MARKERS) do
        info.manual = false
    end

    if (lib:IsInsideArchive()) then
        AH.SetTerrainWarnings(AH.Vars.TerrainWarnings)
    end
end

local function onReincarnated()
    auditorCheck()
end

local function onResurrected(_, _, result, displayName)
    if (displayName == GetUnitDisplayName("player")) then
        if (result == RESURRECT_RESULT_SUCCESS) then
            auditorCheck()
        end
    end
end

local function onDungeonInitialised()
    local visionCount = ENDLESS_DUNGEON_MANAGER:GetAbilityStackCountTable(ENDLESS_DUNGEON_BUFF_TYPE_VISION)

    AH.Vars.AvatarVisionCount = { ICE = 0, WOLF = 0, IRON = 0, UNDEAD = 0 }
    AH.Vars.AvatarVisionCount = { ICE = 0, WOLF = 0, IRON = 0, UNDEAD = 0 }

    if (visionCount) then
        for avatar, data in pairs(lib.AVATAR) do
            for _, abilityId in ipairs(data.abilityIds) do
                if (abilityId ~= data.transform) then
                    local count = visionCount[abilityId] or 0

                    AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + count
                end
            end
        end
    end
end

local function onTomeDestroyed(_, _, remaining)
    if (AH.TomeCount) then
        local message = ZO_CachedStrFormat(ARCHIVEHELPER_TOMESHELL_COUNT, remaining)

        AH.PlayAlarm(AH.Sounds.Tomeshell)
        AH.TomeCount:SetText(message)
    end
end

-- TODO: share using libFBCommon
local function onCrossingChange(selections)
    if (AH.CrossingHelperFrame) then
        if (not AH.IsLeader) then
            local values = {}

            -- convert the text to an array
            selections:gsub(
                ".",
                function(c)
                    table.insert(values, c)
                end
            )

            local box1, box2, box3 = tonumber(values[1]), tonumber(values[2]), tonumber(values[3])

            AH.CrossingHelperFrame.box1.SetSelected(box1 == 0 and 7 or box1)
            AH.CrossingHelperFrame.box2.SetSelected(box2 == 0 and 7 or box2)
            AH.CrossingHelperFrame.box3.SetSelected(box3 == 0 and 7 or box3)
            AH.selectedBox[1] = box1
            AH.selectedBox[2] = box2
            AH.CrossingUpdate(3, box3, true)
        end
    end
end

local function onLeaderUpdate()
    if (AH.CrossingHelperFrame) then
        if (not AH.CrossingHelperFrame:IsHidden()) then
            AH.SetDisableCombos()
        end
    end
end

local function onMysteryVerseUsed(_, abilityId, name)
    zo_callLater(
        function()
            AH.GroupChat(encode(abilityId, 999))
        end,
        1000
    )
end

AH.Detected = nil
AH.Triggered = false

local function warnNow(abilityId, message)
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_MAJOR_TEXT)
    local colour = AH.LC.White

    if (not message) then
        colour = (abilityId > 200000) and AH.LC.Cyan or AH.LC.Red
        messageParams:SetText(colour:Colorize(ZO_CachedStrFormat("<<C:1>>", AH.Detected) .. "!"))
    else
        messageParams:SetText(colour:Colorize(ZO_CachedStrFormat("<<C:1>>", GetAbilityName(abilityId, "player")) .. "!"))
    end

    messageParams:SetSound(AH.Sounds.Terrain.sound)
    messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_SYSTEM_BROADCAST)
    messageParams:MarkShowImmediately()

    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

local arcane, seeking

-- Theatre of War
-- interrupt - SI_BINDING_NAME_SPECIAL_MOVE_INTERRUPT
local function theatreWarnings(...)
    local source = select(7, ...)
    local powerType = select(12, ...)
    local abilityId = select(17, ...)

    if (arcane[abilityId]) then
        -- shard of chaos
        d("shard!: " .. abilityId)
    elseif (seeking[abilityId]) then
        -- Aramril's sustained attack
        d("Aramril!: " .. abilityId)
    elseif (powerType == POWERTYPE_HEALTH and GetUnitName("boss1") == source) then
        local health = GetUnitHealth("boss1")

        d("boss health: " .. health)

        if (health % 25 == 0) then
            d("teleport: " .. health)
        end
    end
end

function AH.SetTheatreWarning(enable)
    if (not arcane) then
        arcane = AH.LC.BuildList(AH.ARCANE_BARRAGE)
        seeking = AH.LC.BuildList(AH.SEEKING_RUNESCRAWL)
    end

    if (enable) then
        EVENT_MANAGER:RegisterForEvent(
            AH.Name .. "theatre",
            EVENT_COMBAT_EVENT,
            function(...)
                if (AH.IsInTheatre) then
                    theatreWarnings(...)
                end
            end
        )
    end
end

local function onMarauderSpawned(_, name)
    if (AH.Vars.MarauderPlay) then
        AH.PlayAlarm(AH.Sounds.Marauder)
    end

    AH.MARAUDER = name
end

local terrainList

local playerName = ZO_CachedStrFormat(SI_UNIT_NAME, GetUnitName("player"))

local function terrainWarnings(...)
    local targetName = ZO_CachedStrFormat(SI_UNIT_NAME, select(9, ...))
    local abilityId = select(17, ...)

    if (not AH.InsideArchive) then
        AH.InsideArchive = IsInstanceEndlessDungeon() and (GetCurrentMapId() ~= AH.ArchiveIndex)
    end

    if (AH.InsideArchive and (not AH.Triggered)) then
        if (targetName == playerName) then
            if (terrainList[abilityId]) then
                AH.Detected = GetAbilityName(abilityId, "player")
            else
                AH.Detected = nil
            end

            if (AH.Detected and (not AH.Triggered)) then
                AH.Triggered = true
                warnNow(abilityId)
                zo_callLater(
                    function()
                        AH.Triggered = false
                        AH.Detected = nil
                    end,
                    1000
                )
            end
        end
    end
end

function AH.SetTerrainWarnings(enable)
    if (enable) then
        EVENT_MANAGER:RegisterForEvent(
            AH.Name .. "terrain",
            EVENT_COMBAT_EVENT,
            function(...)
                if (AH.InsideArchive) then
                    terrainWarnings(...)
                end
            end
        )
        EVENT_MANAGER:AddFilterForEvent(
            AH.Name .. "terrain",
            AH.Name .. "terrain",
            EVENT_COMBAT_EVENT,
            REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE,
            COMBAT_UNIT_TYPE_PLAYER
        )

        if (not terrainList) then
            terrainList = AH.LC.BuildList(AH.TERRAIN)
        end
    else
        EVENT_MANAGER:UnregisterForEvent(AH.Name .. "terrain", EVENT_COMBAT_EVENT)
    end
end

-- function AH.ShareData(shareType, value, instant, stackCount)
--     if ((not AH.Share) and (not AH.DEBUG)) then
--         return
--     end

--     local encoded

--     if (stackCount) then
--         encoded = encode(value, stackCount)
--     else
--         encoded = string.format("%s%s", shareType, value)
--     end

--     encoded = tonumber(encoded)

--     if (AH.Share) then
--         if (instant) then
--             AH.Share:SendData(encoded)
--         else
--             AH.Share:QueueData(encoded)
--         end
--     end

--     AH.Debug("Shared: " .. encoded)
-- end

function AH.SetupHooks()
    SecurePostHook(_G[AH.SELECTOR], "OnHiding", onSelectorHiding)
    SecurePostHook(_G[AH.SELECTOR], "OnShowing", onShowing)
    lib:RegisterForEvent(lib.EVENT_BUFF_SELECTED, onChoiceCommitted)
    lib:RegisterForEvent(lib.EVENT_UNKNOWN_PORTAL_STATE_CHANGED, onUnknownPortalStateChange)
    lib:RegisterForEvent(lib.EVENT_MARAUDER_SPAWNED, onMarauderSpawned)
end

function AH.SetupEvents()
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ACHIEVEMENT_UPDATED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ACHIEVEMENT_AWARDED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ENDLESS_DUNGEON_INITIALIZED, onDungeonInitialised)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_LEADER_UPDATE, onLeaderUpdate)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_PLAYER_REINCARNATED, onReincarnated)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_RESURRECT_RESULT, onResurrected)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_PLAYER_ACTIVATED, onPlayerActivated)

    if (AH.Vars.FabledCheck and AH.CompatibilityCheck()) then
        EVENT_MANAGER:RegisterForEvent(AH.Name .. "_Fabled", EVENT_PLAYER_COMBAT_STATE, AH.CombatCheck)
    end

    if (AH.Vars.AutoCheck) then
        AH.UpdateSlottedSkills()
        EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, AH.UpdateSlottedSkills) -- unknown portal state changed
    end

    if (AH.Vars.TerrainWarnings) then
        AH.SetTerrainWarnings(true)
    end

    lib:RegisterForEvent(lib.EVENT_MYSTERY_VERSE_USED, onMysteryVerseUsed)
    lib:RegisterForEvent(lib.EVENT_TOMESHELL_DESTROYED, onTomeDestroyed)
end
