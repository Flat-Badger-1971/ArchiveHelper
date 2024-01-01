local AH = _G.ArchiveHelper

AH.MissingAbilities = {}

local sounds = {
    Marauder = {sound = _G.SOUNDS.DUEL_START, cycle = 5}
}

function AH.Format(value, ...)
    local text = value

    if (type(value) == "number") then
        text = GetString(value)
    end

    return ZO_CachedStrFormat("<<C:1>>", text, ...)
end

function AH.Filter(t, filterFunc)
    local out = {}

    for k, v in pairs(t) do
        if (filterFunc(v, k, t)) then
            table.insert(out, v)
        end
    end

    return out
end

function AH.IsRecorded(id, list)
    for _, listItem in ipairs(list) do
        if (listItem.id == id) then
            return true
        end
    end

    return false
end

function AH.GetRecord(id, table)
    for _, record in ipairs(table) do
        if (record.id == id) then
            return record
        end
    end
end

function AH.ColourIcon(icon, colour, width, height)
    local texture = zo_iconFormat(icon, width or 24, height or 24)

    texture = string.format("|c%s%s|r", colour, texture:gsub("|t$", ":inheritColor|t"))

    return texture
end

function AH.ScreenAnnounce(header, message, icon, lifespan, sound)
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(_G.CSA_CATEGORY_LARGE_TEXT)

    if (sound ~= "none") then
        messageParams:SetSound(sound or "Justice_NowKOS")
    end

    messageParams:SetText(header or "Test Header", message or "Test Message")
    messageParams:SetLifespanMS(lifespan or 6000)
    messageParams:SetCSAType(_G.CENTER_SCREEN_ANNOUNCE_TYPE_SYSTEM_BROADCAST)

    if (icon) then
        messageParams:SetIconData(icon)
    end

    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

function AH.Announce(achievementName, icon, remaining)
    local message =
        zo_strformat(GetString(_G.ARCHIVEHELPER_PROGRESS), "|cffff00", achievementName, "|r", remaining) .. "|r"

    if (AH.Vars.NotifyScreen) then
        AH.ScreenAnnounce(AH.Format(_G.ARCHIVEHELPER_PROGRESS_ACHIEVEMENT), message, icon)
    end

    if (AH.Vars.NotifyChat and AH.Chat) then
        AH.Chat:SetTagColor("dc143c"):Print(message)
    end
end

function AH.EventNotifier(id)
    if (AH.Vars.Notify) then
        if (id >= AH.ACHIEVEMENTS.START and id <= AH.ACHIEVEMENTS.END) then
            local status = ACHIEVEMENTS_MANAGER:GetAchievementStatus(id)
            if
                (status == _G.ZO_ACHIEVEMENTS_COMPLETION_STATUS.IN_PROGRESS or
                    status == _G.ZO_ACHIEVEMENTS_COMPLETION_STATUS.IN_PROGRESS)
             then
                local announce = true

                if (ZO_IsElementInNumericallyIndexedTable(AH.ACHIEVEMENTS.LIMIT, id)) then
                    local _, completed, required = GetAchievementCriterion(id, 1)
                    local remaining = required - completed

                    if (remaining % 100 ~= 0) then
                        announce = false
                    end
                end

                if (announce) then
                    local name, _, _, icon = GetAchievementInfo(id)
                    local stepsRemaining = 0

                    for criteria = 1, GetAchievementNumCriteria(id) do
                        local _, completed, required = GetAchievementCriterion(id, criteria)

                        if (completed ~= required) then
                            stepsRemaining = stepsRemaining + (required - completed)
                        end
                    end

                    if (stepsRemaining > 0) then
                        AH.Announce(name, icon, stepsRemaining)
                    end
                end
            end
        end
    end
end

local function zoneCheck()
    if (GetCurrentMapId() == AH.MAPS.ECHOING_DEN.id) then
        AH.IsInEchoingDen = true
        AH.DenStarted = true
        AH.ShowTimer()
    else
        AH.InEchoingDen = false
        AH.DenStarted = false

        if (AH.Timer) then
            if (not AH.Timer:IsHidden()) then
                AH.HideTimer()
            end
        end
    end
