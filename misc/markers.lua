local AH = _G.ArchiveHelper
local fabledText = GetString(_G.ARCHIVEHELPER_FABLED)
local shardText = GetString(_G.ARCHIVEHELPER_SHARD)
local gwText = GetString(_G.ARCHIVEHELPER_GW)
-- local cache for performance
local GetUnitName, GetUnitTargetMarkerType = GetUnitName, GetUnitTargetMarkerType
local IsUnitDead, AssignTargetMarkerToReticleTarget = IsUnitDead, AssignTargetMarkerToReticleTarget

-- marker 8 reserved for marauders
AH.MARKERS = {
    [1] = {marker = _G.TARGET_MARKER_TYPE_ONE, used = false, manual = false},
    [2] = {marker = _G.TARGET_MARKER_TYPE_TWO, used = false, manual = false},
    [3] = {marker = _G.TARGET_MARKER_TYPE_THREE, used = false, manual = false},
    [4] = {marker = _G.TARGET_MARKER_TYPE_FOUR, used = false, manual = false},
    [5] = {marker = _G.TARGET_MARKER_TYPE_FIVE, used = false, manual = false},
    [6] = {marker = _G.TARGET_MARKER_TYPE_SIX, used = false, manual = false},
    [7] = {marker = _G.TARGET_MARKER_TYPE_SEVEN, used = false, manual = false}
}

local markerKeys = {1, 2, 3, 4, 5, 6, 7}

local function getMarkerIndex(marker)
    for index, info in ipairs(AH.MARKERS) do
        if (info.marker == marker) then
            return index
        end
    end
end

local function makeMarkerAvailable(marker)
    local index = getMarkerIndex(marker)

    AH.MARKERS[index].used = false
    AH.MARKERS[index].manual = false
end

local function getAvailableMarker()
    -- probably not necessary, but...
    table.sort(markerKeys)

    for _, key in ipairs(markerKeys) do
        if (AH.MARKERS[key].used == false) then
            AH.MARKERS[key].used = true

            return AH.MARKERS[key].marker
        end
    end

    -- all markers used up, reset and start again
    for _, info in pairs(AH.MARKERS) do
        info.used = false
    end

    return _G.TARGET_MARKER_TYPE_ONE
end

local function doChecks()
    local stage, cycle, arc = ENDLESS_DUNGEON_MANAGER:GetProgression()

    AH.GetArchiveQuestIndexes()

    AH.CHECK_MARAUDERS = AH.Vars.MarauderCheck
    AH.CHECK_FABLED = AH.Vars.FabledCheck
    AH.CHECK_SHARDS = false
    AH.CHECK_GW = false

    if (arc == 1) then
        -- no marauders in arc 1
        AH.CHECK_MARAUDERS = false
        if (cycle < 4) then
            -- no fabled before arc 1 cycle 4
            AH.CHECK_FABLED = false
        end
    end

    if (cycle < 5 and stage == 3) then
        -- possible fabled due to one boss, no marauders or shards
        AH.CHECK_FABLED = true and AH.Vars.FabledCheck
        AH.CHECK_MARAUDERS = false
        AH.CHECK_SHARDS = false
        AH.CHECK_GW = true and AH.Vars.GWCheck
    end

    if (cycle == 5 and stage == 3 and arc < 4) then
        -- only get shards in cycle 5, stage 3, up to arc 4, no marauders or fabled
        AH.CHECK_SHARDS = true and AH.Vars.ShardCheck
        AH.CHECK_MARAUDERS = false
        AH.CHECK_FABLED = false
    end

    if ((arc >= 4 and cycle >= 3) and (not AH.ShardIgnore)) then
        -- shards now appear as trash mobs
        AH.CHECK_SHARDS = true and AH.Vars.ShardCheck
    end
end

local function isItDeadDave()
    if (IsUnitDead("reticleover")) then
        local marker = GetUnitTargetMarkerType("reticleover")

        if (marker ~= _G.TARGET_MARKER_TYPE_NONE) then
            makeMarkerAvailable(marker)
        end
    end
end

