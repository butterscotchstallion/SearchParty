--[[

Event handling

--]]

local function PrintVersionMessage()
    local mod = Ext.Mod.GetMod(ModuleUUID)
    if mod then
        local version    = mod.Info.ModVersion
        local versionMsg = string.format(
            'SearchParty v%s.%s.%s',
            version[1],
            version[2],
            version[3]
        )
        SearchParty.Info(versionMsg)
    end
end

local function OnSessionLoaded()
    PrintVersionMessage()
end

local function OnHide()
    Osi.PROC_GLO_Monitor_EntityFoop(Osi.GetHostCharacter())
end

local function OnCastedTargetSpell(caster, target, spell, spellType, spellElement, storyActionID)
    if spell == 'Target_SP_Transform' then
        OnHide()

        --[[
        local targetEntity = Ext.Entity.Get(target)
        --%localappdata%\Larian Studios\Baldur's Gate 3\Script Extender
        Ext.IO.SaveFile(target .. ".json", Ext.DumpExport(targetEntity:GetAllComponents()))
        SearchParty['Info']('Saved target entity to file')
        --]]

        --local hostCharPosition = SearchParty.ObjectManager.GetEntityPosition(Osi.GetHostCharacter())
        --SearchParty.ObjectManager.SetTargetPositionToCasterPosition(target, hostCharPosition)
        SearchParty.ObjectManager.WatchMovementAndUpdatePosition(target)
    end
end

--Listeners
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", OnCastedTargetSpell)
