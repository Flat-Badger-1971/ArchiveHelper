local AH = _G.ArchiveHelper
local fabledText = GetString(_G.ARCHIVEHELPER_FABLED)
local shardText = GetString(_G.ARCHIVEHELPER_SHARD)
-- local cache for performance
local GetUnitName, GetUnitTargetMarkerType = GetUnitName, GetUnitTargetMarkerType
local IsUnitDead, AssignTargetMarkerToReticleTarget = IsUnitDead, AssignTargetMarkerToReticleTarget

AH.MARKERS = {
    [_G.TARGET_MARKER_TYPE_ONE] = false,
    [_G.TARGET_MARKER_TYPE_TWO] = false,
    [_G.TARGET_MARKER_TYPE_THREE] = false,
    [_G.TARGET_MARKER_TYPE_FOUR] = false,
    [_G.TARGET_MARKER_TYPE_FIVE] = false,
    [_G.TARGET_MARKER_TYPE_SIX] = false,
    [_G.TARGET_MARKER_TYPE_SEVEN] = false
}

local function getAvailableMarker()
    for marker, used in pairs(AH.MARKERS) do
        if (not used) then
            return marker
        end
    end

    -- all makers used up, reset and start again
    for marker, _ in pairs(AH.MARKERS) do
        AH.MARKERS[marker] = false
    end

    return _G.TARGET_MARKER_TYPE_ONE
end

local function doChecks()
    local stage, cycle, arc = ENDLESS_DUNGEON_MANAGER:GetProgression()

    AH.GetArchiveQuestIndexes()

    AH.CHECK_MARAUDERS = AH.Vars.MarauderCheck
    AH.CHECK_FABLED = AH.Vars.FabledCheck
    AH.CHECK_SHARDS = false

    if (arc == 1) then
        -- no marauders in arc 1
        AH.CHECK_MARAUDERS = false
        if (cycle < 4) then
            -- no fabled before arc 1 cycle 4
            AH.CHECK_FABLED = false
        end
    end

    if (cycle < 5 and stage == 3) then
        -- possbile fabled due to one boss, no marauders or shards
        AH.CHECK_FABLED = true and AH.Vars.FabledCheck
        AH.CHECK_MARAUDERS = false
        AH.CHECK_SHARDS = false
    end

    if (cycle == 5 and stage == 3 and arc < 4) then
        -- only get shards in cycle 5, stage 3, up to arc 4, no marauders or fabled
        AH.CHECK_SHARDS = true and AH.Vars.ShardCheck
        AH.CHECK_MARAUDERS = false
        AH.CHECK_FABLED = false
    end

    if (arc >= 4 and cycle >= 3) then
        -- shards now appear as trash mobs
        AH.CHECK_SHARDS = true and AH.Vars.ShardCheck
    end
end


local function isItDeadDave()
    if (IsUnitDead("reticleover")) then
        local marker = GetUnitTargetMarkerType("reticleover")

        if (marker ~= _G.TARGET_MARKER_TYPE_NONE) then
            AH.MARKERS[marker] = true
        end
    end
end

function AH.FabledCheck()
    local extantMarker = GetUnitTargetMarkerType("reticleover")

    if (extantMarker == _G.TARGET_MARKER_TYPE_NONE) then
        if (GetUnitName("reticleover"):find(fabledText) and not IsUnitDead("reticleover")) then
            local marker = getAvailableMarker()
            AssignTargetMarkerToReticleTarget(marker)
            AH.MARKERS[marker] = true
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        if (not GetUnitName("reticleover"):find(fabledText)) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            AH.MARKERS[extantMarker] = false
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
            AH.MARKERS[marker] = true
        end
    elseif (extantMarker ~= _G.TARGET_MARKER_TYPE_EIGHT) then
        -- sanity check
        if (GetUnitName("reticleover") ~= shardText) then
            AssignTargetMarkerToReticleTarget(extantMarker)
            AH.MARKERS[extantMarker] = false
        end
    end
end

function AH.CombatCheck(_, incombat)
    if
        ((AH.Vars.MarauderCheck or AH.Vars.FabledCheck or AH.ShardCheck) and AH.CompatibilityCheck() and
            AH.InsideArchive)
     then
        if (not incombat) then
            EVENT_MANAGER:UnregisterForEvent(AH.Name .. "_Fabled", _G.EVENT_COMBAT_EVENT)
            EVENT_MANAGER:UnregisterForEvent(AH.Name, _G.EVENT_RETICLE_TARGET_CHANGED)

            for marker, _ in pairs(AH.MARKERS) do
                AH.MARKERS[marker] = false
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

                        isItDeadDave()
                    end
                end
            )
        end
    end

    AH.InCombet = incombat
end