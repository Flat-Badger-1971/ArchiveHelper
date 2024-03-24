local AH = _G.ArchiveHelper

function AH.HandleSlashCommand(parameters)
    local options = {}
    local find = {parameters:match("^(%S*)%s*(.-)$")}
    local isInTable = ZO_IsElementInNumericallyIndexedTable

    for _, value in pairs(find) do
        if ((value or "") ~= "") then
            table.insert(options, string.lower(value))
        end
    end

    local missing = GetString(_G.ARCHIVEHELPER_SLASH_MISSING):lower()
    local verses = isInTable(options, AH.Format(_G.SI_ENDLESS_DUNGEON_SUMMARY_VERSES_HEADER):lower())
    local visions = isInTable(options, AH.Format(_G.SI_ENDLESS_DUNGEON_SUMMARY_VISIONS_HEADER):lower())
    local offensive = isInTable(options, AH.Format(_G.SI_ENDLESSDUNGEONBUFFBUCKETTYPE0):lower())
    local defensive = isInTable(options, AH.Format(_G.SI_ENDLESSDUNGEONBUFFBUCKETTYPE1):lower())
    local utility = isInTable(options, AH.Format(_G.SI_ENDLESSDUNGEONBUFFBUCKETTYPE2):lower())

    verses = verses or isInTable(options, AH.Format(_G.SI_ENDLESSDUNGEONBUFFTYPE1):lower())
    visions = visions or isInTable(options, AH.Format(_G.SI_ENDLESSDUNGEONBUFFTYPE2):lower())

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
        if (info.type == type) then
            if
                ((offensive and info.class == AH.CLASSES.OFFENCE) or (defensive and info.class == AH.CLASSES.DEFENCE) or
                    (utility and info.class == AH.CLASSES.UTILITY) or
                    ((utility or offensive or defensive) == false))
             then
                table.insert(toPrint, GetAbilityName(abilityId))
            end
        end
    end

    table.sort(toPrint)

    for _, name in ipairs(toPrint) do
        AH.Chat:SetTagColor("dc143c"):Print(AH.Format(name))
    end
end

function AH.PrintMissingAbilities(versesOnly, visionsOnly)
    if (not AH.Chat) then
        return
    end

    local missing = {}
    local insert = true

    for _, abilityInfo in ipairs(AH.MissingAbilities) do
        local buffType = GetAbilityEndlessDungeonBuffType(abilityInfo.id)

        if (versesOnly and buffType ~= AH.TYPES.VERSE) then
            insert = false
        elseif (visionsOnly and buffType ~= AH.TYPES.VISION) then
            insert = false
        end

        if (insert) then
            table.insert(missing, GetAbilityName(abilityInfo.id))
        end
    end

    if (#missing == 0) then
        local message = AH.Format(_G.ARCHIVEHELPER_ALL_BOTH)

        if (versesOnly) then
            message = AH.Format(_G.ARCHIVEHELPER_ALL_VERSES)
        elseif (visionsOnly) then
            message = AH.Format(_G.ARCHIVEHELPER_ALL_VISIONS)
        end

        AH.Chat:SetTagColor("dc134c"):Print(message)

        return
    end

    table.sort(missing)

    for _, missingName in ipairs(missing) do
        AH.Chat:SetTagColor("dc143c"):Print(AH.Format(missingName))
    end
end