end

local bosses = {}
local sourceIds = {}
local lastMapId = 0

function AH.CheckZone()
    local mapId = GetCurrentMapId()

    if (lastMapId ~= mapId) then
        lastMapId = mapId
        ZO_ClearNumericallyIndexedTable(bosses)
        ZO_ClearNumericallyIndexedTable(sourceIds)
        AH.FoundQuestItem = false
        AH.InsideArchive = IsInstanceEndlessDungeon() and (GetCurrentMapId() ~= AH.ArchiveIndex)

        if (AH.Vars.ShowTimer) then
            zoneCheck()
        end
    end
end

local function checkMessage(messageParams)
    if (IsInstanceEndlessDungeon() and not AH.DenStarted) then
        AH.CheckZone()
    end

    -- Herd the Ghost Lights
    if (AH.IsInEchoingDen) then
        local message = AH.Format(messageParams:GetMainText()):lower()
        local secondaryMessage = AH.Format(messageParams:GetSecondaryText() or ""):lower()
        local start = AH.Format(_G.ARCHIVEHELPER_HERD):lower()
        local fail = AH.Format(_G.ARCHIVEHELPER_HERD_FAIL):lower()
        local success = AH.Format(_G.ARCHIVEHELPER_HERD_SUCCESS):lower()

        if (message:find(start)) then
            AH.DenDone = false
            AH.StartTimer()
        elseif
            (message:find(fail) or message:find(success) or secondaryMessage:find(fail) or
                secondaryMessage:find(success))
         then
            AH.StopTimer()
            AH.DenDone = true
        end
    end
end

local function isInUnknown()
    local id = GetCurrentMapId()

    for _, mid in pairs(AH.MAPS) do
        if (mid.id == id) then
            return true
        end
    end

    return false
end

local function checkNotice()
    local message = nil
    local stageCounter, cycleCounter = ENDLESS_DUNGEON_MANAGER:GetProgression()
    local stageTarget, cycleTarget = 2, 5

    if (isInUnknown()) then
        stageTarget = 3
    end

    if (stageCounter == stageTarget and cycleCounter ~= cycleTarget) then
        message = AH.Format(_G.ARCHIVEHELPER_CYCLE_BOSS)
    elseif (cycleCounter == cycleTarget and stageCounter == stageTarget) then
        message = AH.Format(_G.ARCHIVEHELPER_ARC_BOSS)
    end

    if (message) then
        AH.ShowNotice(message)
    end

    AH.ShowQuestReminder()
end

local function closeNotice()
    if (AH.Notice) then
        AH.Notice:SetHidden(true)
    end

    if (AH.QuestReminder) then
        AH.QuestReminder:SetHidden(true)
    end
end

function AH.IsAvatar(abilityId)
    for avatar, info in pairs(AH.AVATAR) do
        if (ZO_IsElementInNumericallyIndexedTable(info.abilityIds, abilityId)) then
            return avatar
        end
    end
end

local function checkCommitted()
    if (AH.SelectedBuff) then
        local avatar = AH.IsAvatar(AH.SelectedBuff)

        if (avatar) then
            AH.Vars.AvatarVisionCount[avatar] = AH.Vars.AvatarVisionCount[avatar] + 1

            if (AH.Vars.AvatarVisionCount[avatar] == 4) then
                AH.Vars.AvatarVisionCount[avatar] = 0
            end
        end

        AH.SelectedBuff = nil
    end
end

local function onShowing()
    AH.OnBuffSelectorShowing()
    checkNotice()
end

local function onSelecting(_, buffControl)
    AH.SelectedBuff = GetEndlessDungeonBuffSelectorBucketTypeChoice(buffControl.bucketType)
end

local function onMessage(_, messageParams)
    if (not messageParams) then
        return
    end

    if (AH.Vars.ShowTimer) then
        checkMessage(messageParams)
    end

    return false
