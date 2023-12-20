local AH = _G.ArchiveHelper

local function Initialise()
    -- saved variables
    AH.Vars =
        _G.LibSavedVars:NewAccountWide("ArchiveHelperSavedVars", "Account", AH.Defaults):AddCharacterSettingsToggle(
        "ArchiveHelperSavedVars",
        "Characters"
    ):EnableDefaultsTrimming()

    AH.RegisterSettings()

    local selector_short = "ZO_EndDunBuffSelector_%s"
    local selector = "ZO_EndlessDungeonBuffSelector_%s"

    if (IsInGamepadPreferredMode()) then
        AH.SELECTOR_SHORT = string.format(selector_short, "Gamepad")
        AH.SELECTOR = string.format(selector, "Gamepad")
    else
        AH.SELECTOR_SHORT = string.format(selector_short, "Keyboard")
        AH.SELECTOR = string.format(selector, "Keyboard")
    end

    SecurePostHook(
        _G[AH.SELECTOR],
        "OnShowing",
        function()
            AH.OnBuffSelectorShowing()
            AH.CheckNotice()
        end
    )

    SecurePostHook(
        ZO_EndlessDungeonBuffSelector_Shared,
        "OnHiding",
        function()
            AH.CloseNotice()
        end
    )

    SecurePostHook(
        CENTER_SCREEN_ANNOUNCE,
        "DisplayMessage",
        function(_, messageParams)
            if (AH.Vars.ShowTimer) then
                AH.CheckMessage(messageParams)
            end
        end
    )

    AH.FindMissingAbilityIds()

    _G.SLASH_COMMANDS["/ah"] = function(...)
        AH.HandleSlashCommand(...)
    end

    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACHIEVEMENT_UPDATED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ACHIEVEMENT_AWARDED, AH.FindMissingAbilityIds)
    EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_PLAYER_ACTIVATED, AH.CheckZone)
end

function AH.OnAddonLoaded(_, addonName)
    if (addonName ~= AH.Name) then
        return
    end

    if (_G.LibChatMessage ~= nil) then
        AH.Chat = _G.LibChatMessage(AH.Name, "AH")
    end

    EVENT_MANAGER:UnregisterForEvent(AH.Name, _G.EVENT_ADD_ON_LOADED)

    Initialise()
end

EVENT_MANAGER:RegisterForEvent(AH.Name, _G.EVENT_ADD_ON_LOADED, AH.OnAddonLoaded)
