local EAVV = _G.EndlessArchiveVersesAndVisions

EAVV.LAM = _G.LibAddonMenu2

function EAVV.Format(value, ...)
    local text = value

    if (type(value) == "number") then
        text = GetString(value)
    end

    return ZO_CachedStrFormat("<<C:1>>", text, ...)
end

function EAVV.Filter(t, filterFunc)
    local out = {}

    for k, v in pairs(t) do
        if (filterFunc(v, k, t)) then
            table.insert(out, v)
        end
    end

    return out
end

local panel = {
    type = "panel",
    name = "Endless Archive Verses And Visions",
    displayName = zo_iconFormat("/esoui/art/icons/poi/poi_endlessdungeon_complete.dds") ..
        "|cff9900Endless Archive Verses And Visions|r",
    author = "Flat Badger",
    version = "1.0.0",
    registerForRefresh = true,
    slashCommand = "/eavv"
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

    for abilityId, _ in pairs(EAVV.ABILITIES) do
        table.insert(tmpTable, {id = abilityId, name = GetAbilityName(abilityId)})
    end

    doSort(tmpTable, favouriteChoices, favouriteChoiceValues)
end

local removeChoices = {}
local removeChoiceValues = {}

local function populateRemovableOptions(doNotFill)
    local choices = EAVV.Vars.Favourites

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

local function getRemovable()
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
        text = text .. " " .. ability.name .. EAVV.LF
    end

    return text
end

local function updateRemovable()
    _G.EAVV_Removed.data.text = getRemovable()
    _G.EAVV_Removed:UpdateValue()
end

local function buildOptions()
    populateRemovableOptions()

    local options = {
        [1] = {
            type = "header",
            name = EAVV.Format(_G.SI_INTERFACE_OPTIONS_INDICATORS),
            width = "full"
        },
        [2] = {
            type = "checkbox",
            name = EAVV.Format(_G.SI_ZONECOMPLETIONTYPE3),
            getFunc = function()
                return EAVV.Vars.MarkAchievements
            end,
            setFunc = function(value)
                EAVV.Vars.MarkAchievements = value
            end,
            width = "full"
        },
        [3] = {
            type = "checkbox",
            name = EAVV.Format(_G.SI_ENDLESS_DUNGEON_SUMMARY_AVATAR_VISIONS_HEADER),
            getFunc = function()
                return EAVV.Vars.MarkAvatar
            end,
            setFunc = function(value)
                EAVV.Vars.MarkAvatar = value
            end,
            width = "full"
        },
        [4] = {
            type = "checkbox",
            name = EAVV.Format(_G.SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER),
            getFunc = function()
                return EAVV.Vars.MarkFavourites
            end,
            setFunc = function(value)
                EAVV.Vars.MarkFavourites = value
            end,
            width = "full"
        },
        [5] = {
            type = "header",
            name = EAVV.Format(_G.SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER),
            width = "full"
        },
        [6] = {
            type = "dropdown",
            name = EAVV.Format(_G.SI_COLLECTIBLE_ACTION_ADD_FAVORITE),
            choices = favouriteChoices,
            choicesValues = favouriteChoiceValues,
            getFunc = function()
            end,
            setFunc = function(value)
                if (ZO_IsElementInNumericallyIndexedTable(EAVV.Vars.Favourites, value)) then
                    return
                end

                table.insert(EAVV.Vars.Favourites, value)
                updateRemovable()
            end
        },
        [7] = {
            type = "dropdown",
            name = EAVV.Format(_G.SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE),
            choices = removeChoices,
            choicesValues = removeChoiceValues,
            getFunc = function()
            end,
            setFunc = function(value)
                if (ZO_IsElementInNumericallyIndexedTable(EAVV.Vars.Favourites, value)) then
                    EAVV.Vars.Favourites =
                        EAVV.Filter(
                        EAVV.Vars.Favourites,
                        function(v)
                            return v ~= value
                        end
                    )

                    updateRemovable()
                end
            end,
            disabled = function()
                return #EAVV.Vars.Favourites == 0
            end
        },
        [8] = {
            type = "description",
            text = "|cff0000" .. EAVV.Format(_G.EndlessArchiveVersesAndVisions_WARNING) .. "|r",
            width = "full"
        },
        [9] = {
            type = "description",
            text = getRemovable(),
            width = "full",
            reference = "EAVV_Removed"
        }
    }
    return options
end

function EAVV.RegisterSettings()
    local options = buildOptions()

    EAVV.OptionsPanel = EAVV.LAM:RegisterAddonPanel("EndlessArchiveVersesAndVisionsOptionsPanel", panel)
    EAVV.LAM:RegisterOptionControls("EndlessArchiveVersesAndVisionsOptionsPanel", options)
end
