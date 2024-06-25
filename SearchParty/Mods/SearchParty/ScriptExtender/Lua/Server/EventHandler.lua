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
        SearchParty['Info'](versionMsg)
    end
end

local function OnSessionLoaded()
    PrintVersionMessage()
end

---@param levelName string
local function OnEnteredLevel(levelName, _, _)
    SearchParty['Info']("Entered Level " .. levelName)
    SearchParty['SpellManager'].AddSpells()
end

--Listeners
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Osiris.RegisterListener('EnteredLevel', 3, 'after', OnEnteredLevel)
