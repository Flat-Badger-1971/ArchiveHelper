local EABA = _G.EndlessArchiveBuffAssistant

EABA.Name = "EndlessArchiveBuffAssistant"

local function createIcon(parent, index)
    local tmpControl = WINDOW_MANAGER:CreateControl("EABA_ICON_" .. index, parent, CT_CONTROL)
    tmpControl:SetDrawTier(_G.DT_HIGH)
    tmpControl:SetAnchor(TOPLEFT, parent, TOPLEFT)
    tmpControl:SetDimensions(64, 64)

    local texture = WINDOW_MANAGER:CreateControl(nil, tmpControl, CT_TEXTURE)

    texture:SetAnchorFill(tmpControl)
    texture:SetTexture("/esoui/art/login/login_icon_yield.dds")
    texture:SetColor(1, 0, 0, 1)
    --TODO: add tooltip

    return tmpControl
end

local function OnBuffSelectorShowing()
    local numChoices = 0
    local container = EABA.SELECTOR_SHORT .. "Container"
    local buffChoices = {}
    local icons = {
        [1] = _G.EABA_ICON_1 or createIcon(_G[container .. "Buff1"], 1),
        [2] = _G.EABA_ICON_2 or createIcon(_G[container .. "Buff2"], 2),
        [3] = _G.EABA_ICON_3 or createIcon(_G[container .. "Buff3"], 3)
    }

    for icon = 1, 3 do
        icons[icon]:SetHidden(true)
    end

    for bucketType = _G.ENDLESS_DUNGEON_BUFF_BUCKET_TYPE_ITERATION_BEGIN, _G.ENDLESS_DUNGEON_BUFF_BUCKET_TYPE_ITERATION_END do
        local abilityId = GetEndlessDungeonBuffSelectorBucketTypeChoice(bucketType)

        if abilityId > 0 then
            numChoices = numChoices + 1

            local buffType, isAvatarVision = GetAbilityEndlessDungeonBuffType(abilityId)
            buffChoices[numChoices] = {
                abilityId = abilityId,
                buffType = buffType,
                isAvatarVision = isAvatarVision,
                index = numChoices
            }
        end
    end

    for _, buffInfo in pairs(buffChoices) do
        if (ZO_IsElementInNumericallyIndexedTable(EABA.MissingAbilities, buffInfo.abilityId)) then
            local achievementIds = EABA.ABILTIES[buffInfo.abilityId]

            icons[buffInfo.index]:SetHidden(false)

            for _, achievementId in pairs(achievementIds) do
                local name = GetAchievementName(achievementId)
                --TODO: populate tooltip
                d(name)
            end
        end
    end
end

local function getAchievementsList()
    local list = {}

    for _, achievementIds in pairs(EABA.ABILITIES) do
        for _, achievementId in ipairs(achievementIds) do
            if (not ZO_IsElementInNumericallyIndexedTable(list, achievementId)) then
                table.insert(list, achievementId)
            end
        end
    end

    return list
end

local function getAbilities(achievementIdToFind)
    local abilities = {}

    for abilityId, achievementIds in pairs(EABA.ABILITIES) do
        if (ZO_IsElementInNumericallyIndexedTable(achievementIds, achievementIdToFind)) then
            if (not ZO_IsElementInNumericallyIndexedTable(abilities, abilityId)) then
                local name
                if (EABA.EXCEPTIONS[abilityId]) then
                    name = GetString(EABA.EXCEPTIONS[abilityId])
                else
                    name = GetAbilityName(abilityId)
                end

                table.insert(abilities, {id = abilityId, name = ZO_CachedStrFormat("<<C:1>>", name)})
            end
        end
    end

    return abilities
end

local function checkAbilities(text, abilities)
    for _, ability in pairs(abilities) do
        if (text:find(ability.name)) then
            return ability.id
        end
    end
end

EABA.MissingAbilities = {}

local function findMissingAbilityIds()
    local achievementIds = getAchievementsList()
    local incomplete = {}

    ZO_ClearNumericallyIndexedTable(EABA.MissingAbilities)

    for _, achievementId in ipairs(achievementIds) do
        local status = ACHIEVEMENTS_MANAGER:GetAchievementStatus(achievementId)

        if (status ~= _G.ZO_ACHIEVEMENTS_COMPLETION_STATUS.COMPLETE) then
            table.insert(incomplete, achievementId)
        end
    end

    if (#incomplete == 0) then
        return {}
    end

    for _, achievementId in ipairs(incomplete) do
        local abilities = getAbilities(achievementId)
        local numCriteria = GetAchievementNumCriteria(achievementId)

        for criterionNumber = 1, numCriteria do
            local description, completed, required = GetAchievementCriterion(achievementId, criterionNumber)

            if (completed ~= required) then
                local id = checkAbilities(description, abilities)
                if (not ZO_IsElementInNumericallyIndexedTable(EABA.MissingAbilities, id)) then
                    table.insert(EABA.MissingAbilities, id)
                end
            end
        end
    end
end

local function Initialise()
    -- saved variables
    EABA.Vars =
        _G.LibSavedVars:NewAccountWide("EndlessArchiveBuffAssistantSavedVars", "Account", EABA.Defaults):AddCharacterSettingsToggle(
        "EndlessArchiveBuffAssistantSavedVars",
        "Characters"
    )

    local selector_short = "ZO_EndDunBuffSelector_<<1>>"
    local selector = "ZO_EndlessDungeonBuffSelector_<<1>>"

    if (IsInGamepadPreferredMode()) then
        EABA.SELECTOR_SHORT = zo_strformat(selector_short, "Gamepad")
        EABA.SELECTOR = zo_strformat(selector, "Gamepad")
    else
        EABA.SELECTOR_SHORT = zo_strformat(selector_short, "Keyboard")
        EABA.SELECTOR = zo_strformat(selector, "Keyboard")
    end

    SecurePostHook(_G[EABA.SELECTOR], "OnShowing", OnBuffSelectorShowing)

    findMissingAbilityIds()

    EVENT_MANAGER:RegisterForEvent(EABA.Name, _G.EVENT_ACHIEVEMENTS_UPDATED, findMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(EABA.Name, _G.EVENT_ACHIEVEMENT_AWARDED, findMissingAbilityIds)

    --    EABA.RegisterSettings()
end

function EABA.OnAddonLoaded(_, addonName)
    if (addonName ~= EABA.Name) then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(EABA.Name, _G.EVENT_ADD_ON_LOADED)

    Initialise()
end

EVENT_MANAGER:RegisterForEvent(EABA.Name, _G.EVENT_ADD_ON_LOADED, EABA.OnAddonLoaded)