end

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
    if (bosses[unitTag] == name) then
        return true
    end

    bosses[unitTag] = name

    return false
end

local function onNewBoss(_, unitTag)
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
        AH.PlayAlarm(sounds.Marauder)
        AH.MARAUDER = bossName
    end
end

local archiveQuestIndexes = {}

local function getArchiveQuestIndexes(rebuild)
    if ((#archiveQuestIndexes == 0) or rebuild) then
        ZO_ClearNumericallyIndexedTable(archiveQuestIndexes)

        for index = 1, GetNumJournalQuests() do
            local name, _, _, _, _, complete = GetJournalQuestInfo(index)
            if (not complete and ZO_IsElementInNumericallyIndexedTable(AH.ArchiveQuests, name)) then
                table.insert(archiveQuestIndexes, index)
            end
        end
    end

    return archiveQuestIndexes
end

function AH.CheckQuest(_, journalIndex)
    local indexes = getArchiveQuestIndexes()

    if (ZO_IsElementInNumericallyIndexedTable(indexes, journalIndex)) then
        AH.FoundQuestItem = false
    end
end

local compass = _G.ZO_CompassContainer

local function checkForQuest()
    if (AH.InsideArchive and AH.Vars.CheckQuestItems and AH.InCombet) then
        if (AH.FoundQuestItem == false) then
            local numPins = compass:GetNumCenterOveredPins()

            if (numPins > 0) then
                for pin = 1, numPins do
                    local pinType = compass:GetCenterOveredPinType(pin)
                    if (pinType == _G.MAP_PIN_TYPE_QUEST_INTERACT) then
                        AH.FoundQuestItem = true
                    end
                end
            end
        end
    end
end

function AH.SetupHooks()
    SecurePostHook(_G[AH.SELECTOR], "OnHiding", closeNotice)
    SecurePostHook(_G[AH.SELECTOR], "CommitChoice", checkCommitted)
    SecurePostHook(_G[AH.SELECTOR], "OnShowing", onShowing)
    SecurePostHook(_G[AH.SELECTOR], "SelectBuff", onSelecting)
    SecurePostHook(_G.COMPASS, "OnUpdate", checkForQuest)
    SecurePostHook(CENTER_SCREEN_ANNOUNCE, "AddMessageWithParams", onMessage)
    ZO_PreHook(_G.BOSS_BAR, "AddBoss", onNewBoss)
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

function AH.Reset()
    if (not IsEndlessDungeonStarted()) then
        AH.Vars.AvatarVisionCount = {ICE = 0, WOLF = 0, IRON = 0}
    end
end

function AH.CompatibilityCheck()
    if (_G.LFM and _G.LFM.name == "LykeionsFabledMarker") then
        return false
    end

    return true
end

AH.MARKERS = {
    [_G.TARGET_MARKER_TYPE_ONE] = false,
    [_G.TARGET_MARKER_TYPE_TWO] = false,
    [_G.TARGET_MARKER_TYPE_THREE] = false,
    [_G.TARGET_MARKER_TYPE_FOUR] = false,
    [_G.TARGET_MARKER_TYPE_FIVE] = false,
    [_G.TARGET_MARKER_TYPE_SIX] = false,
    [_G.TARGET_MARKER_TYPE_SEVEN] = false
}

local function getAvailableMarker()
    for marker, used in pairs(AH.MARKERS) do
        if (not used) then
            return marker
        end
    end

    return _G.TARGET_MARKER_TYPE_NONE
end

-- local cache for performance
local GetUnitName, GetUnitTargetMarkerType = GetUnitName, GetUnitTargetMarkerType
local IsUnitDead, AssignTargetMarkerToReticleTarget = IsUnitDead, AssignTargetMarkerToReticleTarget
local fabledText = GetString(_G.ARCHIVEHELPER_FABLED)
local shardText = GetString(_G.ARCHIVEHELPER_SHARD)

function AH.FabledCheck()
    local extantMarker = GetUnitTargetMarkerType("reticleover")

    if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
        if (GetUnitName("reticleover"):find(fabledText) and not IsUnitDead("reticleover")) then
            local marker = getAvailableMarker()
            AssignTargetMarkerToReticleTarget(marker)
            AH.MARKERS[marker] = true
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        if (not GetUnitName("reticleover"):find(fabledText)) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            AH.MARKERS[extantMarker] = false
        end
    end
end

function AH.MarauderCheck()
    if (AH.MARAUDER) then
        local extantMarker = GetUnitTargetMarkerType("reticleover")

        if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
            if (GetUnitName("reticleover") == AH.MARAUDER and not IsUnitDead("reticleover")) then
                AssignTargetMarkerToReticleTarget(_G.TARGET_MARKER_TYPE_EIGHT)
            end
        elseif (extantMarker == _G.TARGET_MARKER_TYPE_EIGHT) then
            -- sanity check
            if (not GetUnitName("reticleover") == AH.MARAUDER) then
                AssignTargetMarkerToReticleTarget(extantMarker)
            end
        end
    end
end

function AH.ShardCheck()
    local extantMarker = GetUnitTargetMarkerType("reticleover")

    if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
        if (GetUnitName("reticleover") == shardText and not IsUnitDead("reticleover")) then
            local marker = getAvailableMarker()
            AssignTargetMarkerToReticleTarget(marker)
            AH.MARKERS[marker] = true
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        if (GetUnitName("reticleover") ~= shardText) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            AH.MARKERS[extantMarker] = false
        end
    end
end

local function doChecks()
    local stage, cycle, arc = ENDLESS_DUNGEON_MANAGER:GetProgression()

    getArchiveQuestIndexes()

    AH.CHECK_MARAUDERS = AH.Vars.MarauderCheck
    AH.CHECK_FABLED = AH.Vars.FabledCheck
    AH.CHECK_SHARDS = false

    if (arc == 1) then
        -- no marauders in arc 1
        AH.CHECK_MARAUDERS = false
        if (cycle < 4) then
            -- no fabled before arc 1 cycle 4
            AH.CHECK_FABLED = false
        end
    end

    if (cycle < 5 and stage == 3) then
        -- possbile fabled due to one boss, no marauders or shards
        AH.CHECK_FABLED = true and AH.Vars.FabledCheck
        AH.CHECK_MARAUDERS = false
        AH.CHECK_SHARDS = false
    end

    if (cycle == 5 and stage == 3) then
        -- only get shards in cycle 5, stage 3, no marauders or fabled
        AH.CHECK_SHARDS = true and AH.Vars.ShardCheck
        AH.CHECK_MARAUDERS = false
        AH.CHECK_FABLED = false
    end
end

local function isItDeadDave()
    if (IsUnitDead("reticleover")) then
        local marker = GetUnitTargetMarkerType("reticleover")

        if (marker ~= _G.TARGET_MARKER_TYPE_NONE) then
            AH.MARKERS[marker] = true
        end
    end
end

function AH.CombatCheck(_, incombat)
    if
        ((AH.Vars.MarauderCheck or AH.Vars.FabledCheck or AH.ShardCheck) and AH.CompatibilityCheck() and
            AH.InsideArchive)
     then
        if (not incombat) then
            EVENT_MANAGER:UnregisterForEvent(AH.Name, _G.EVENT_RETICLE_TARGET_CHANGED)

            for marker, _ in pairs(AH.MARKERS) do
                AH.MARKERS[marker] = false
            end

            AH.MARAUDER = nil
        else
            doChecks()

            EVENT_MANAGER:RegisterForEvent(
                AH.Name,
                _G.EVENT_RETICLE_TARGET_CHANGED,
                function()
                    if (AH.InsideArchive) then
                        if (AH.CHECK_FABLED) then
                            AH.FabledCheck()
                        end

                        if (AH.CHECK_MARAUDERS) then
                            AH.MarauderCheck()
                        end

                        if (AH.CHECK_SHARDS) then
                            AH.ShardCheck()
                        end

                        isItDeadDave()
                    end
                end
            )
        end
    end

    AH.InCombet = incombat
end
