local EABA = _G.EndlessArchiveBuffAssistant

EABA.LAM = _G.LibAddonMenu2

local panel = {
    type = "panel",
    name = "Endless Archive Buff Assistant",
    displayName = zo_iconFormat("/esoui/art/icons/poi/poi_endlessdungeon_complete.dds") .. "Endless Archive Buff Assistant",
    author = "Flat Badger",
    version = "1.0.0",
    resetFunc = function()
        EABA.Setup()
    end,
    registerForDefaults = true,
    slashCommand = "/EABA"
}

local options = {
    -- [1] = {
        -- type = "button",
        -- name = GetString(_G.FISHBAR_MOVEFRAME),
        -- func = function()
            -- EABA.EnableMoving()
        -- end,
        -- width = "full"
    -- },
    -- [2] = {
        -- type = "checkbox",
        -- name = GetString(_G.FISHBAR_SHOW_LABEL),
        -- getFunc = function()
            -- return EABA.Vars.ShowFishing
        -- end,
        -- setFunc = function(value)
            -- EABA.Vars.ShowFishing = value
            -- EABA.Label:SetHidden(not value)
        -- end,
        -- width = "full",
        -- default = EABA.Defaults.ShowFishing
    -- },
    -- [3] = {
        -- type = "colorpicker",
        -- name = GetString(_G.FISHBAR_LABEL_COLOUR),
        -- getFunc = function()
            -- return EABA.Vars.LabelColour.r, EABA.Vars.LabelColour.g, EABA.Vars.LabelColour.b, EABA.Vars.LabelColour.a
        -- end,
        -- setFunc = function(r, g, b, a)
            -- EABA.Vars.LabelColour = {r = r, g = g, b = b, a = a}
            -- EABA.Label:SetColor(r, g, b, a)
        -- end,
        -- width = "full",
        -- default = EABA.Defaults.LabelColour
    -- },
    -- [4] = {
        -- type = "colorpicker",
        -- name = GetString(_G.FISHBAR_BAR_COLOUR),
        -- getFunc = function()
            -- return EABA.Vars.BarColour.r, EABA.Vars.BarColour.g, EABA.Vars.BarColour.b, EABA.Vars.BarColour.a
        -- end,
        -- setFunc = function(r, g, b, a)
            -- EABA.Vars.BarColour = {r = r, g = g, b = b, a = a}
            -- EABA.Bar:SetColor(r, g, b, a)
        -- end,
        -- width = "full",
        -- default = EABA.Defaults.BarColour
    -- },
    -- [5] = {
        -- type = "checkbox",
        -- name = GetString(_G.FISHBAR_EMOTE),
        -- tooltip = GetString(_G.FISHBAR_EMOTE_DESC),
        -- getFunc = function()
            -- return EABA.Vars.PlayEmote
        -- end,
        -- setFunc = function(value)
            -- EABA.Vars.PlayEmote = value
            -- CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", EABA.OptionsPanel)
        -- end,
        -- width = "full",
        -- default = EABA.Defaults.PlayEmote
    -- },
    -- [6] = {
        -- type = "dropdown",
        -- name = GetString(_G.SI_CHAT_CHANNEL_NAME_EMOTE),
        -- choices = emoteList,
        -- getFunc = function()
            -- return EABA.Emotes[EABA.Vars.Emote]
        -- end,
        -- setFunc = function(value)
            -- for idx, name in pairs(EABA.Emotes) do
                -- if (name == value) then
                    -- EABA.Vars.Emote = idx
                -- end
            -- end
        -- end,
        -- disabled = function()
            -- return EABA.Vars.PlayEmote == false
        -- end,
        -- width = "full"
    -- }
}

function EABA.RegisterSettings()
    EABA.OptionsPanel = EABA.LAM:RegisterAddonPanel("EndlessArchiveBuffAssistantOptionsPanel", panel)
    EABA.LAM:RegisterOptionControls("EndlessArchiveBuffAssistantOptionsPanel", options)
end
