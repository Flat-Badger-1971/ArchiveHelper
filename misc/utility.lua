local AH = _G.ArchiveHelper

AH.MissingAbilities = {}

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

    messageParams:SetSound(sound or "Justice_NowKOS")
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

function AH.CheckZone()
    ZO_ClearNumericallyIndexedTable(bosses)

    if (AH.Vars.ShowTimer) then
        zoneCheck()
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
end

local function closeNotice()
    if (AH.Notice) then
        AH.Notice:SetHidden(true)
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
    if (AH.Vars.ShowTimer) then
        checkMessage(messageParams)
    end
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
        AH.ScreenAnnounce(
            AH.Format(_G.ARCHIVEHELPER_MARAUDER),
            "|cff0000" .. 
            zo_strformat(_G.ARCHIVEHELPER_MARAUDER_INCOMING, bossName) .. "|r",
            nil,
            nil,
            _G.SOUNDS.DUEL_START
        )
    end
end

function AH.SetupHooks()
    SecurePostHook(_G[AH.SELECTOR], "OnHiding", closeNotice)
    SecurePostHook(_G[AH.SELECTOR], "CommitChoice", checkCommitted)
    SecurePostHook(_G[AH.SELECTOR], "OnShowing", onShowing)
    SecurePostHook(_G[AH.SELECTOR], "SelectBuff", onSelecting)
    SecurePostHook(CENTER_SCREEN_ANNOUNCE, "DisplayMessage", onMessage)
    SecurePostHook(_G.BOSS_BAR, "AddBoss", onNewBoss)
end
