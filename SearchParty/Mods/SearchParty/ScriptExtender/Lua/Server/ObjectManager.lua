--[[

ObjectManager - Handles management of objects when hiding

--]]
local om = {
    ['targetUUID']         = nil,
    ['tickCount']          = 0,
    ['lastPosition']       = {
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

local function UnsubscribeToMovement()
    if om.tickSubscriptionID then
        SearchParty.Info('Unsubscribing to ' .. om.tickSubscriptionID)
        Ext.Entity.Unsubscribe(om.tickSubscriptionID)
    end
end

---@param target UUID
---@param hostCharPosition table
local function SetTargetPositionToCasterPosition(targetUUID, hostCharPosition)
    --[[
    SearchParty.Info('Setting object position to ' ..
        hostCharPosition[1] .. ', ' .. hostCharPosition[2] .. ',' .. hostCharPosition[3])
    --]]
    -- Clear item if we use it on the same item
    if om.targetItemUUID and targetUUID == om.targetItemUUID then
        SearchParty.Info('Clearing item')
        om.targetItemUUID = nil
    else
        SearchParty.Info('Pretending to be a ' .. targetUUID)

        Osi.ToTransform(
            targetUUID,
            hostCharPosition[1],
            hostCharPosition[2],
            hostCharPosition[3],
            0,
            0,
            0
        )
        om.targetItemUUID = targetUUID
        om.lastPosition.x = hostCharPosition[1]
        om.lastPosition.y = hostCharPosition[2]
        om.lastPosition.z = hostCharPosition[3]
    end
end

---@param x integer
---@param y integer
---@param z integer
---@return boolean
local function HasMoved(x, y, z)
    return x ~= om.lastPosition.x and
        y ~= om.lastPosition.y and
        z ~= om.lastPosition.z
end

--[[
Watch movement every few ticks and synchronize position to the
character hiding
--]]
---@param options table
local function WatchMovementAndUpdatePosition(options)
    if options.targetUUID or om.targetUUID then
        local tickSubscriptionID = nil

        --When the tick count hits or exceeds this value, update position of object
        local tickInterval = 1
        local hostCharPosition = GetEntityPosition(Osi.GetHostCharacter())

        --On first activation, immediately set position
        if options.immediateUpdate and hostCharPosition then
            SetTargetPositionToCasterPosition(options.targetUUID, hostCharPosition)
        end

        tickSubscriptionID = Ext.Events.Tick:Subscribe(function(e)
            om.tickCount = om.tickCount + 1

            if (om.tickCount >= tickInterval) then
                -- Need to continously check position in here for latest value
                hostCharPosition = GetEntityPosition(Osi.GetHostCharacter())
                if hostCharPosition then
                    if HasMoved(hostCharPosition[1], hostCharPosition[2], hostCharPosition[3]) then
                        SetTargetPositionToCasterPosition(options.targetUUID, hostCharPosition)
                        om.tickCount = 0
                    end
                else
                    SearchParty.Critical('Failed to get host character position')
                end
            end
        end)

        om.tickSubscriptionID = tickSubscriptionID
    end
end

om.UnsubscribeToMovement          = UnsubscribeToMovement
om.WatchMovementAndUpdatePosition = WatchMovementAndUpdatePosition
SearchParty.ObjectManager         = om
