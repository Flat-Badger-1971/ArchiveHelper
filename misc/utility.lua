local AH = _G.ArchiveHelper
local archiveQuestIndexes = {}

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
        if (AH.ACHIEVEMENTS.IDS[id]) then
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

local solo = _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO

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
    local skillTypes = {_G.SKILL_TYPE_AVA, _G.SKILL_TYPE_CLASS, _G.SKILL_TYPE_GUILD, _G.SKILL_TYPE_WORLD}
    local purchasedSkills = {}

    AH.SKILL_TYPES = {
        [_G.SKILL_TYPE_AVA] = false,
        [_G.SKILL_TYPE_CLASS] = false,
        [_G.SKILL_TYPE_GUILD] = false,
        [_G.SKILL_TYPE_WORLD] = false
    }

    for _, skillType in ipairs(skillTypes) do
        for line = 1, GetNumSkillLines(skillType) do
            local id = GetSkillLineId(skillType, line)

            if (id ~= AH.SUPPORT_SKILL_LINE) then
                for ability = 1, GetNumSkillAbilities(skillType, line) do
                    local _, _, _, passive, _, purchased = GetSkillAbilityInfo(skillType, line, ability)

                    if (purchased and not passive) then
                        local abilityId = GetSkillAbilityId(skillType, line, ability)

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
        GetItemId(_G.BAG_WORN, _G.EQUIP_SLOT_RING1) == AH.OAKENSOUL or
        GetItemId(_G.BAG_WORN, _G.EQUIP_SLOT_RING2) == AH.OAKENSOUL

    for slotIndex = 3, 8 do
        if
            (IsSlotUsed(slotIndex, _G.HOTBAR_CATEGORY_PRIMARY) and
                GetSlotType(slotIndex, _G.HOTBAR_CATEGORY_PRIMARY) == _G.ACTION_TYPE_ABILITY)
         then
            table.insert(slotted, GetSlotBoundId(slotIndex, _G.HOTBAR_CATEGORY_PRIMARY))
        end

        if
            ((not hasOakensoul) and IsSlotUsed(slotIndex, _G.HOTBAR_CATEGORY_BACKUP) and
                GetSlotType(slotIndex, _G.HOTBAR_CATEGORY_BACKUP) == _G.ACTION_TYPE_ABILITY)
         then
            table.insert(slotted, GetSlotBoundId(slotIndex, _G.HOTBAR_CATEGORY_BACKUP))
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

    if (effectType ~= _G.BUFF_EFFECT_TYPE_BUFF) then
        return
    end

    if (AH.PETS[abilityId]) then
        AH.UpdateSlottedSkills()
    end
end

function AH.EnableAutoCheck()
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, AH.UpdateSlottedSkills)

    local classId = GetUnitClassId("player")

    if (classId == AH.SORCERER or classId == AH.WARDEN) then
        EVENT_MANAGER:RegisterForEvent(AH.Name .. "_pet", _G.EVENT_EFFECT_CHANGED, onEffectChanged)
    end

    AH.Vars.AutoCheck = true
    AH.UpdateSlottedSkills()
end

function AH.DisableAutoCheck()
    EVENT_MANAGER:UnregisterForEvent(AH.Name, _G.EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED)

    local classId = GetUnitClassId("player")

    if (classId == AH.SORCERER or classId == AH.WARDEN) then
        EVENT_MANAGER:UnregisterForEvent(AH.Name .. "_pet", _G.EVENT_EFFECT_CHANGED)
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

local colours = {
    [AH.TYPES.VERSE] = {normal = AH.COLOURS.GREEN, avatar = AH.COLOURS.GOLD},
    [AH.TYPES.VISION] = {normal = AH.COLOURS.BLUE, avatar = AH.COLOURS.PURPLE}
}

function AH.GroupChat(abilityData, name)
    if (AH.Vars.ShowSelection) then
        name = name or GetUnitName("player")
        abilityData = tostring(abilityData)

        local abilityId = tonumber(abilityData:sub(2, 7))
        local count = tonumber(abilityData:sub(8))
        local buff = AH.Format(GetAbilityName(abilityId))
        local abilityInfo = AH.ABILITIES[abilityId]
        local abilityType = abilityInfo.type or AH.TYPES.VERSE
        local avatar = AH.IsAvatar(abilityId)
        local colourChoices = colours[abilityType]
        local colour = avatar and colourChoices.avatar or colourChoices.normal
        local channel = AH.GetActualGroupType() == solo and _G.CHAT_CHANNEL_SAY or _G.CHAT_CHANNEL_PARTY
        local message = zo_strformat(_G.ARCHIVEHELPER_BUFF_SELECTED, AH.Format(name), "|c" .. colour .. buff .. "|r")

        if (avatar and (abilityType == AH.TYPES.VISION)) then
            message = message .. " |cffff00(" .. zo_strformat(_G.ARCHIVEHELPER_COUNT, count, 3) .. ")|r"
        elseif (count > 1) then
            message = message .. " |cffff00(" .. count .. ")|r"
        end

        CHAT_ROUTER:FormatAndAddChatMessage(_G.EVENT_CHAT_MESSAGE_CHANNEL, channel, AH.Name, message, false, AH.Name)
    end
end

-- regex for crossing - (\d[LR]?)
