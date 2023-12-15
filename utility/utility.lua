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

function AH.FindMissingAbilityIds()
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
                local id = AH.CheckAbilities(description, abilities)

                if (not AH.IsRecorded(id, AH.MissingAbilities)) then
                    table.insert(AH.MissingAbilities, {id = id, achievementId = achievementId})
                    d(GetAbilityName(id))
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
