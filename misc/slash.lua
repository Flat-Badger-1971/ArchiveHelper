local AH = ArchiveHelper

function AH.HandleSlashCommand(parameters)
    local options = {}
    local find = { zo_strmatch(parameters, "^(%S*)%s*(.-)$") }
    local isInTable = ZO_IsElementInNumericallyIndexedTable

    for _, value in pairs(find) do
        if ((value or "") ~= "") then
            table.insert(options, string.lower(value))
        end
    end

    local defensive = isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESSDUNGEONBUFFBUCKETTYPE1)))
    local helper = zo_strlower(GetString(ARCHIVEHELPER_CROSSING_SLASH))
    local missing = zo_strlower(GetString(ARCHIVEHELPER_SLASH_MISSING))
    local offensive = isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESSDUNGEONBUFFBUCKETTYPE0)))
    local utility = isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESSDUNGEONBUFFBUCKETTYPE2)))
    local verses = isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESS_DUNGEON_SUMMARY_VERSES_HEADER)))
    local visions = isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESS_DUNGEON_SUMMARY_VISIONS_HEADER)))

    verses = verses or isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESSDUNGEONBUFFTYPE1)))
    visions = visions or isInTable(options, zo_strlower(AH.LC.Format(SI_ENDLESSDUNGEONBUFFTYPE2)))

    if (#options > 0) then
        if (isInTable(options, "missing") or isInTable(options, missing)) then
            -- /ah missing [verse[s]/vision[s]]
            AH.PrintMissingAbilities(verses, visions)
        elseif (verses) then
            -- /ah verse[s] [offensive/defensive/utility]
            AH.Print(AH.TYPES.VERSE, offensive, defensive, utility)
        elseif (visions) then
            -- /ah vision[s] [offensive/defensive/utility]
            AH.Print(AH.TYPES.VISION, offensive, defensive, utility)
        elseif (isInTable(options, helper)) then
            -- /ah helper
            AH.ToggleCrossingHelper()
        end

        return
    end

    -- /ah
    AH.LAM:OpenToPanel(AH.OptionsPanel)
end

function AH.Print(type, offensive, defensive, utility)
    if (not AH.Chat) then
        return
    end

    local toPrint = {}

    for abilityId, info in pairs(AH.ABILITIES) do
        if ((info.type or AH.TYPES.VERSE) == type) then
            if
                ((offensive and info.class == AH.CLASSES.OFFENCE) or (defensive and info.class == AH.CLASSES.DEFENCE) or
                    (utility and info.class == AH.CLASSES.UTILITY) or
                    ((utility or offensive or defensive) == false))
            then
                local name = GetAbilityName(abilityId, "player")

                if (name and name ~= "") then
                    table.insert(toPrint, name)
                end
            end
        end
    end

    table.sort(toPrint)

    for _, name in ipairs(toPrint) do
        AH.Chat:SetTagColor("dc143c"):Print(AH.LC.Format(name))
    end
end

function AH.PrintMissingAbilities(versesOnly, visionsOnly)
    if (not AH.Chat) then
        return
    end

    local missing = {}

    for _, abilityInfo in ipairs(AH.MissingAbilities) do
        local insert = true
        local buffType = GetAbilityEndlessDungeonBuffType(abilityInfo.id)

        if (versesOnly and buffType ~= AH.TYPES.VERSE) then
            insert = false
        elseif (visionsOnly and buffType ~= AH.TYPES.VISION) then
            insert = false
        end

        if (insert) then
            local name = GetAbilityName(abilityInfo.id, "player")

            if (name and name ~= "") then
                table.insert(missing, name)
            end
        end
    end

    if (#missing == 0) then
        local message = AH.LC.Format(ARCHIVEHELPER_ALL_BOTH)

        if (versesOnly) then
            message = AH.LC.Format(ARCHIVEHELPER_ALL_VERSES)
        elseif (visionsOnly) then
            message = AH.LC.Format(ARCHIVEHELPER_ALL_VISIONS)
        end

        AH.Chat:SetTagColor("dc134c"):Print(message)

        return
    end

    table.sort(missing)

    for _, missingName in ipairs(missing) do
        AH.Chat:SetTagColor("dc143c"):Print(AH.LC.Format(missingName))
    end
end
