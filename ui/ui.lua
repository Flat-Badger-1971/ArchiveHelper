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
    self.control:SetClampedToScreen(true)

    self.control.Background = WINDOW_MANAGER:CreateControl(nil, self.control, CT_BACKDROP)
    self.control.Background:SetAnchorFill()
    self.control.Background:SetEdgeColor(0, 0, 0, 0)

    self.control.Border = WINDOW_MANAGER:CreateControl(nil, self.control, CT_BACKDROP)
    self.control.Border:SetDrawTier(_G.DT_MEDIUM)
    self.control.Border:SetCenterTexture(0, 0, 0, 0)
    self.control.Border:SetAnchorFill()
    self.control.Border:SetEdgeTexture("/esoui/art/worldmap/worldmap_frame_edge.dds", 128, 16)

    self.control.Label = WINDOW_MANAGER:CreateControl(nil, self.control, CT_LABEL)
    self.control.Label:SetAnchor(CENTER)
    self.control.Label:SetFont("${BOLD_FONT}|24")
    self.control.Label:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)
    self.control.Label:SetVerticalAlignment(_G.TEXT_ALIGN_CENTER)
    self.control.Label:SetColor(1, 1, 0, 1)

    self.control:SetHidden(true)
end

function baseFrame:SetBackgroundColour(r, g, b, a)
    self.control.Background:SetCenterColor(r, g, b, a)
end

function baseFrame:SetPosition()
    local defaultY = GuiRoot:GetHeight() / 6
    local defaultX = GuiRoot:GetCenter()

    defaultX = defaultX - (self.width / 2)
    d(self.Name)
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

local solutionsWindow

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
                frame.control:SetResizeToFitDescendents(true)
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

    if (AH.Timer) then
        AH.Timer:SetHidden(true)
    end
end

local function setCommon(frame, name, width, height)
    frame:SetName(name)
    frame:SetDimensions(width, height)
    frame:SetPosition()
    frame:SetMouseHandler()
    frame:SetBackgroundColour(0.23, 0.23, 0.23, 0.7)
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

-- borrowed from Bandits UI
local function createComboBox(name, parent, width, height, choices, default, callback)
    local combo = WINDOW_MANAGER:CreateControlFromVirtual(name, parent, "ZO_ComboBox")

    combo:SetDimensions(width, height)

    combo.UpdateValues = function(self, array, index)
        local comboBox = self.m_comboBox

        combo.comboBox = comboBox

        if (array) then
            comboBox:ClearItems()

            for idx, value in pairs(array) do
                local entry =
                    ZO_ComboBox:CreateItemEntry(
                    value,
                    function()
                        combo.value = value
                        self:UpdateParent()

                        if (callback) then
                            callback(value)
                        end
                    end
                )
                entry.id = idx
                comboBox:AddItem(entry, _G.ZO_COMBOBOX_SUPRESS_UPDATE)
            end
        end

        comboBox:SelectItemByIndex(index, true)
        combo.value = default
        self:UpdateParent()
    end

    combo.SetDisabled = function(self, value)
        self.disabled = value
        self:SetMouseEnabled(not value)
        self:GetNamedChild("OpenDropdown"):SetMouseEnabled(not value)
        self:SetAlpha(value and 0.5 or 1)
        self:UpdateParent()
    end

    combo.UpdateParent = function(self)
        if (parent:GetType() == CT_LABEL) then
            local colour =
                self.disabled and {0.3, 0.3, 0.3, 1} or choices[combo.value] == "Disabled" and {0.5, 0.5, 0.4, 1} or
                {0.8, 0.8, 0.6, 1}
            parent:SetColor(unpack(colour))
        end
    end

    local index = default

    if (type(index) == "string") then
        combo.array = {}

        for idx, value in pairs(choices) do
            combo.array[value] = idx
        end

        index = combo.array[index]
    end

    combo.SetSelected = function(idx, ignoreCallback)
        combo.comboBox:SetSelected(idx, ignoreCallback)
    end

    combo:UpdateValues(choices, index)

    return combo
end

local function getOptions()
    local options = {}

    for _, optionGroup in ipairs(AH.CrossingOptions) do
        local group = {}

        for path in optionGroup:gmatch("(%d[LR]?)") do
            table.insert(group, path)
        end

        table.insert(options, group)
    end

    return options
end

local options = getOptions()
local refined = {}

local function findOptions(searchOptions, box)
    local refinedOptions = {}

    box = box or 1

    for _, option in ipairs(searchOptions) do
        if (AH.selectedBox[box]) then
            local opt = box

            if (box == 3) then
                opt = #option
            end

            if (option[opt]:find(AH.selectedBox[box])) then
                table.insert(refinedOptions, option)
            end
        else
            table.insert(refinedOptions, option)
        end
    end

    if (box == 3) then
        refined = refinedOptions
    else
        findOptions(refinedOptions, box + 1)
    end
end

