local AH = ArchiveHelper
local lastStun = 0
local lastMapId = 0

local function onSelectorHiding()
    if (AH.Notice) then
        AH.Release("Notice")
    end

    if (AH.QuestReminder) then
        AH.Release("QuestReminder")
    end
end

local function onBuffSelected(_, unitTag, abilityId, _, name)
    -- TODO: values come through as an array of named values
    local avatar = AH.LIA:IsAvatar(abilityId)
    d(unitTag, abilityId, name)
    if (avatar) then
        AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + 1

        if (AH.Vars.AvatarVisionCount[avatar] == 4) then
            AH.Vars.AvatarVisionCount[avatar] = 0
        end
    end

    zo_callLater(
        function()
            local abilityInfo = AH.ABILITIES[abilityId]
            local abilityType = abilityInfo.type or AH.TYPES.VERSE
            local count

            if (AreUnitsEqual(unitTag, "player")) then
                if (avatar) then
                    count = AH.Vars.AvatarVisionCount[avatar] or 0
                else
                    local counts = ENDLESS_DUNGEON_MANAGER:GetAbilityStackCountTable(abilityType)

                    count = counts[abilityId] or 0
                end
            end

            AH.GroupChat(abilityId, count, name, unitTag)
        end,
        500
    )
end

local function checkNotice()
    local message = nil
    local stageCounter, cycleCounter = ENDLESS_DUNGEON_MANAGER:GetProgression()
    local stageTarget, cycleTarget = 2, 5

    if (AH.LIA:IsInUnknown()) then
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

local function onItemDetected(_, _, itemType)
    if (AH.LIA:IsInsideArchive() and AH.Vars.CheckQuestItems and AH.InCombet) then
        AH.FoundQuestItem = (itemType == "QuestItem") and true or false
    end
end

local function onTomeshellDestroyed(_, _, _, left)
    AH.PlayAlarm(AH.Sounds.Tomeshell)

    local message = ZO_CachedStrFormat(ARCHIVEHELPER_TOMESHELL_COUNT, left)

    if (AH.TomeCount) then
        AH.TomeCount:SetText(message)
    end
end

local function startTomeCheck()
    AH.MaxTomes = AH.LIA:GetMaxTomes()

    local message = ZO_CachedStrFormat(ARCHIVEHELPER_TOMESHELL_COUNT, AH.MaxTomes)

    AH.ShowTomeshellCount()
    AH.TomeCount:SetText(message)
end

local function stopTomeCheck()
    if (AH.TomeCount) then
        AH.TomeCount:SetHidden(true)
        AH.Release("TomeCount")
    end
end

local function zoneCheck()
    local mapId = GetCurrentMapId()

    if (mapId == AH.LIA.MAPS.TREACHEROUS_CROSSING.id) then
        if (AH.Vars.ShowHelper) then
            AH.ShowCrossingHelper()
        end
    elseif (mapId == AH.LIA.MAPS.THEATRE_OF_WAR.id) then
        AH.IsInTheatre = true

        if (AH.Vars.Theatre) then
            AH.SetTheatreWarning(true)
        end
    else
        AH.IsInTheatre = false

        if (AH.Timer) then
            AH.HideTimer()
        end

        if (AH.CrossingHelperFrame) then
            AH.HideCrossingHelper()
        end
    end
end

local function onPlayerActivated()
    local mapId = GetCurrentMapId()

    if (lastMapId ~= mapId) then
        lastMapId = mapId

        zoneCheck()

        if (AH.Vars.CountTomes and mapId == AH.LIA.MAPS.FILERS_WING.id) then
            AH.IsInFilersWing = true
        else
            AH.IsInFilersWing = false

            if (AH.TomeCount) then
                stopTomeCheck()
            end
        end
    end

    AH.CurrentGroupType = AH.LIA:GetEffectiveGroupType()
end

local function auditorCheck()
    if (not IsInstanceEndlessDungeon() or AH.InCombet) then
        return
    end

    --- @diagnostic disable-next-line undefined-global
    local actor = GAMEPLAY_ACTOR_CATEGORY_PLAYER

    if (AH.Vars.Auditor and IsCollectibleUsable(AH.AUDITOR, actor) and not AH.LIA:IsInUnknown()) then
        if (not AH.LIA:IsAuditorActive()) then
            --- @diagnostic disable-next-line undefined-global
            local actor = GAMEPLAY_ACTOR_CATEGORY_PLAYER
            local cooldown = GetCollectibleCooldownAndDuration(AH.AUDITOR)

            if (cooldown == 0) then
                UseCollectible(AH.AUDITOR, actor)
                UseCollectible(AH.AUDITOR, actor)
            end
        end
    end
end

