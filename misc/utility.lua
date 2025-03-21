local AH = _G.ArchiveHelper
local archiveQuestIndexes = {}

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

function AH.Announce(achievementName, icon, remaining)
    local message =
        ZO_CachedStrFormat(GetString(_G.ARCHIVEHELPER_PROGRESS), AH.LC.Yellow:Colorize(achievementName), remaining)

    if (AH.Vars.NotifyScreen) then
        AH.LC.ScreenAnnounce(AH.LC.Format(_G.ARCHIVEHELPER_PROGRESS_ACHIEVEMENT), message, icon)
    end

    if (AH.Vars.NotifyChat and AH.Chat) then
        AH.Chat:SetTagColor("dc143c"):Print(message)
    end
end

function AH.EventNotifier(id)
    if (AH.Vars.Notify) then
        if (AH.ACHIEVEMENTS.IDS[id]) then
            local status = AH.GetAchievementStatus(id)
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

function AH.IsInUnknown()
    local id = GetCurrentMapId()

    for _, mid in pairs(AH.MAPS) do
        if (mid.id == id) then
            return true
        end
    end

    return false
end

function AH.Release(frame)
    AH.FrameObjectPool:ReleaseObject(AH.Keys[frame])
    AH.Keys[frame] = nil
    AH[frame] = nil
end

function AH.IsAvatar(abilityId)
    for avatar, info in pairs(AH.AVATAR) do
        if (ZO_IsElementInNumericallyIndexedTable(info.abilityIds, abilityId)) then
            return avatar
        end
    end
end

function AH.GetArchiveQuestIndexes(rebuild)
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

function AH.CompatibilityCheck()
    if (_G.LFM and _G.LFM.name == "LykeionsFabledMarker") then
        return false
    end

    return true
end

function AH.CheckDataShareLib()
    if (_G.LibDataShare) then
        AH.Share = _G.LibDataShare:RegisterMap(AH.Name, AH.DATA_ID, AH.HandleDataShare)
    end
end

local solo = ENDLESS_DUNGEON_GROUP_TYPE_SOLO

function AH.GetActualGroupType()
    if (IsInstanceEndlessDungeon()) then
        local groupType = GetEndlessDungeonGroupType()
        local groupSize = GetGroupSize()

        if (groupSize == 0 or groupType == solo) then
            groupType = solo
        else
            local size = 0

            for unit = 1, groupSize do
                if (IsUnitOnline(string.format("group%d", unit))) then
                    size = size + 1
                end
            end

            if (size == 1) then
                groupType = solo
            end

            if (AH.CurrentGroupType ~= groupType) then
                AH.CurrentGroupType = groupType
            end
        end

        return groupType
    end
end

