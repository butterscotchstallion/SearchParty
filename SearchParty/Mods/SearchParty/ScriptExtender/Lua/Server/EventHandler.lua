--[[

Event handling

--]]
local function OnSessionLoaded()
    SearchParty.Utils.PrintVersionMessage()
end

local function OnHide(targetUUID)
    Osi.PROC_GLO_Monitor_EntityFoop(Osi.GetHostCharacter())

    if not SearchParty.ObjectManager.targetItemUUID then
        SearchParty.Info('Pretending to be a ' .. targetUUID)

        SearchParty.ObjectManager.WatchMovementAndUpdatePosition({
            ['targetUUID']      = targetUUID,
            ['immediateUpdate'] = true
        })
    elseif SearchParty.ObjectManager.targetItemUUID == targetUUID then
        SearchParty.ObjectManager.StopSynchronizingPosition(targetUUID)
    end
end

local function OnCastedTargetSpell(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == SearchParty.SpellManager.transformSpellName then
        OnHide(target)
    end
end

--Listeners
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", OnCastedTargetSpell)