function AH.FabledCheck()
    local extantMarker = GetUnitTargetMarkerType("reticleover")

    if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
        if (GetUnitName("reticleover"):find(fabledText, 1, true) and not IsUnitDead("reticleover")) then
            local marker = getAvailableMarker()
            AssignTargetMarkerToReticleTarget(marker)
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        local index = getMarkerIndex(extantMarker)

        if ((not GetUnitName("reticleover"):find(fabledText, 1, true)) and (not AH.MARKERS[index].manual)) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            makeMarkerAvailable(extantMarker)
        end
    end
end

function AH.MarauderCheck()
    if (AH.MARAUDER) then
        local extantMarker = GetUnitTargetMarkerType("reticleover")

        if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
            if (GetUnitName("reticleover") == AH.MARAUDER and not IsUnitDead("reticleover")) then
                AssignTargetMarkerToReticleTarget(_G.TARGET_MARKER_TYPE_EIGHT)
            end
        elseif (extantMarker == _G.TARGET_MARKER_TYPE_EIGHT) then
            -- sanity check
            if (not GetUnitName("reticleover") == AH.MARAUDER) then
                AssignTargetMarkerToReticleTarget(extantMarker)
            end
        end
    end
end

function AH.ShardCheck()
    local extantMarker = GetUnitTargetMarkerType("reticleover")

    if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
        if (GetUnitName("reticleover") == shardText and not IsUnitDead("reticleover")) then
            local marker = getAvailableMarker()
            AssignTargetMarkerToReticleTarget(marker)
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        local index = getMarkerIndex(extantMarker)

        if ((GetUnitName("reticleover") ~= shardText) and (not AH.MARKERS[index].manual)) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            makeMarkerAvailable(extantMarker)
        end
    end
end

function AH.GWCheck()
    local extantMarker = GetUnitTargetMarkerType("reticleover")

    if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
        if (GetUnitName("reticleover"):find(gwText, 1, true) and not IsUnitDead("reticleover")) then
            local marker = getAvailableMarker()
            AssignTargetMarkerToReticleTarget(marker)
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        local index = getMarkerIndex(extantMarker)

        if ((not GetUnitName("reticleover"):find(gwText, 1, true)) and (not AH.MARKERS[index].manual)) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            makeMarkerAvailable(extantMarker)
        end
    end
end

-- for keybinds
function AH.MarkCurrentTarget()
    if (GetUnitTargetMarkerType("reticleover") == _G.TARGET_MARKER_TYPE_NONE) then
        local marker = getAvailableMarker()

        AssignTargetMarkerToReticleTarget(marker)
        AH.MARKERS[marker].manual = true
    end
end

function AH.UnmarkCurrentTarget()
    local marker = GetUnitTargetMarkerType("reticleover")

    if (marker ~= _G.TARGET_MARKER_TYPE_NONE) then
        AssignTargetMarkerToReticleTarget(marker)
        makeMarkerAvailable(marker)
    end
end

function AH.CombatCheck(_, incombat)
    local check = AH.Vars.MarauderCheck or AH.Vars.FabledCheck or AH.Vars.ShardCheck or AH.Vars.GWCheck

    if (check and AH.CompatibilityCheck() and AH.InsideArchive) then
        if (not incombat) then
            EVENT_MANAGER:UnregisterForEvent(AH.Name .. "_Fabled", _G.EVENT_COMBAT_EVENT)
            EVENT_MANAGER:UnregisterForEvent(AH.Name, _G.EVENT_RETICLE_TARGET_CHANGED)

            for _, info in pairs(AH.MARKERS) do
                info.used = false
            end

            AH.MARAUDER = nil
        else
            doChecks()

            EVENT_MANAGER:RegisterForEvent(
                AH.Name,
                _G.EVENT_RETICLE_TARGET_CHANGED,
                function()
                    if (AH.InsideArchive) then
                        if (AH.CHECK_FABLED) then
                            AH.FabledCheck()
                        end

                        if (AH.CHECK_MARAUDERS) then
                            AH.MarauderCheck()
                        end

                        if (AH.CHECK_SHARDS) then
                            AH.ShardCheck()
                        end

                        if (AH.CHECK_GW) then
                            AH.GWCheck()
                        end

                        isItDeadDave()
                    end
                end
            )
        end
    end

    AH.InCombet = incombat
end