function AH.UpdateSlottedSkills()
    local skillTypes = { SKILL_TYPE_AVA, SKILL_TYPE_CLASS, SKILL_TYPE_GUILD, SKILL_TYPE_WORLD }
    local purchasedSkills = {}

    AH.SKILL_TYPES = {
        [SKILL_TYPE_AVA] = false,
        [SKILL_TYPE_CLASS] = false,
        [SKILL_TYPE_GUILD] = false,
        [SKILL_TYPE_WORLD] = false
    }

    for _, skillType in ipairs(skillTypes) do
        for line = 1, GetNumSkillLines(skillType) do
            local id = GetSkillLineId(skillType, line)

            if (id ~= AH.SUPPORT_SKILL_LINE) then
                for ability = 1, GetNumSkillAbilities(skillType, line) do
                    local _, _, _, passive, _, purchased = GetSkillAbilityInfo(skillType, line, ability)

                    if (purchased and not passive) then
                        local abilityId = GetSkillAbilityId(skillType, line, ability, false)

                        if (not purchasedSkills[skillType]) then
                            purchasedSkills[skillType] = {}
                        end

                        table.insert(purchasedSkills[skillType], abilityId)
                    end
                end
            end
        end
    end

    local slotted = {}
    local hasOakensoul =
        GetItemId(BAG_WORN, EQUIP_SLOT_RING1) == AH.OAKENSOUL or
        GetItemId(BAG_WORN, EQUIP_SLOT_RING2) == AH.OAKENSOUL

    for slotIndex = 3, 8 do
        if
            (IsSlotUsed(slotIndex, HOTBAR_CATEGORY_PRIMARY) and
                GetSlotType(slotIndex, HOTBAR_CATEGORY_PRIMARY) == ACTION_TYPE_ABILITY)
        then
            table.insert(slotted, GetSlotBoundId(slotIndex, HOTBAR_CATEGORY_PRIMARY))
        end

        if
            ((not hasOakensoul) and IsSlotUsed(slotIndex, HOTBAR_CATEGORY_BACKUP) and
                GetSlotType(slotIndex, HOTBAR_CATEGORY_BACKUP) == ACTION_TYPE_ABILITY)
        then
            table.insert(slotted, GetSlotBoundId(slotIndex, HOTBAR_CATEGORY_BACKUP))
        end
    end

    for _, skillType in ipairs(skillTypes) do
        if (purchasedSkills[skillType]) then
            for _, slottedAbilityId in ipairs(slotted) do
                if (ZO_IsElementInNumericallyIndexedTable(purchasedSkills[skillType], slottedAbilityId)) then
                    AH.SKILL_TYPES[skillType] = true
                    break
                end
            end
        end
    end

    for _, skillType in ipairs(skillTypes) do
        if (purchasedSkills[skillType]) then
            for _, slottedAbilityId in ipairs(slotted) do
                if (ZO_IsElementInNumericallyIndexedTable(purchasedSkills[skillType], slottedAbilityId)) then
                    AH.SKILL_TYPES[skillType] = true
                    break
                end
            end
        end
    end

    for _, slottedAbilityId in ipairs(slotted) do
        if (AH.PETS[slottedAbilityId]) then
            AH.SKILL_TYPES[AH.SKILL_TYPE_PET] = true
            break
        end
    end

    AH.SKILL_TYPES[AH.SKILL_TYPE_PET] = AH.SKILL_TYPES[AH.SKILL_TYPE_PET] or (GetUnitName("playerpet") ~= "")
end

local function onEffectChanged(...)
    local effectType = select(11, ...)
    local abilityId = select(16, ...)

    if (effectType ~= BUFF_EFFECT_TYPE_BUFF) then
        return
    end

    if (AH.PETS[abilityId]) then
        AH.UpdateSlottedSkills()
    end
end

function AH.EnableAutoCheck()
    EVENT_MANAGER:RegisterForEvent(AH.Name, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, AH.UpdateSlottedSkills)

    local classId = GetUnitClassId("player")

    if (classId == AH.SORCERER or classId == AH.WARDEN) then
        EVENT_MANAGER:RegisterForEvent(AH.Name .. "_pet", EVENT_EFFECT_CHANGED, onEffectChanged)
    end

    AH.Vars.AutoCheck = true
    AH.UpdateSlottedSkills()
end

function AH.DisableAutoCheck()
    EVENT_MANAGER:UnregisterForEvent(AH.Name, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED)

    local classId = GetUnitClassId("player")

    if (classId == AH.SORCERER or classId == AH.WARDEN) then
        EVENT_MANAGER:UnregisterForEvent(AH.Name .. "_pet", EVENT_EFFECT_CHANGED)
    end

    AH.Vars.AutoCheck = false
end

function AH.HasSkills(abilityId)
    if (not AH.SKILL_TYPES) then
        AH.UpdateSlottedSkills()
    end

    for skillType, ids in pairs(AH.SKILL_TYPE_BUFFS) do
        if (ZO_IsElementInNumericallyIndexedTable(ids, abilityId)) then
            return AH.SKILL_TYPES[skillType]
        end
    end

    return true
end

function AH.IsAuditorActive()
    local auditor = GetString(_G.ARCHIVEHELPER_AUDITOR_NAME)

    for pet = 1, MAX_PET_UNIT_TAGS do
        local name = AH.LC.Format(GetUnitName(string.format("playerpet%s", tostring(pet))))

        if (name and (name ~= "")) then
            if (name == auditor) then
                return true
            end
        end
    end

    return false
end

