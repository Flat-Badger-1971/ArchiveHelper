local AH = _G.ArchiveHelper

local positions = {[1] = {}, [2] = {}, [3] = {}}

local function getNextPosition(buffIndex)
    if (ZO_IsElementInNumericallyIndexedTable(positions[buffIndex], 1)) then
        table.insert(positions[buffIndex], 2)
        return 2
    end

    if (ZO_IsElementInNumericallyIndexedTable(positions[buffIndex], 2)) then
        table.insert(positions[buffIndex], 3)
        return 3
    end

    table.insert(positions[buffIndex], 1)
    return 1
end

local function clearPositions()
    for index = 1, 3 do
        ZO_ClearNumericallyIndexedTable(positions[index])
    end
end

function AH.OnBuffSelectorShowing()
    local numChoices = 0
    local buffChoices = {}
    local container = AH.SELECTOR_SHORT .. "Container"
    local positionOffsets = {
        [1] = {x = 84, y = -36},
        [2] = {x = 0, y = -36},
        [3] = {x = 164, y = -36}
    }

    clearPositions()

    -- reset the object pool
    AH.EnsurePoolExists()
    AH.ObjectPool:ReleaseAllObjects()

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

    -- show achievement icons
    if (AH.Vars.MarkAchievements) then
        for _, buffInfo in pairs(buffChoices) do
            local generalIds = AH.GetAbilityNeededForGeneralAchievement(buffInfo.abilityId)
            local record = AH.GetRecord(buffInfo.abilityId, AH.MissingAbilities)

            if (record or (#generalIds > 0)) then
                local position = positionOffsets[getNextPosition(buffInfo.index)]
                local buff = _G[string.format("%sBuff%d", container, buffInfo.index)]
                local icon = AH.CreateIcon("ACH", buff, position.x, position.y)

                local ttt = " "

                if (record) then
                    local achName = GetAchievementName(record.achievementId)

                    ttt = ttt .. achName .. AH.LF
                end

                if (#generalIds > 0) then
                    for _, achievementId in ipairs(generalIds) do
                        local name = GetAchievementName(achievementId)

                        ttt = ttt .. name .. AH.LF
                    end
                end

                -- remove the trailing line feed
                ttt = ttt:sub(1, #ttt - 1)

                icon:SetTooltip(ttt)
                icon:SetHidden(false)
            end
        end
    end

    -- show favourites icons
    if (AH.Vars.MarkFavourites and #AH.Vars.Favourites > 0) then
        for _, buffInfo in pairs(buffChoices) do
            if (ZO_IsElementInNumericallyIndexedTable(AH.Vars.Favourites, buffInfo.abilityId)) then
                local position = positionOffsets[getNextPosition(buffInfo.index)]
                local buff = _G[string.format("%sBuff%d", container, buffInfo.index)]
                local icon = AH.CreateIcon("FAV", buff, position.x, position.y)

                icon:SetHidden(false)
            end
        end
    end

    -- show avatar icons
    if (AH.Vars.MarkAvatar) then
        for _, buffInfo in pairs(buffChoices) do
            local position = positionOffsets[getNextPosition(buffInfo.index)]
            local buff = _G[string.format("%sBuff%d", container, buffInfo.index)]
            local icon, achievementId

            if (ZO_IsElementInNumericallyIndexedTable(AH.AVATAR.ICE.abilityIds, buffInfo.abilityId)) then
                icon = AH.CreateIcon("ICE", buff, position.x, position.y)
                achievementId = AH.AVATAR.ICE.id
            elseif (ZO_IsElementInNumericallyIndexedTable(AH.AVATAR.WOLF.abilityIds, buffInfo.abilityId)) then
                icon = AH.CreateIcon("WOLF", buff, position.x, position.y)
                achievementId = AH.AVATAR.WOLF.id
            elseif (ZO_IsElementInNumericallyIndexedTable(AH.AVATAR.IRON.abilityIds, buffInfo.abilityId)) then
                icon = AH.CreateIcon("IRON", buff, position.x, position.y)
                achievementId = AH.AVATAR.IRON.id
            end

            if (icon) then
                local ttt = ""
                local name = GetAchievementName(achievementId)

                ttt = ttt .. name

                icon:SetHidden(false)
                icon:SetTooltip(ttt)
            end
        end
    end

    -- show stack counts
    if (AH.Vars.ShowStacks) then
        if (buffChoices[1].buffType == _G.ENDLESS_DUNGEON_BUFF_TYPE_VISION) then
            local counts = ENDLESS_DUNGEON_MANAGER:GetAbilityStackCountTable(buffChoices[1].buffType)

            for _, buffInfo in pairs(buffChoices) do
                local count = counts[buffInfo.abilityId] or 0

                if (count > 0 and (not buffInfo.isAvatarVision)) then
                    local buff = _G[string.format("%sBuff%dName", container, buffInfo.index)]
                    local countText = buff:GetText() .. " |cffff00" .. "(" .. count .. ")|r"

                    buff:SetText(countText)
                end
            end
        end
    end
end
