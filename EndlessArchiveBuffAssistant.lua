local EABA = _G.EndlessArchiveBuffAssistant
EABA.Name = "EndlessArchiveBuffAssistant"

local function OnPlayerActivated()
end

local function OnAchievementUpdated(_, achievementId)
end

local function OnBuffSelectorShowing()
    local numChoices = 0
    local container = EABA.SELECTOR_SHORT .. "Container"
    local buffChoices = {}

    for bucketType = _G.ENDLESS_DUNGEON_BUFF_BUCKET_TYPE_ITERATION_BEGIN, _G.ENDLESS_DUNGEON_BUFF_BUCKET_TYPE_ITERATION_END do
        local abilityId = GetEndlessDungeonBuffSelectorBucketTypeChoice(bucketType)

        if abilityId > 0 then
            numChoices = numChoices + 1

            local buffType, isAvatarVision = GetAbilityEndlessDungeonBuffType(abilityId)
            buffChoices[numChoices] = {
                abilityId = abilityId,
                --abilityName = GetAbilityName(abilityId),
                buffType = buffType,
                --iconTexture = GetAbilityIcon(abilityId),
                --instanceIntervalOffset = numChoices,
                isAvatarVision = isAvatarVision
                --stackCount = 1
            }

        --d(Container)
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

local function findAchievements()
    local achievementIds = getAchievementsList()
    local incomplete = {}

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
        local numCriteria = GetAchievementNumCriteria(achievementId)

        for criterionNumber = 1, numCriteria do
            local description, completed, required = GetAchievementCriterion(achievementId, criterionNumber)

            if (completed ~= required) then
                d(description).
            end
        end
    end
end

local function Initialise()
    if (_G.LibDebugLogger ~= nil) then
        EABA.Logger = _G.LibDebugLogger(EABA.Name)
    end

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

    findAchievements()
    -- EVENT_MANAGER:RegisterForEvent(EABA.Name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    -- EVENT_MANAGER:RegisterForEvent(EABA.Name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnSlotUpdated)
    -- EVENT_MANAGER:RegisterForEvent(EABA.Name, EVENT_ACTION_LAYER_POPPED, OnActionLayerChanged)
    -- EVENT_MANAGER:RegisterForEvent(EABA.Name, EVENT_ACTION_LAYER_PUSHED, OnActionLayerChanged)
    -- EVENT_MANAGER:RegisterForEvent(EABA.Name, EVENT_NON_COMBAT_BONUS_CHANGED, OnBonusChanged)
    -- EVENT_MANAGER:RegisterForEvent(EABA.Name, EVENT_ACHIEVEMENT_UPDATED, OnAchievementUpdated)

    --    EABA.RegisterSettings()
end

function EABA.Log(message, severity)
    if (EABA.Logger) then
        if (severity == "info") then
            EABA.Logger:Info(message)
        elseif (severity == "warn") then
            EABA.Logger:Warn(message)
        elseif (severity == "debug") then
            EABA.Logger:Debug(message)
        end
    end
end

function EABA.OnAddonLoaded(_, addonName)
    if (addonName ~= EABA.Name) then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(EABA.Name, _G.EVENT_ADD_ON_LOADED)

    Initialise()
end

EVENT_MANAGER:RegisterForEvent(EABA.Name, _G.EVENT_ADD_ON_LOADED, EABA.OnAddonLoaded)
