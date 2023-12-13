local AH = _G.ArchiveHelper

AH.LAM = _G.LibAddonMenu2

local panel = {
    type = "panel",
    name = "Archive Helper",
    displayName = zo_iconFormat("/esoui/art/icons/poi/poi_endlessdungeon_complete.dds") .. "|cff9900Archive Helper|r",
    author = "Flat Badger",
    version = "1.0.0",
    registerForRefresh = true,
    slashCommand = "/ah"
}
local favouriteChoices = {}
local favouriteChoiceValues = {}

local function doSort(tin, tout1, tout2)
    table.sort(
        tin,
        function(a, b)
            return a.name < b.name
        end
    )

    for _, choice in ipairs(tin) do
        table.insert(tout1, choice.name)
        table.insert(tout2, choice.id)
    end
end

do
    local tmpTable = {}

    for abilityId, _ in pairs(AH.ABILITIES) do
        table.insert(tmpTable, {id = abilityId, name = GetAbilityName(abilityId)})
    end

    doSort(tmpTable, favouriteChoices, favouriteChoiceValues)
end

local removeChoices = {}
local removeChoiceValues = {}

local function populateRemovableOptions(doNotFill)
    local choices = AH.Vars.Favourites

    if (#choices == 0) then
        return
    end

    local tmpTable = {}

    for _, choice in ipairs(choices) do
        local name = GetAbilityName(choice)
        local icon = GetAbilityIcon(choice)

        table.insert(tmpTable, {id = choice, name = name, icon = icon})
    end

    if (not doNotFill) then
        doSort(tmpTable, removeChoices, removeChoiceValues)
    end

    return tmpTable
end

local function getFavourites()
    local removed = populateRemovableOptions(true)
    local text = ""
    table.sort(
        removed,
        function(a, b)
            return a.name < b.name
        end
    )

    for _, ability in ipairs(removed) do
        text = text .. zo_iconFormat(ability.icon, 24, 24)
        text = text .. " " .. ability.name .. AH.LF
    end

    return text
end

local function updateFavourites()
    _G.ARCHIVE_HELPER_FAVOURITES_LIST.data.text = getFavourites()
    _G.ARCHIVE_HELPER_FAVOURITES_LIST:UpdateValue()
end

local function buildOptions()
    populateRemovableOptions()

    local options = {
        [1] = {
            type = "header",
            name = AH.Format(_G.SI_INTERFACE_OPTIONS_INDICATORS),
            width = "full"
        },
        [2] = {
            type = "checkbox",
            name = AH.Format(_G.SI_ZONECOMPLETIONTYPE3),
            getFunc = function()
                return AH.Vars.MarkAchievements
            end,
            setFunc = function(value)
                AH.Vars.MarkAchievements = value
            end,
            width = "full"
        },
        [3] = {
            type = "checkbox",
            name = AH.Format(_G.SI_ENDLESS_DUNGEON_SUMMARY_AVATAR_VISIONS_HEADER),
            getFunc = function()
                return AH.Vars.MarkAvatar
            end,
            setFunc = function(value)
                AH.Vars.MarkAvatar = value
            end,
            width = "full"
        },
        [4] = {
            type = "checkbox",
            name = AH.Format(_G.SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER),
            getFunc = function()
                return AH.Vars.MarkFavourites
            end,
            setFunc = function(value)
                AH.Vars.MarkFavourites = value
            end,
            width = "full"
        },
        [5] = {
            type = "header",
            name = AH.Format(_G.SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER),
            width = "full"
        },
        [6] = {
            type = "dropdown",
            name = AH.Format(_G.SI_COLLECTIBLE_ACTION_ADD_FAVORITE),
            choices = favouriteChoices,
            choicesValues = favouriteChoiceValues,
            getFunc = function()
            end,
            setFunc = function(value)
                if (ZO_IsElementInNumericallyIndexedTable(AH.Vars.Favourites, value)) then
                    return
                end

                table.insert(AH.Vars.Favourites, value)
                updateFavourites()
            end
        },
        [7] = {
            type = "dropdown",
            name = AH.Format(_G.SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE),
            choices = removeChoices,
            choicesValues = removeChoiceValues,
            getFunc = function()
            end,
            setFunc = function(value)
                if (ZO_IsElementInNumericallyIndexedTable(AH.Vars.Favourites, value)) then
                    AH.Vars.Favourites =
                        AH.Filter(
                        AH.Vars.Favourites,
                        function(v)
                            return v ~= value
                        end
                    )

                    updateFavourites()
                end
            end,
            disabled = function()
                return #AH.Vars.Favourites == 0
            end
        },
        [8] = {
            type = "description",
            text = "|cff0000" .. AH.Format(_G.ARCHIVEHELPER_WARNING) .. "|r",
            width = "full"
        },
        [9] = {
            type = "description",
            text = getFavourites(),
            width = "full",
            reference = "ARCHIVE_HELPER_FAVOURITES_LIST"
        }
    }
    return options
end

function AH.RegisterSettings()
    local options = buildOptions()

    AH.OptionsPanel = AH.LAM:RegisterAddonPanel("ArchiveHelperOptionsPanel", panel)
    AH.LAM:RegisterOptionControls("ArchiveHelperOptionsPanel", options)
end
