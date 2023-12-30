local AH = _G.ArchiveHelper

function AH.CreateControl(width, height, name)
    local _, defaultY = GuiRoot:GetCenter()
    defaultY = defaultY - (width / 2)

    local defaultX = GuiRoot:GetHeight() / 4

    if (not AH.Vars[name .. "Position"]) then
        AH.Vars[name .. "Position"] = {top = defaultY, left = defaultX}
    end

    local control = WINDOW_MANAGER:CreateTopLevelWindow()

    control:SetResizeToFitDescendents(true)
    control:SetDrawTier(DT_HIGH)
    control:SetMouseEnabled(true)
    control:SetMovable(true)
    control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AH.Vars[name .. "Position"].left, AH.Vars[name .. "Position"].top)

    local onMouseUp = function()
        local top, left = control:GetTop(), control:GetLeft()

        AH.Vars[name .. "Position"] = {top = top, left = left}
    end

    control:SetHandler("OnMouseUp", onMouseUp)

    control.Background = WINDOW_MANAGER:CreateControl(nil, control, CT_BACKDROP)
    control.Background:SetAnchorFill()
    control.Background:SetEdgeColor(0, 0, 0, 0)
    control.Background:SetCenterColor(0.23, 0.23, 0.23, 0.7)

    control.Border = WINDOW_MANAGER:CreateControl(nil, control, CT_BACKDROP)
    control.Border:SetDrawTier(_G.DT_MEDIUM)
    control.Border:SetCenterTexture(0, 0, 0, 0)
    control.Border:SetAnchorFill()
    control.Border:SetEdgeTexture("/esoui/art/worldmap/worldmap_frame_edge.dds", 128, 16)

    control.Label = WINDOW_MANAGER:CreateControl(nil, control, CT_LABEL)
    control.Label:SetDimensions(width, height)
    control.Label:SetAnchor(CENTER, AH.Timer, CENTER)
    control.Label:SetFont("EsoUi/Common/Fonts/Univers67.otf|24")
    control.Label:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)
    control.Label:SetVerticalAlignment(_G.TEXT_ALIGN_CENTER)
    control.Label:SetColor(1, 1, 0, 1)

    control:SetHidden(true)

    return control
end

function AH.SetTime()
    local time =
        ZO_CachedStrFormat(
        _G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER,
        AH.CurrentTimerValue .. AH.Format(_G.ARCHIVEHELPER_SECONDS):lower()
    )

    AH.Timer.Label:SetText(time)

    if (AH.CurrentTimerValue < 11) then
        AH.Timer.Label:SetColor(1, 0, 0, 1)
    end
end

function AH.StartTimer()
    AH.CurrentTimerValue = AH.Vars.EchoingDenTimer
    AH.Timer.Label:SetColor(1, 1, 0, 1)

    if (AH.Timer:IsHidden()) then
        AH.SetHidden(false)
    end

    EVENT_MANAGER:RegisterForUpdate(
        AH.Name .. "_timer",
        1000,
        function()
            AH.CurrentTimerValue = AH.CurrentTimerValue - 1
            AH.SetTime()

            if (AH.CurrentTimerValue == 0) then
                AH.StopTimer()
            end
        end
    )

    AH.Timer:SetHidden(false)
end

function AH.StopTimer()
    EVENT_MANAGER:UnregisterForUpdate(AH.Name .. "_timer")

    AH.Timer:SetHidden(true)
end

function AH.ShowTimer()
    if (AH.IsInEchoingDen and AH.Vars.ShowTimer) then
        AH.Timer = AH.Timer or AH.CreateControl(200, 40, "Timer")
        AH.CurrentTimerValue = AH.Vars.EchoingDenTimer
        AH.Timer.Label:SetColor(1, 1, 0, 1)
        AH.SetTime(AH.Vars.EchoingDenTimer)
        AH.Timer:SetHidden(false)
    end
end

function AH.HideTimer()
    if (AH.Timer:IsHidden()) then
        return
    end

    AH.Timer:SetHidden(true)
end

function AH.ShowNotice(message)
    if (AH.Vars.ShowNotice) then
        local parent = _G[AH.SELECTOR_SHORT]

        AH.Notice = AH.Notice or AH.CreateControl(300, 40, "Notice")
        AH.Notice:ClearAnchors()
        AH.Notice:SetAnchor(BOTTOM, parent, TOP, 0, -32)
        AH.Notice:SetAnchor(TOP, parent, TOP, 0, -72)
        AH.Notice.Label:SetText(message)
        AH.Notice:SetHidden(false)
    end
end

function AH.ShowQuestReminder()
    if (AH.Vars.CheckQuestItems and AH.FoundQuestItem) then
        local parent = _G[AH.SELECTOR_SHORT]

        AH.QuestReminder = AH.QuestReminder or AH.CreateControl(400, 40, "Quest")
        AH.QuestReminder:ClearAnchors()
        AH.QuestReminder:SetAnchor(BOTTOM, parent, TOP, 0, -120)
        AH.QuestReminder:SetAnchor(TOP, parent, TOP, 0, -160)
        AH.QuestReminder.Label:SetText(AH.Format(_G.ARCHIVEHELPER_REMINDER_QUEST_TEXT))
        AH.QuestReminder:SetHidden(false)
    end
end