--[[

Event handling

--]]
local function OnSessionLoaded()
    SearchParty.Utils.PrintVersionMessage()
end

local function OnHide(targetUUID)
    Osi.PROC_GLO_Monitor_EntityFoop(Osi.GetHostCharacter())

    if SearchParty.ObjectManager.targetItemUUID == targetUUID then
        SearchParty.ObjectManager.StopSynchronizingPosition(targetUUID)
    else
        SearchParty.Info('Pretending to be a ' .. targetUUID)

        SearchParty.ObjectManager.WatchMovementAndUpdatePosition({
            ['targetUUID']      = targetUUID,
            ['immediateUpdate'] = true
        })
    end
end

local function OnCastedTargetSpell(caster, target, spellName, spellType, spellElement, storyActionID)
    if spellName == SearchParty.SpellManager.transformSpellName then
        OnHide(target)
    end
end

local function OnLevelGameplayStarted(levelName, isEditorMode)
    SearchParty.Info('Level gameplay started')

    local hostEntity = Ext.Entity.Get(Osi.GetHostCharacter())
    Ext.Entity.Subscribe("Health", function(c)
        SearchParty.Info("HP changed!")
        _D(c.Health)
    end, hostEntity)
end

--Listeners
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", OnCastedTargetSpell)
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", OnLevelGameplayStarted)
