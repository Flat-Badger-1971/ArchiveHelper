local AH = _G.ArchiveHelper

AH.IconTypes = {
    ACH = "MarkAchievements",
    FAV = "MarkFavourites",
    ICE = "MarkAvatar",
    IRON = "MarkAvatar",
    WOLF = "MarkAvatar"
}

local baseIconControl = ZO_Object:Subclass()

function baseIconControl:New()
    local iconControl = ZO_Object.New(self)

    iconControl:Initialise()

    return iconControl
end

function baseIconControl:Initialise()
    self.control = self.control or WINDOW_MANAGER:CreateControl(nil, GuiRoot, CT_CONTROL)
    self.control:SetDrawTier(_G.DT_HIGH)
    self.control:SetDimensions(48, 48)

    self.texture = self.texture or WINDOW_MANAGER:CreateControl(nil, self.control, CT_TEXTURE)
    self.texture:SetAnchorFill(self.control)

    self.control:SetMouseEnabled(true)
    self.control:SetHandler(
        "OnMouseEnter",
        function()
            if (self.tooltip) then
                if (not IsInGamepadPreferredMode()) then
                    ZO_Tooltips_ShowTextTooltip(self.control, TOPLEFT, self.control.tooltip)
                end
            end
        end
    )

    self.control:SetHandler(
        "OnMouseExit",
        function()
            ZO_Tooltips_HideTextTooltip()
        end
    )
end

function baseIconControl:SetParent(parent)
    self.control:SetParent(parent)
end

function baseIconControl:SetTexture(texture)
    self.texture:SetTexture(texture)
end

function baseIconControl:SetColour(colour)
    self.texture:SetColor(unpack(colour))
end

function baseIconControl:SetTooltip(text)
    self.tooltip = text
end

function baseIconControl:SetAnchor(where, targetControl, whereOnTarget, offsetX, offsetY)
    self.control:SetAnchor(where, targetControl, whereOnTarget, offsetX, offsetY)
end

function baseIconControl:SetHidden(hidden)
    self.control:SetHidden(hidden)
end

function AH.EnsurePoolExists()
    if (not AH.ObjectPool) then
        AH.ObjectPool = {}
        AH.ObjectPool =
            ZO_ObjectPool:New(
            --factory
            function()
                return baseIconControl:New()
            end,
            --reset
            function(iconControl)
                iconControl.tooltip = nil
                iconControl.control:SetHidden(true)
                iconControl.control:ClearAnchors()
            end
        )
    end
end

function AH.CreateIcon(icon, parent, xOffset, yOffset)
    local iconControl = AH.ObjectPool:AcquireObject()
    local iconInfo = AH.ICONS[icon]

    iconControl:SetParent(parent)
    iconControl:SetAnchor(TOPLEFT, parent, TOPLEFT, xOffset or 0, yOffset or 0)
    iconControl:SetTexture(string.format("/esoui/art/%s.dds", iconInfo.name))
    iconControl:SetColour(iconInfo.colour)
    iconControl:SetHidden(true)

    return iconControl
end