local colours = {
    [AH.TYPES.VERSE] = { normal = AH.LC.ZOSGreen, avatar = AH.LC.ZOSGold },
    [AH.TYPES.VISION] = { normal = AH.LC.ZOSBlue, avatar = AH.LC.ZOSPurple }
}

function AH.GroupChat(abilityData, name, unitTag)
    if (IsInstanceEndlessDungeon()) then
        if (AH.Vars.ShowSelection) then
            if (AH.Vars.UseDisplayName) then
                name = ZO_LinkHandler_CreateDisplayNameLink(GetUnitDisplayName(unitTag or "player"))
            else
                name = AH.LC.Format(name or GetUnitName("player"))
            end

            abilityData = tostring(abilityData)

            local replaceText = _G.ARCHIVEHELPER_BUFF_SELECTED
            local abilityId = tonumber(abilityData:sub(2, 7))
            local count = tonumber(abilityData:sub(8))
            local abilityInfo = AH.ABILITIES[abilityId]
            local abilityType = abilityInfo.type or AH.TYPES.VERSE
            local avatar = AH.IsAvatar(abilityId)
            local colourChoices = colours[abilityType]
            local colour = avatar and colourChoices.avatar or colourChoices.normal
            local channel = AH.GetActualGroupType() == solo and CHAT_CHANNEL_SAY or CHAT_CHANNEL_PARTY
            local abilityLink = GetAbilityLink(abilityId, LINK_STYLE_BRACKETS)

            if (count == 999) then
                replaceText = _G.ARCHIVEHELPER_RANDOM
            end

            local message = ZO_CachedStrFormat(replaceText, name, colour:Colorize(abilityLink))
            local yellow = AH.LC.Yellow

            if (count < 999) then
                if (avatar) then
                    if (abilityType == AH.TYPES.VISION) then
                        message = message .. " "
                        message =
                            message ..
                            yellow:Colorize("(" .. ZO_CachedStrFormat(_G.ARCHIVEHELPER_COUNT, count, 3) .. ")")
                    end
                elseif (count > 1) then
                    message = message .. " " .. yellow:Colorize("(" .. count .. ")")
                end
            end

            ZO_ChatEvent(
                EVENT_CHAT_MESSAGE_CHANNEL,
                channel,
                AH.Name,
                message,
                false,
                (not _G.pChat or not _G.pChat.db or _G.pChat.db.groupNames <= 2) and AH.Name or ""
            )
        end
    end
end

function AH.ToggleCrossingHelper()
    if (AH.CrossingHelperFrame and (not AH.CrossingHelperFrame:IsHidden())) then
        AH.HideCrossingHelper()

        return
    end

    if (not AH.IsInCrossing and not AH.DEBUG) then
        local message = GetString(_G.ARCHIVEHELPER_CROSSING_INVALID)

        if (AH.Chat) then
            AH.Chat:SetTagColor(AH.LC.ZOSPurple)
            AH.Chat:Print(message)
        end

        return
    end

    if ((AH.CrossingHelperFrame and AH.CrossingHelperFrame:IsHidden()) or not AH.CrossingHelperFrame) then
        AH.ShowCrossingHelper(AH.DEBUG)
    end
end

-- update 45 has removed this function for some reason
function AH.GetAchievementStatus(achievementId)
    local completed = 0
    local total = 0
    local numCriteria = GetAchievementNumCriteria(achievementId)

    for criterionIndex = 1, numCriteria do
        local _, numCompleted, numRequired = GetAchievementCriterion(achievementId, criterionIndex)

        completed = completed + numCompleted
        total = total + numRequired
    end

    if total > 0 then
        if completed > 0 then
            if completed == total then
                return ZO_ACHIEVEMENTS_COMPLETION_STATUS.COMPLETE
            else
                return ZO_ACHIEVEMENTS_COMPLETION_STATUS.IN_PROGRESS
            end
        else
            return ZO_ACHIEVEMENTS_COMPLETION_STATUS.INCOMPLETE
        end
    end

    return ZO_ACHIEVEMENTS_COMPLETION_STATUS.NOT_APPLICABLE
end

function AH.Debug(message)
    if (AH.DEBUG) then
        AH.Chat:SetTagColor(AH.LC.ZOSPurple)
        AH.Chat:Print(message)
    end
end