local function onUnknownPortalStateChanged(_, _, mapId, _, state)
    -- update AH state
    onPlayerActivated()

    -- check the auditor status
    auditorCheck()

    -- Echoing Den
    if (mapId == AH.LIA.MAPS.ECHOING_DEN.id) then
        if (state == AH.LIA.UNKNOWN_PORTAL_STATE_STARTED) then
            -- check the auditor status
            auditorCheck()
            AH.DenDone = false
            AH.StartTimer()
        elseif (state == AH.LIA.UNKNOWN_PORTAL_STATE_FAILED or state == AH.LIA.UNKNOWN_PORTAL_STATE_SUCCESS) then
            AH.StopTimer()
            AH.DenDone = true
        end
    end

    -- Treacherous Crossing
    if (mapId == AH.LIA.MAPS.TREACHEROUS_CROSSING.id) then
        if (state == AH.LIA.UNKNOWN_PORTAL_STATE_ENTERED) then
            AH.ShowCrossingHelper()
        elseif (state == AH.LIA.UNKNOWN_PORTAL_STATE_FAILED or state == AH.LIA.UNKNOWN_PORTAL_STATE_SUCCESS) then
            AH.HideCrossingHelper()
        end
    end

    -- Filer's Wing
    if (mapId == AH.LIA.MAPS.FILERS_WING.id) then
        if (state == AH.LIA.UNKNOWN_PORTAL_STATE_STARTED) then
            startTomeCheck()
        elseif (state == AH.LIA.UNKNOWN_PORTAL_STATE_FAILED or state == AH.LIA.UNKNOWN_PORTAL_STATE_SUCCESS) then
            stopTomeCheck()
        end
    end
end

local function resetValues()
    AH.FoundQuestItem = false
    ZO_ClearNumericallyIndexedTable(AH.Shards)

    for _, info in pairs(AH.MARKERS) do
        info.manual = false
    end

    if (AH.LIA:IsInsideArchive()) then
        AH.SetTerrainWarnings(AH.Vars.TerrainWarnings)
    end
end

-- minimise false zone change detections
local function onStunned(_, stunned)
    if (stunned and not IsUnitInCombat("player")) then
        local now = GetTimeStamp()

        if ((now - lastStun) > 2) then
            zo_callLater(
                function()
                    if (not AH.ShowingBuffs) then
                        resetValues()
                    end
                end,
                1000
            )
            lastStun = now
        end
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

    if (visionCount) then
        for avatar, data in pairs(AH.LIA.AVATAR) do
            for _, abilityId in ipairs(data.abilityIds) do
                if (abilityId ~= data.transform) then
                    local count = visionCount[abilityId] or 0

                    AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + count
                end
            end
        end
    end
end

local function onQuestCounterChanged(_, journalIndex)
    local indexes = AH.LIA:GetArchiveQuestIndices(true)

    if (ZO_IsElementInNumericallyIndexedTable(indexes, journalIndex)) then
        AH.FoundQuestItem = false
    end
end

local player = GetUnitName("player")

-- TODO: Handle crossing data sharing
-- **********
-- TODO: Handle crossing data sharing
-- **********
local function getOtherPlayer()
    local groupSize = GetGroupSize()

    if (groupSize == 0) then
        return
    end

    for unit = 1, groupSize do
        local unitTag = string.format("group%d", unit)

        if (IsUnitOnline(unitTag)) then
            local name = GetUnitName(unitTag)

            if (name ~= player) then
                return name, unitTag
            end
        end
    end
end

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
-- **********

local function onLeaderUpdate()
    if (AH.CrossingHelperFrame) then
        if (not AH.CrossingHelperFrame:IsHidden()) then
            AH.SetDisableCombos()
        end
    end
end

