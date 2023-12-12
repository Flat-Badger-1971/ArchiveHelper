local EAVV = _G.EndlessArchiveVersesAndVisions
local iconTypes = {"ACH", "FAV", "ICE", "IRON", "WOLF"}

local function createIcon(icon, index, parent, xOffset, yOffset)
    local name = string.format("EAVV_ICON_%s_%d", icon, index)
    local control = WINDOW_MANAGER:CreateControl(name, parent, CT_CONTROL)

    control:SetDrawTier(_G.DT_HIGH)
    control:SetAnchor(TOPLEFT, parent, TOPLEFT, xOffset or 0, yOffset or 0)
    control:SetDimensions(64, 64)

    local texture = WINDOW_MANAGER:CreateControl(nil, control, CT_TEXTURE)
    local iconInfo = EAVV.ICONS[icon]

    texture:SetAnchorFill(control)
    texture:SetTexture(string.format("/esoui/art/%s.dds", iconInfo.name))
    texture:SetColor(unpack(iconInfo.colour))

    control:SetMouseEnabled(true)
    control:SetHandler(
        "OnMouseEnter",
        function()
            if (control.tooltip) then
                if (not IsInGamepadPreferredMode()) then
                    ZO_Tooltips_ShowTextTooltip(control, TOPLEFT, control.tooltip)
                end
            end
        end
    )

    control:SetHandler(
        "OnMouseExit",
        function()
            ZO_Tooltips_HideTextTooltip()
        end
    )

    return control
end

local function OnBuffSelectorShowing()
    local numChoices = 0
    local buffChoices = {}

    -- setup icons

    local container = EAVV.SELECTOR_SHORT .. "Container"
    local containerWidth = _G[container .. "Buff1"]:GetWidth()
    local xOffset = (containerWidth / 2) - 32
    local xEnd = containerWidth - 32
    local offsets = {
        ACH = {x = 0, y = 0},
        FAV = {x = xOffset, y = 0},
        ICE = {x = xEnd, y = 0},
        IRON = {x = xEnd, y = 0},
        WOLF = {x = xEnd, y = 0}
    }

    for _, iconType in ipairs(iconTypes) do
        local name = string.format("%s_ICONS", iconType)

        if (EAVV[name]) then
            ZO_ClearNumericallyIndexedTable(EAVV[name])
        else
            EAVV[name] = {}
        end

        local iconArray = EAVV[string.format("%s_ICONS", iconType)]

        iconArray[1] = createIcon(iconType, 1, _G[container .. "Buff1"], offsets[iconType].x, offsets[iconType].y)
        iconArray[2] = createIcon(iconType, 2, _G[container .. "Buff2"], offsets[iconType].x, offsets[iconType].y)
        iconArray[3] = createIcon(iconType, 3, _G[container .. "Buff3"], offsets[iconType].x, offsets[iconType].y)
    end

    for _, iconType in ipairs(iconTypes) do
        for icon = 1, 3 do
            EAVV[string.format("%s_ICONS", iconType)][icon]:SetHidden(true)
            EAVV[string.format("%s_ICONS", iconType)][icon].tooltip = nil
        end
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
                index = numChoices,
                name = EAVV.Format(GetAbilityName(abilityId))
            }
        end
    end

    if (EAVV.Vars.MarkAchievements) then
        for _, buffInfo in pairs(buffChoices) do
            if (ZO_IsElementInNumericallyIndexedTable(EAVV.MissingAbilities, buffInfo.abilityId)) then
                local achievementIds = EAVV.ABILITIES[buffInfo.abilityId]

                EAVV.ACH_ICONS[buffInfo.index]:SetHidden(false)

                local ttt = ""

                for _, achievementId in pairs(achievementIds) do
                    local name = GetAchievementName(achievementId)
                    ttt = ttt .. name .. EAVV.LF
                end

                EAVV.ACH_ICONS[buffInfo.index].tooltip = ttt
            end
        end
    end

    if (EAVV.Vars.MarkFavourites) then
        for _, buffInfo in pairs(buffChoices) do
            if (ZO_IsElementInNumericallyIndexedTable(EAVV.Vars.Favourites, buffInfo.abilityId)) then
                EAVV.FAV_ICONS[buffInfo.index]:SetHidden(false)
            end
        end
    end

    if (EAVV.Vars.MarkAvatar) then
        for _, buffInfo in pairs(buffChoices) do
            local icon

            if (ZO_IsElementInNumericallyIndexedTable(EAVV.AVATAR.ICE, buffInfo.abilityId)) then
                icon = EAVV.ICE_ICONS[buffInfo.index]
            elseif (ZO_IsElementInNumericallyIndexedTable(EAVV.AVATAR.WOLF, buffInfo.abilityId)) then
                icon = EAVV.WOLF_ICONS[buffInfo.index]
            elseif (ZO_IsElementInNumericallyIndexedTable(EAVV.AVATAR.IRON, buffInfo.abilityId)) then
                icon = EAVV.IRON_ICONS[buffInfo.index]
            end

            if (icon) then
                local achievementIds = EAVV.ABILITIES[buffInfo.abilityId]

                icon:SetHidden(false)
                local ttt = ""

                for _, achievementId in pairs(achievementIds) do
                    local name = GetAchievementName(achievementId)
                    ttt = ttt .. name .. EAVV.LF
                end

                icon.tooltip = ttt
            end
        end
    end
