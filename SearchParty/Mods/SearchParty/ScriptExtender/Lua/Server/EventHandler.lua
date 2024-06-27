--[[

Event handling

--]]
local function OnSessionLoaded()
    SearchParty.Utils.PrintVersionMessage()
end

local function OnHide(targetUUID)
    Osi.PROC_GLO_Monitor_EntityFoop(Osi.GetHostCharacter())
    SearchParty.ObjectManager.WatchMovementAndUpdatePosition(targetUUID)
end

local function OnCastedTargetSpell(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == SearchParty.SpellManager.transformSpellName then
        OnHide(target)
    end
end

--Listeners
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", OnCastedTargetSpell)
