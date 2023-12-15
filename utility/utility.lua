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

function AH.GetAchievementsList()
    local list = {}

    for _, achievementIds in pairs(AH.ABILITIES) do
        for _, achievementId in ipairs(achievementIds) do
            if (not ZO_IsElementInNumericallyIndexedTable(list, achievementId)) then
                table.insert(list, achievementId)
            end
        end
    end

    return list
end

function AH.IsRecorded(abilityId, abilities)
    for _, abilityInfo in ipairs(abilities) do
        if (abilityInfo.id == abilityId) then
            return true
        end
    end

    return false
end

function AH.GetAbilities(achievementIdToFind)
    local abilities = {}

    for abilityId, achievementIds in pairs(AH.ABILITIES) do
        if (ZO_IsElementInNumericallyIndexedTable(achievementIds, achievementIdToFind)) then
            if (not AH.IsRecorded(abilityId, abilities)) then
                local name
                if (AH.EXCEPTIONS[abilityId]) then
                    name = GetString(AH.EXCEPTIONS[abilityId])
                else
                    name = GetAbilityName(abilityId)
                end

                table.insert(abilities, {id = abilityId, name = AH.Format(name)})
            end
        end
    end

    return abilities
end

function AH.CheckAbilities(text, abilities)
    for _, ability in ipairs(abilities) do
        if (text:find(ability.name)) then
            return ability.id
        end
    end

    return 0
end

AH.IncompleteAchievements = {}

function AH.FindMissingAbilityIds(event, id)
    if (event == _G.EVENT_ACHIEVEMENT_UPDATED) then
        if (ZO_IsElementInNumericallyIndexedTable(AH.ACHIEVEMENTS.EXCLUDE, id)) then
        --return
        end

        AH.EventNotifier(id)
    end

    local achievementIds = AH.GetAchievementsList()
    local incomplete = {}

    ZO_ClearNumericallyIndexedTable(AH.MissingAbilities)

    for _, achievementId in ipairs(achievementIds) do
        local status = ACHIEVEMENTS_MANAGER:GetAchievementStatus(achievementId)

        if (status ~= _G.ZO_ACHIEVEMENTS_COMPLETION_STATUS.COMPLETE) then
            table.insert(incomplete, achievementId)
        end
    end

    if (#incomplete == 0) then
        AH.IncompleteAchievements = {}

        return
    end

    for _, achievementId in ipairs(incomplete) do
        local abilities = AH.GetAbilities(achievementId)
        local numCriteria = GetAchievementNumCriteria(achievementId)

        for criterionNumber = 1, numCriteria do
            local description, completed, required = GetAchievementCriterion(achievementId, criterionNumber)

            if (completed ~= required) then
                local aid = AH.CheckAbilities(description, abilities)

                if (not AH.IsRecorded(aid, AH.MissingAbilities)) then
                    table.insert(AH.MissingAbilities, {id = id, achievementId = achievementId})
                end
            end
        end
    end

    AH.IncompleteAchievements = incomplete
end

function AH.GetRecord(id, table)
    for _, record in ipairs(table) do
        if (record.id == id) then
            return record
        end
    end
end

function AH.GetAbilityNeededForGeneralAchievement(abilityId)
    local achievements = AH.ABILITIES[abilityId]
    local neededFor = {}

    for _, achievementId in ipairs(achievements) do
        if (ZO_IsElementInNumericallyIndexedTable(AH.GENERAL, achievementId)) then
            local status = ACHIEVEMENTS_MANAGER:GetAchievementStatus(achievementId)

            if (status ~= _G.ZO_ACHIEVEMENTS_COMPLETION_STATUS.COMPLETE) then
                table.insert(neededFor, achievementId)
            end
        end
    end

    return neededFor
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