end

local function getAchievementsList()
    local list = {}

    for _, achievementIds in pairs(EAVV.ABILITIES) do
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

    for abilityId, achievementIds in pairs(EAVV.ABILITIES) do
        if (ZO_IsElementInNumericallyIndexedTable(achievementIds, achievementIdToFind)) then
            if (not ZO_IsElementInNumericallyIndexedTable(abilities, abilityId)) then
                local name
                if (EAVV.EXCEPTIONS[abilityId]) then
                    name = GetString(EAVV.EXCEPTIONS[abilityId])
                else
                    name = GetAbilityName(abilityId)
                end

                table.insert(abilities, {id = abilityId, name = EAVV.Format(name)})
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

EAVV.MissingAbilities = {}

local function findMissingAbilityIds()
    local achievementIds = getAchievementsList()
    local incomplete = {}

    ZO_ClearNumericallyIndexedTable(EAVV.MissingAbilities)

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
                if (not ZO_IsElementInNumericallyIndexedTable(EAVV.MissingAbilities, id)) then
                    table.insert(EAVV.MissingAbilities, id)
                end
            end
        end
    end
end

local function Initialise()
    -- saved variables
    EAVV.Vars =
        _G.LibSavedVars:NewAccountWide("EndlessArchiveVersesAndVisionsSavedVars", "Account", EAVV.Defaults):AddCharacterSettingsToggle(
        "EndlessArchiveVersesAndVisionsSavedVars",
        "Characters"
    ):EnableDefaultsTrimming()

    EAVV.RegisterSettings()

    local selector_short = "ZO_EndDunBuffSelector_%s"
    local selector = "ZO_EndlessDungeonBuffSelector_%s"

    if (IsInGamepadPreferredMode()) then
        EAVV.SELECTOR_SHORT = string.format(selector_short, "Gamepad")
        EAVV.SELECTOR = string.format(selector, "Gamepad")
    else
        EAVV.SELECTOR_SHORT = string.format(selector_short, "Keyboard")
        EAVV.SELECTOR = string.format(selector, "Keyboard")
    end

    SecurePostHook(_G[EAVV.SELECTOR], "OnShowing", OnBuffSelectorShowing)
    findMissingAbilityIds()

    EVENT_MANAGER:RegisterForEvent(EAVV.Name, _G.EVENT_ACHIEVEMENTS_UPDATED, findMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(EAVV.Name, _G.EVENT_ACHIEVEMENT_AWARDED, findMissingAbilityIds)
end

function EAVV.OnAddonLoaded(_, addonName)
    if (addonName ~= EAVV.Name) then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(EAVV.Name, _G.EVENT_ADD_ON_LOADED)

    Initialise()
end

EVENT_MANAGER:RegisterForEvent(EAVV.Name, _G.EVENT_ADD_ON_LOADED, EAVV.OnAddonLoaded)