local icons = {
    L = AH.ColourIcon("/esoui/art/buttons/large_leftdoublearrow_up.dds", "f9f9f9", 20, 20),
    R = AH.ColourIcon("esoui/art/buttons/large_rightdoublearrow_up.dds", "f9f9f9", 20, 20)
}

local function isReset()
    for _, value in pairs(AH.selectedBox) do
        if (tonumber(value)) then
            return false
        end
    end

    return true
end

function AH.CrossingUpdate(box, value)
    AH.selectedBox[box] = tostring(value)

    findOptions(options)

    local solutions = ""

    for _, solution in ipairs(refined) do
        local formattedSolution = ""

        for index, selection in ipairs(solution) do
            local opt = selection

            if (opt:len() == 2) then
                opt = opt:sub(1, 1) .. icons[selection:sub(2)] .. ((index == #solution) and "" or "  ")
            else
                opt = opt .. ((index == #solution) and "" or "      ")
            end

            formattedSolution = string.format("%s%s", formattedSolution, opt)
        end

        solutions = string.format("%s%s%s", solutions, AH.LF, formattedSolution)
    end

    if ((solutions:len() == 0) or isReset()) then
        solutions = GetString(_G.ARCHIVEHELPER_CROSSING_NO_SOLUTIONS)
    end

    solutionsWindow:SetText(solutions)
end

local function setHideHelperControls(hide, helper)
    local helperRef = helper or AH.CrossingHelper
    local controls = {
        "box",
        "boxlabel",
        "boxt",
        "close",
        "key",
        "pathsLabel",
        "text"
    }
    local triples = {"box", "boxlabel", "boxt"}

    for _, control in ipairs(controls) do
        if (ZO_IsElementInNumericallyIndexedTable(triples, control)) then
            for idx = 1, 3 do
                if (helperRef[control .. idx]) then
                    helperRef[control .. idx]:SetHidden(hide)
                end
            end
        else
            helperRef[control]:SetHidden(hide)
        end
    end

    solutionsWindow:SetHidden(hide)
end

function AH.ShowCrossingHelper(bypass)
    if ((AH.IsInCrossing and AH.Vars.ShowHelper) or bypass) then
        local groupType = AH.GetActualGroupType()

        if (IsUnitGroupLeader("player") or groupType == _G.ENDLESS_DUNGEON_GROUP_TYPE_SOLO) then
            AH.IsLeader = true
        else
            AH.IsLeader = false
        end

        if (not AH.AH_SHARING) then
            AH.IsLeader = true
        end

        ensureFramePoolExists()

        local helper, helperKey = AH.FrameObjectPool:AcquireObject()
        local label = helper.control.Label

        setCommon(helper, "CrossingHelper", 400, 470)

        helper.control:SetResizeToFitDescendents(false)
        helper.control:SetWidth(400)
        helper.control:SetHeight(500)

        helper:SetAnchor(
            TOPLEFT,
            GuiRoot,
            TOPLEFT,
            AH.Vars.CrossingHelperPosition.left,
            AH.Vars.CrossingHelperPosition.top
        )
        helper:SetText(GetString(_G.ARCHIVEHELPER_CROSSING_TITLE))
        helper:SetColour(1, 1, 0, 1)
        helper:SetHidden(false)
        helper:SetBackgroundColour(0, 0, 0, 0.9)

        label:ClearAnchors()
        label:SetAnchor(TOPLEFT, helper.control, TOPLEFT, 0, 10)
        label:SetHeight(20)

        helper.close =
            _G[AH.Name .. "_close"] or
            WINDOW_MANAGER:CreateControlFromVirtual(AH.Name .. "_close", helper.control, "ZO_CloseButton")

        helper.close:ClearAnchors()
        helper.close:SetAnchor(TOPRIGHT, helper.control, TOPRIGHT, -10, 10)
        helper.close:SetHandler("OnClicked", AH.HideCrossingHelper)

        helper.text =
            _G[AH.Name .. "_ch_text"] or WINDOW_MANAGER:CreateControl(AH.Name .. "_ch_text", helper.control, CT_LABEL)

        helper.text:ClearAnchors()
        helper.text:SetAnchor(TOPLEFT, label, BOTTOMLEFT, 10, 10)
        helper.text:SetAnchor(BOTTOMRIGHT, helper.control, BOTTOMRIGHT, -10, -370)
        helper.text:SetFont("${MEDIUM_FONT}|14")
        helper.text:SetHorizontalAlignment(_G.TEXT_ALIGN_LEFT)
        helper.text:SetVerticalAlignment(_G.TEXT_ALIGN_CENTER)
        helper.text:SetColor(0.82, 0.82, 0.82, 1)
        helper.text:SetText(GetString(_G.ARCHIVEHELPER_CROSSING_INSTRUCTIONS))

        local ordinals = {
            [1] = GetString(_G.ARCHIVEHELPER_CROSSING_START),
            [2] = zo_strformat("<<i:1>>", 2),
            [3] = AH.Format(_G.SI_KEYCODE16)
        }

        for box = 1, 3 do
            if (AH.IsLeader) then
                helper["box" .. box] =
                    _G[AH.Name .. "_choice" .. box] or
                    createComboBox(
                        AH.Name .. "_choice" .. box,
                        helper.control,
                        40,
                        40,
                        {1, 2, 3, 4, 5, 6, ""},
                        nil,
                        function(value)
                            AH.CrossingUpdate(box, value)
                        end
                    )
            else
                helper["box" .. box] =
                    _G[AH.Name .. "_choice" .. box] or
                    WINDOW_MANAGER:CreateControl(AH.Name .. "_choice" .. box, helper.control, CT_LABEL)
                helper["box" .. box]:SetWidth(40)
                helper["box" .. box]:SetHeight(40)
                helper["box" .. box]:SetFont("${MEDIUM_FONT}|22")
                helper["box" .. box]:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)
                helper["box" .. box]:SetVerticalAlignment(_G.TEXT_ALIGN_CENTER)

                helper["boxt" .. box] =
                    _G[AH.Name .. "_bbg" .. box] or
                    WINDOW_MANAGER:CreateControl(AH.Name .. "_bbg" .. box, helper["box" .. box], CT_BACKDROP)
                helper["boxt" .. box]:SetEdgeTexture("esoui/art/tooltips/ui-border.dds", 128, 16)
                helper["boxt" .. box]:SetCenterTexture("esoui/art/tooltips/ui-tooltipcenter.dds")
                helper["boxt" .. box]:SetAnchorFill()
            end

            helper["box" .. box]:SetAnchor(TOPLEFT, helper.text, BOTTOMLEFT, 20 + (box * 75), 50)
            helper["boxlabel" .. box] =
                _G[AH.Name .. "_boxlabel" .. box] or
                WINDOW_MANAGER:CreateControl(AH.Name .. "_boxlabel" .. box, helper.control, CT_LABEL)

            local boxlabel = helper["boxlabel" .. box]

            boxlabel:SetText(ordinals[box])
            boxlabel:ClearAnchors()
            boxlabel:SetAnchor(CENTER, helper["box" .. box], CENTER, 0, -40)
            boxlabel:SetFont("${MEDIUM_FONT}|16")
            boxlabel:SetHorizontalAlignment(_G.TEXT_ALIGN_LEFT)
            boxlabel:SetColor(1, 1, 0, 1)

            helper.pathsLabel =
                _G[AH.Name .. "_pathslabel"] or
                WINDOW_MANAGER:CreateControl(AH.Name .. "_pathslabel", helper.control, CT_LABEL)

            helper.pathsLabel:SetText(GetString(_G.ARCHIVEHELPER_CROSSING_PATHS))
            helper.pathsLabel:ClearAnchors()
            helper.pathsLabel:SetAnchor(CENTER, helper.text, CENTER, 0, 180)
            helper.pathsLabel:SetFont("${BOLD_FONT}|24")
            helper.pathsLabel:SetColor(1, 1, 0, 1)
            helper.pathsLabel:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)

            solutionsWindow =
                _G[AH.Name .. "_solutions"] or
                WINDOW_MANAGER:CreateControl(AH.Name .. "_solutions", helper.control, CT_LABEL)

            solutionsWindow:ClearAnchors()
            solutionsWindow:SetAnchor(TOPLEFT, helper.text, BOTTOMLEFT, 0, 100)
            solutionsWindow:SetAnchor(BOTTOMRIGHT, helper.control, BOTTOMRIGHT, -10, -10)
            solutionsWindow:SetFont("${MEDIUM_FONT}|24")
            solutionsWindow:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)
            solutionsWindow:SetVerticalAlignment(_G.TEXT_ALIGN_CENTER)
            solutionsWindow:SetColor(0.976, 0.976, 0.976, 1)

            helper.key =
                _G[AH.Name .. "_key"] or WINDOW_MANAGER:CreateControl(AH.Name .. "_key", helper.control, CT_LABEL)
            helper.key:ClearAnchors()
            helper.key:SetAnchor(CENTER, helper.control, CENTER, 0, 230)
            helper.key:SetFont("${BOLD_FONT}|16")
            helper.key:SetColor(0.82, 0.82, 0.82, 1)
            helper.key:SetHorizontalAlignment(_G.TEXT_ALIGN_CENTER)
            helper.key:SetText(zo_strformat(GetString(_G.ARCHIVEHELPER_CROSSING_KEY), icons.L, icons.R))
        end

        setHideHelperControls(false, helper)

        AH.Keys["CrossingHelper"] = helperKey
        AH.CrossingHelper = helper
        AH.selectedBox = {[1] = false, [2] = false, [3] = false}
    end
end

function AH.HideCrossingHelper()
    AH.selectedBox[1] = false
    AH.selectedBox[2] = false
    AH.selectedBox[3] = false

    AH.CrossingHelper.box1.SetSelected(7, true)
    AH.CrossingHelper.box2.SetSelected(7, true)
    AH.CrossingHelper.box3.SetSelected(7, true)

    solutionsWindow:SetText("")

    setHideHelperControls(true)
    AH.Release("CrossingHelper")
end
