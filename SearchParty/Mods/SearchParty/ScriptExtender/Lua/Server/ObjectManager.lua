--[[

ObjectManager - Handles management of objects when hiding

--]]
local om = {
    ['targetItem'] = nil,
    ['tickCount'] = 0,
    ['lastPosition'] = {
        ['x'] = nil,
        ['y'] = nil,
        ['z'] = nil
    },
    ['tickSubscriptionID'] = nil
}

---@param uuid UUID of the entity to get
---@return table|nil transform
local function GetEntityPosition(uuid)
    local entity = Ext.Entity.Get(uuid)
    if entity then
        return entity.Transform.Transform.Translate
    else
        SearchParty.Critical('Error getting entity for ' .. uuid)
    end
end

---@param target UUID
---@param hostCharPosition table
local function SetTargetPositionToCasterPosition(targetItem, hostCharPosition)
    SearchParty.Info('Setting object position to ' ..
        hostCharPosition[1] .. ', ' .. hostCharPosition[2] .. ',' .. hostCharPosition[3])
    Osi.ToTransform(
        targetItem,
        hostCharPosition[1],
        hostCharPosition[2],
        hostCharPosition[3],
        0,
        0,
        0
    )
    om.targetItem     = targetItem
    om.lastPosition.x = hostCharPosition[1]
    om.lastPosition.y = hostCharPosition[2]
    om.lastPosition.z = hostCharPosition[3]
end

local function UnsubscribeToMovement()
    if om.tickSubscriptionID then
        SearchParty.Info('Unsubscribing to ' .. om.tickSubscriptionID)
        Ext.Entity.Unsubscribe(om.tickSubscriptionID)
    end
end

local function HasMoved(x, y, z)
    return x ~= om.lastPosition.x and
        y ~= om.lastPosition.y and
        z ~= om.lastPosition.z
end

--[[
Watch movement every few ticks and synchronize position to the
character hiding
---@param target target UUID
--]]
local function WatchMovementAndUpdatePosition(options)
    UnsubscribeToMovement()

    local hostCharPosition = GetEntityPosition(Osi.GetHostCharacter())

    if options.immediateUpdate and hostCharPosition then
        SetTargetPositionToCasterPosition(options.target, hostCharPosition)
    end

    om.tickSubscriptionID = Ext.Events.Tick:Subscribe(function(e)
        om.tickCount = om.tickCount + 1

        if (om.tickCount >= 2) then
            -- Need to continously check position in here for latest value
            hostCharPosition = GetEntityPosition(Osi.GetHostCharacter())
            if hostCharPosition then
                if HasMoved(hostCharPosition[1], hostCharPosition[2], hostCharPosition[3]) then
                    SetTargetPositionToCasterPosition(options.target, hostCharPosition)
                    om.tickCount = 0
                end
            else
                SearchParty.Critical('Failed to get host character position')
            end
        end
    end)
end

--om.SetTargetPositionToCasterPosition = SetTargetPositionToCasterPosition
om.UnsubscribeToMovement = UnsubscribeToMovement
om.WatchMovementAndUpdatePosition = WatchMovementAndUpdatePosition
SearchParty.ObjectManager = om
