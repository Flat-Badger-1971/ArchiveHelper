local AH = _G.ArchiveHelper
local compass = _G.ZO_CompassContainer
local tomeName = GetString(_G.ARCHIVEHELPER_TOMESHELL):lower()
local lastStun = 0
local lastMapId = 0
local sourceIds = {}

local function closeNotice()
    if (AH.Notice) then
        AH.Release("Notice")
    end

    if (AH.QuestReminder) then
        AH.Release("QuestReminder")
    end

    zo_callLater(
        function()
            AH.ShowingBuffs = false
        end,
        1500
    )
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

local function checkNotice()
    local message = nil
    local stageCounter, cycleCounter = ENDLESS_DUNGEON_MANAGER:GetProgression()
    local stageTarget, cycleTarget = 2, 5

    if (AH.IsInUnknown()) then
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

local function onShowing()
    AH.OnBuffSelectorShowing()
    AH.ShowingBuffs = true
    checkNotice()
end

local function onSelecting(_, buffControl)
    AH.SelectedBuff = GetEndlessDungeonBuffSelectorBucketTypeChoice(buffControl.bucketType)
end

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

local tomesToFind = 0

local function tomeCheck(...)
    local result = select(2, ...)
    local sourceName, _, targetName = select(7, ...)

    if (result == _G.ACTION_RESULT_DIED or result == _G.ACTION_RESULT_DIED_XP) then
        targetName = AH.Format(targetName):lower()
        sourceName = AH.Format(sourceName):lower()

        if (targetName:find(tomeName) or sourceName:find(tomeName)) then
            tomesToFind = tomesToFind - 1
            AH.PlayAlarm(AH.Sounds.Tomeshell)

            if (AH.Share and AH.TomeGroupType ~= _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO) then
                AH.Share:QueueData(tomesToFind)
            end

            if (AH.MaxTomes <= 0) then
                AH.Release("TomeCount")

                return
            end

            local message = zo_strformat(_G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER, AH.MaxTomes)

            AH.TomeCount:SetText(message)
        end
    end
end

local function startTomeCheck()
    AH.TomeGroupType = GetEndlessDungeonGroupType()

    -- for the purposes of this check, players with companions count as solo
    if ((AH.TomeGroupType == _G.ENDLESS_DUNGEON_GROUP_TYPE_DUO) and HasBlockedCompanion()) then
        AH.TomeGroupType = _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO
    end

    tomesToFind = AH.TomeGroupType == _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO and AH.Tomeshells.Solo or AH.Tomeshells.Duo
    local message = zo_strformat(_G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER, tomesToFind)

    AH.ShowTomeshellCount()
    AH.TomeCount:SetText(message)

    EVENT_MANAGER:RegisterForEvent(AH.Name .. "_Tome", _G.EVENT_COMBAT_EVENT, tomeCheck)
end

local function stopTomeCheck()
    EVENT_MANAGER:UnregisterForEvent(AH.Name .. "_Tome", _G.EVENT_COMBAT_EVENT)
    AH.Release("TomeCount")
end

local function zoneCheck()
    local mapId = GetCurrentMapId()
    if (mapId == AH.MAPS.ECHOING_DEN.id) then
        AH.IsInEchoingDen = true
        AH.DenStarted = true
        AH.ShowTimer()
    else
        AH.InEchoingDen = false
        AH.DenStarted = false

        if (AH.Timer) then
            AH.HideTimer()
        end
    end
end

local function checkZone()
    local mapId = GetCurrentMapId()

    if (lastMapId ~= mapId) then
        lastMapId = mapId

        if (AH.Vars.ShowTimer) then
            zoneCheck()
        end

        if (AH.Vars.CountTomes and mapId == AH.MAPS.FILERS_WING.id) then
            AH.IsInFilersWing = true
        else
            AH.IsInFilersWing = false
        end
    end
end

local function checkMessage(messageParams)
    if (IsInstanceEndlessDungeon() and not AH.DenStarted) then
        checkZone()
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

local function onMessage(_, messageParams)
    if (not messageParams) then
        return
    end

    if (AH.Vars.ShowTimer) then
        checkMessage(messageParams)
    end

    return false
end

local function resetValues()
    ZO_ClearNumericallyIndexedTable(AH.bosses)
    ZO_ClearNumericallyIndexedTable(sourceIds)
    AH.FoundQuestItem = false
    AH.InsideArchive = IsInstanceEndlessDungeon() and (GetCurrentMapId() ~= AH.ArchiveIndex)
    ZO_ClearNumericallyIndexedTable(AH.Shards)
end

-- minimise false zone change detections
local function preZoneChange(_, stunned)
    if (stunned and not IsUnitInCombat("player")) then
        local now = GetTimeStamp()

        if (now - lastStun > 2) then
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

local function reset()
    if (not IsEndlessDungeonStarted()) then
        AH.Vars.AvatarVisionCount = {ICE = 0, WOLF = 0, IRON = 0}
    end
end

local function checkQuest(_, journalIndex)
    local indexes = AH.GetArchiveQuestIndexes()

    if (ZO_IsElementInNumericallyIndexedTable(indexes, journalIndex)) then
        AH.FoundQuestItem = false
    end
end

local function onHotBarChange(_, changed, shouldUpdate, category)
    if (AH.IsInFilersWing) then
        if ((category == _G.HOTBAR_CATEGORY_TEMPORARY) and shouldUpdate and changed) then
            startTomeCheck()
        end

        if ((category == _G.HOTBAR_CATEGORY_PRIMARY) and changed and not shouldUpdate) then
            stopTomeCheck()
        end
    end
end

function AH.HandleDataShare(_, data)
    local foundByPlayer = AH.MaxTomes - tomesToFind
    local foundByGroupMember = AH.MaxTomes - data

    tomesToFind = AH.MaxTomes - (foundByPlayer + foundByGroupMember)

    local message = zo_strformat(_G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER, tomesToFind)

    AH.TomeCount:SetText(message)
    AH.PlayAlarm(AH.Sounds.Tomeshell)
end

function AH.SetupHooks()
    SecurePostHook(_G[AH.SELECTOR], "OnHiding", closeNotice)
    SecurePostHook(_G[AH.SELECTOR], "CommitChoice", checkCommitted)
    SecurePostHook(_G[AH.SELECTOR], "OnShowing", onShowing)
    SecurePostHook(_G[AH.SELECTOR], "SelectBuff", onSelecting)
    SecurePostHook(_G.COMPASS, "OnUpdate", checkForQuest)
    SecurePostHook(CENTER_SCREEN_ANNOUNCE, "AddMessageWithParams", onMessage)
    ZO_PreHook(_G.BOSS_BAR, "AddBoss", AH.OnNewBoss)
end

function AH.SetupEvents()
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACHIEVEMENT_UPDATED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACHIEVEMENT_AWARDED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_PLAYER_ACTIVATED, checkZone)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ENDLESS_DUNGEON_INITIALIZED, reset)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_QUEST_CONDITION_COUNTER_CHANGED, checkQuest)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_PLAYER_STUNNED_STATE_CHANGED, preZoneChange)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACTION_SLOTS_ACTIVE_HOTBAR_UPDATED, onHotBarChange)

    if (AH.Vars.FabledCheck and AH.CompatibilityCheck()) then
        EVENT_MANAGER:RegisterForEvent(AH.Name .. "_Fabled", _G.EVENT_PLAYER_COMBAT_STATE, AH.CombatCheck)
    end

end
