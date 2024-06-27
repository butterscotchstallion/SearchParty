local utils = {}

local function SaveEntityToFile(targetName, entity)
    --%localappdata%\Larian Studios\Baldur's Gate 3\Script Extender
    local filename = targetName .. ".json"
    Ext.IO.SaveFile(filename, Ext.DumpExport(entity:GetAllComponents()))
    SearchParty.Info('Saved target entity to %localappdata%\\Larian Studios\\Baldur\'s Gate 3\\Script Extender\\' ..
        filename)
end

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

utils.SaveEntityToFile = SaveEntityToFile
utils.PrintVersionMessage = PrintVersionMessage
SearchParty.Utils = utils
