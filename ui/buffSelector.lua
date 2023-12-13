local AH = _G.ArchiveHelper

function AH.OnBuffSelectorShowing()
    local numChoices = 0
    local buffChoices = {}

    local container = AH.SELECTOR_SHORT .. "Container"
    local offsets = {
        ACH = {x = 0, y = -36},
        FAV = {x = 80, y = -36},
        ICE = {x = 160, y = -36},
        IRON = {x = 160, y = -36},
        WOLF = {x = 160, y = -36}
    }

    -- reset the object pool
    AH.EnsurePoolExists()
    AH.ObjectPool:ReleaseAllObjects()

    -- create the required icons
    for iconType, settingsName in pairs(AH.IconTypes) do
        if (AH.Vars[settingsName]) then
            local name = string.format("%s_ICONS", iconType)

            if (AH[name]) then
                ZO_ClearNumericallyIndexedTable(AH[name])
            else
                AH[name] = {}
            end

            local iconArray = AH[string.format("%s_ICONS", iconType)]

            iconArray[1] = AH.CreateIcon(iconType, _G[container .. "Buff1"], offsets[iconType].x, offsets[iconType].y)
            iconArray[2] = AH.CreateIcon(iconType, _G[container .. "Buff2"], offsets[iconType].x, offsets[iconType].y)

            if (_G[container .. "Buff2"]) then
                iconArray[3] =
                    AH.CreateIcon(iconType, _G[container .. "Buff3"], offsets[iconType].x, offsets[iconType].y)
            end
        end
    end

    for iconType, settingsName in ipairs(AH.IconTypes) do
        if (AH.Vars[settingsName]) then
            for icon = 1, 3 do
                AH[string.format("%s_ICONS", iconType)][icon]:SetHidden(true)
                AH[string.format("%s_ICONS", iconType)][icon]:SetTooltip(nil)
            end
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
                name = AH.Format(GetAbilityName(abilityId))
            }
        end
    end

    if (AH.Vars.MarkAchievements) then
        for _, buffInfo in pairs(buffChoices) do
            if (ZO_IsElementInNumericallyIndexedTable(AH.MissingAbilities, buffInfo.abilityId)) then
                local achievementIds = AH.ABILITIES[buffInfo.abilityId]

                AH.ACH_ICONS[buffInfo.index]:SetHidden(false)

                local ttt = ""

                for _, achievementId in pairs(achievementIds) do
                    local name = GetAchievementName(achievementId)
                    ttt = ttt .. name .. AH.LF
                end

                AH.ACH_ICONS[buffInfo.index]:SetTooltip(ttt)
            end
        end
    end

    if (AH.Vars.MarkFavourites) then
        for _, buffInfo in pairs(buffChoices) do
            if (ZO_IsElementInNumericallyIndexedTable(AH.Vars.Favourites, buffInfo.abilityId)) then
                AH.FAV_ICONS[buffInfo.index]:SetHidden(false)
            end
        end
    end

    if (AH.Vars.MarkAvatar) then
        for _, buffInfo in pairs(buffChoices) do
            local icon

            if (ZO_IsElementInNumericallyIndexedTable(AH.AVATAR.ICE, buffInfo.abilityId)) then
                icon = AH.ICE_ICONS[buffInfo.index]
            elseif (ZO_IsElementInNumericallyIndexedTable(AH.AVATAR.WOLF, buffInfo.abilityId)) then
                icon = AH.WOLF_ICONS[buffInfo.index]
            elseif (ZO_IsElementInNumericallyIndexedTable(AH.AVATAR.IRON, buffInfo.abilityId)) then
                icon = AH.IRON_ICONS[buffInfo.index]
            end

            if (icon) then
                local achievementIds = AH.ABILITIES[buffInfo.abilityId]

                icon:SetHidden(false)
                local ttt = ""

                for _, achievementId in pairs(achievementIds) do
                    local name = GetAchievementName(achievementId)
                    ttt = ttt .. name .. AH.LF
                end

                icon:SetTooltip(ttt)
            end
        end
    end
end
