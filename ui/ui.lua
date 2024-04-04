local AH = _G.ArchiveHelper

local baseFrame = ZO_Object:Subclass()

function baseFrame:New()
    local frame = ZO_Object.New(self)

    frame:Initialise()

    return frame
end

function baseFrame:Initialise()
    self.control = WINDOW_MANAGER:CreateTopLevelWindow()

    self.control:SetResizeToFitDescendents(true)
    self.control:SetDrawTier(DT_HIGH)
    self.control:SetMouseEnabled(true)
    self.control:SetMovable(true)

    self.control.Background = WINDOW_MANAGER:CreateControl(nil, self.control, CT_BACKDROP)
    self.control.Background:SetAnchorFill()
    self.control.Background:SetEdgeColor(0, 0, 0, 0)
    self.control.Background:SetCenterColor(0.23, 0.23, 0.23, 0.7)

    self.control.Border = WINDOW_MANAGER:CreateControl(nil, self.control, CT_BACKDROP)
    self.control.Border:SetDrawTier(_G.DT_MEDIUM)
    self.control.Border:SetCenterTexture(0, 0, 0, 0)
    self.control.Border:SetAnchorFill()
    self.control.Border:SetEdgeTexture("/esoui/art/worldmap/worldmap_frame_edge.dds", 128, 16)

    self.control.Label = WINDOW_MANAGER:CreateControl(nil, self.control, CT_LABEL)
    self.control.Label:SetAnchor(CENTER)
    self.control.Label:SetFont("${MEDIUM_FONT}|24")
    self.control.Label:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)
    self.control.Label:SetVerticalAlignment(_G.TEXT_ALIGN_CENTER)
    self.control.Label:SetColor(1, 1, 0, 1)

    self.control:SetHidden(true)
end

function baseFrame:SetPosition()
    local defaultY = GuiRoot:GetHeight() / 6
    local defaultX = GuiRoot:GetCenter()

    defaultX = defaultX - (self.width / 2)

    if (not AH.Vars[self.name .. "Position"]) then
        AH.Vars[self.name .. "Position"] = {top = defaultY, left = defaultX}
    end

    if (not AH.Vars[self.name .. "Position"]) then
        AH.Vars[self.name .. "Position"] = {top = defaultY, left = defaultX}
    end
end

function baseFrame:SetMouseHandler()
    local onMouseUp = function()
        local top, left = self.control:GetTop(), self.control:GetLeft()

        AH.Vars[self.name .. "Position"] = {top = top, left = left}
    end

    self.control:SetHandler("OnMouseUp", onMouseUp)
end

function baseFrame:SetDimensions(width, height)
    self.width = width
    self.height = height
    self.control.Label:SetDimensions(width, height)
end

function baseFrame:SetName(name)
    self.name = name
end

function baseFrame:SetAnchor(relativeTo, relativeObject, relativeObjectPoint, xOffset, yOffset)
    self.control:SetAnchor(relativeTo, relativeObject, relativeObjectPoint, xOffset, yOffset)
end

function baseFrame:SetColour(r, g, b, a)
    self.control.Label:SetColor(r, g, b, a)
end

function baseFrame:SetText(text)
    self.control.Label:SetText(text)
end

function baseFrame:SetHidden(hidden)
    self.control:SetHidden(hidden)
end

function baseFrame:IsHidden()
    return self.control:IsHidden()
end

function baseFrame:ClearAnchors()
    self.control:ClearAnchors()
end

local function ensureFramePoolExists()
    if (not AH.FrameObjectPool) then
        AH.FrameObjectPool =
            ZO_ObjectPool:New(
            --factory
            function()
                return baseFrame:New()
            end,
            --reset
            function(frame)
                frame:SetHidden(true)
                frame:ClearAnchors()
                frame:SetText("")
                frame:SetColour(1, 1, 0, 1)
            end
        )
    end
end

function AH.SetTime()
    local time =
        ZO_CachedStrFormat(
        _G.SI_SCREEN_NARRATION_TIMER_BAR_DESCENDING_FORMATTER,
        AH.CurrentTimerValue .. AH.Format(_G.ARCHIVEHELPER_SECONDS):lower()
    )

    AH.Timer:SetText(time)

    if (AH.CurrentTimerValue < 11) then
        AH.Timer:SetColour(1, 0, 0, 1)
    end
end

function AH.StartTimer()
    AH.CurrentTimerValue = AH.Vars.EchoingDenTimer
    AH.Timer:SetColour(1, 1, 0, 1)

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

local function setCommon(frame, name, width, height)
    frame:SetName(name)
    frame:SetDimensions(width, height)
    frame:SetPosition()
    frame:SetMouseHandler()
end

function AH.ShowTimer()
    if (AH.IsInEchoingDen and AH.Vars.ShowTimer) then
        ensureFramePoolExists()

        local timer, timerKey = AH.FrameObjectPool:AcquireObject()

        setCommon(timer, "Timer", 200, 40)
        timer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AH.Vars.TimerPosition.left, AH.Vars.TimerPosition.top)
        AH.CurrentTimerValue = AH.Vars.EchoingDenTimer
        timer:SetColour(1, 1, 0, 1)
        timer:SetHidden(false)

        AH.Timer = timer
        AH.Keys["Timer"] = timerKey

        AH.SetTime(AH.Vars.EchoingDenTimer)
    end
end

function AH.HideTimer()
    AH.Release("Timer")
end

function AH.ShowNotice(message)
    if (AH.Vars.ShowNotice) then
        ensureFramePoolExists()

        local parent = _G[AH.SELECTOR_SHORT]
        local notice, noticeKey = AH.FrameObjectPool:AcquireObject()

        setCommon(notice, "Notice", 300, 40)

        notice:ClearAnchors()
        notice:SetAnchor(BOTTOM, parent, TOP, 0, -32)
        notice:SetAnchor(TOP, parent, TOP, 0, -72)
        notice:SetText(message)
        notice:SetHidden(false)

        AH.Notice = notice
        AH.Keys["Notice"] = noticeKey
    end
end

function AH.ShowQuestReminder()
    if (AH.Vars.CheckQuestItems and AH.FoundQuestItem) then
        ensureFramePoolExists()

        local parent = _G[AH.SELECTOR_SHORT]
        local questReminder, questReminderKey = AH.FrameObjectPool:AcquireObject()

        setCommon(questReminder, "Quest", 400, 40)

        questReminder:ClearAnchors()
        questReminder:SetAnchor(BOTTOM, parent, TOP, 0, -120)
        questReminder:SetAnchor(TOP, parent, TOP, 0, -160)
        questReminder:SetText(AH.Format(_G.ARCHIVEHELPER_REMINDER_QUEST_TEXT))
        questReminder:SetHidden(false)

        AH.QuestReminder = questReminder
        AH.Keys["QuestReminder"] = questReminderKey
    end
end

function AH.ShowTomeshellCount()
    if (AH.IsInFilersWing and AH.Vars.CountTomes) then
        ensureFramePoolExists()

        local count, countKey = AH.FrameObjectPool:AcquireObject()

        setCommon(count, "Count", 200, 40)

        count:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AH.Vars.CountPosition.left, AH.Vars.CountPosition.top)
        count:SetColour(1, 1, 0, 1)
        count:SetHidden(false)

        AH.TomeCount = count
        AH.Keys["TomeCount"] = countKey
    end
end
