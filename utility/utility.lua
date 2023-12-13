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

function AH.GetAbilities(achievementIdToFind)
    local abilities = {}

    for abilityId, achievementIds in pairs(AH.ABILITIES) do
        if (ZO_IsElementInNumericallyIndexedTable(achievementIds, achievementIdToFind)) then
            if (not ZO_IsElementInNumericallyIndexedTable(abilities, abilityId)) then
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

                if (not ZO_IsElementInNumericallyIndexedTable(AH.MissingAbilities, id)) then
                    table.insert(AH.MissingAbilities, id)
                end
            end
        end
    end

    AH.IncompleteAchievements = incomplete
end

function AH.GetAbilityNeededForAchievement(abilityId)
    local achievements = AH.ABILITIES[abilityId]
    local neededFor = {}

    for _, achievementId in ipairs(achievements) do
        if (ZO_IsElementInNumericallyIndexedTable(AH.IncompleteAchievements, achievementId)) then
            table.insert(neededFor, achievementId)
        end
    end

    return neededFor
end