local function onMysteryVerseUsed(_, unitTag, abilityId)
    zo_callLater(
        function()
            AH.GroupChat(abilityId, 999, nil, unitTag)
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

-- TODO: Finish this
-- Theatre of War
-- interrupt - SI_BINDING_NAME_SPECIAL_MOVE_INTERRUPT
-- local function theatreWarnings(...)
--     local source = select(7, ...)
--     local powerType = select(12, ...)
--     local abilityId = select(17, ...)

--     if (arcane[abilityId]) then
--         -- shard of chaos
--         d("shard!: " .. abilityId)
--     elseif (seeking[abilityId]) then
--         -- Aramril's sustained attack
--         d("Aramril!: " .. abilityId)
--     elseif (powerType == POWERTYPE_HEALTH and GetUnitName("boss1") == source) then
--         local health = GetUnitPower("boss1", POWERTYPE_HEALTH)

--         d("boss health: " .. health)

--         if (health % 25 == 0) then
--             d("teleport: " .. health)
--         end
--     end
-- end

function AH.SetTheatreWarning(enable)
    --     if (not arcane) then
    --         arcane = AH.LC.BuildList(AH.ARCANE_BARRAGE)
    --         seeking = AH.LC.BuildList(AH.SEEKING_RUNESCRAWL)
    --     end

    --     if (enable) then
    --         EVENT_MANAGER:RegisterForEvent(
    --             AH.Name .. "theatre",
    --             EVENT_COMBAT_EVENT,
    --             function(...)
    --                 if (AH.IsInTheatre) then
    --                     theatreWarnings(...)
    --                 end
    --             end
    --         )
    --     end
end

local terrainList

local playerName = ZO_CachedStrFormat(SI_UNIT_NAME, GetUnitName("player"))

local function terrainWarnings(...)
    local targetName = ZO_CachedStrFormat(SI_UNIT_NAME, select(9, ...))
    local abilityId = select(17, ...)

    if (AH.LIA:IsInsideArchive() and (not AH.Triggered)) then
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

local function onMarauderSpawned(_, name)
    local check = AH.Vars.MarauderPlay or AH.Vars.MarauderCheck

    if (not check) then
        return
    end

    if (not IsInstanceEndlessDungeon() or ((name or "") == "")) then
        return
    end

    if (AH.Vars.MarauderPlay) then
        AH.PlayAlarm(AH.Sounds.Marauder)
    end

    AH.MARAUDER = name
end

function AH.SetTerrainWarnings(enable)
    if (enable) then
        EVENT_MANAGER:RegisterForEvent(
            AH.Name .. "terrain",
            EVENT_COMBAT_EVENT,
            function(...)
                if (AH.LIA:IsInsideArchive()) then
                    terrainWarnings(...)
                end
            end
        )
        EVENT_MANAGER:AddFilterForEvent(
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

function AH.ShareData(shareType, value)
    AH.LC.Share(AH.LC.ADDON_ID_ENUM.AH, shareType, value)
    AH.Debug("Shared: " .. value)
end

function AH.HandleDataShare(unitTag, data)
    if (AreUnitsEqual(unitTag, "player")) then
        return
    end

    if (data.id == AH.LC.ADDON_ID_ENUM.AH) then
        if (data.class == AH.SHARE.MARK) then
            if (data.data and (data.data > 0) and (data.data < 8)) then
                AH.MARKERS[data.data].used = true
                AH.MARKERS[data.data].manual = true
                AH.Debug("Received mark data: " .. data.data)
            end
        elseif (data.class == AH.SHARE.UNMARK) then
            if (data.data and (data.data > 0) and (data.data < 8)) then
                AH.MARKERS[data.data].manual = false
                AH.Debug("Received unmark data: " .. data.data)
            end
        elseif (data.class == AH.SHARE.GW) then
            if (data.data and (data.data > 0) and (not AH.FOUND_GW)) then
                if (AH.Vars.GwPlay) then
                    AH.PlayAlarm(AH.Sounds.Gw)
                end
                AH.FOUND_GW = true
                AH.Debug("Received Gw detection")
            end
        elseif (data.id == AH.SHARE.CROSSING) then
            onCrossingChange(data.data)
            AH.Debug("Received crossing data: " .. data.data)
        end
    end
end

function AH.SetupHooks()
    SecurePostHook(_G[AH.SELECTOR], "OnHiding", onSelectorHiding)
    SecurePostHook(_G[AH.SELECTOR], "OnShowing", onShowing)
end

function AH.SetupEvents()
    AH.LIA:RegisterForEvent(AH.LIA.EVENT_BUFF_SELECTED, onBuffSelected)
    AH.LIA:RegisterForEvent(AH.LIA.EVENT_ITEM_DETECTED, onItemDetected)
    AH.LIA:RegisterForEvent(AH.LIA.EVENT_MARAUDER_SPAWNED, onMarauderSpawned)
    AH.LIA:RegisterForEvent(AH.LIA.EVENT_MYSTERY_VERSE_USED, onMysteryVerseUsed)
    AH.LIA:RegisterForEvent(AH.LIA.EVENT_TOMESHELL_DESTROYED, onTomeshellDestroyed)
    AH.LIA:RegisterForEvent(AH.LIA.EVENT_UNKNOWN_PORTAL_STATE_CHANGED, onUnknownPortalStateChanged)

    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ACHIEVEMENT_UPDATED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ENDLESS_DUNGEON_INITIALIZED, onDungeonInitialised)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_LEADER_UPDATE, onLeaderUpdate)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_PLAYER_REINCARNATED, onReincarnated)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_PLAYER_STUNNED_STATE_CHANGED, onStunned)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_QUEST_CONDITION_COUNTER_CHANGED, onQuestCounterChanged)
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_RESURRECT_RESULT, onResurrected)

    if (AH.Vars.FabledCheck and AH.CompatibilityCheck()) then
        EVENT_MANAGER:RegisterForEvent(AH.Name .. "_Fabled", EVENT_PLAYER_COMBAT_STATE, AH.CombatCheck)
    end

    if (AH.Vars.AutoCheck) then
        AH.UpdateSlottedSkills()
        EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, AH.UpdateSlottedSkills)
    end

    if (AH.Vars.TerrainWarnings) then
        AH.SetTerrainWarnings(true)
    end
end
