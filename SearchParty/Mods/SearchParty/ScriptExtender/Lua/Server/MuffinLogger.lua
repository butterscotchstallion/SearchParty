local muffinLogger = {}
local logPrefix    = '[SearchParty]'
local logLevel     = SearchParty['logLevel']
local COLORS       = {
    ["magentaStart"] = "\033[33",
    ["end"]          = "[0m"
}

--The annotations for the print functions are NYI
---@param message string
---@param level string
function muffinLogger.Log(message, level)
    local fmtMsg = string.format('%s[%s] %s', logPrefix, level, message)
    if level == 'CRITICAL' then
        Ext.Utils.PrintError(fmtMsg)
    elseif level == 'WARN' then
        Ext.Utils.PrintWarning(fmtMsg)
    elseif level == 'INFO' or level == 'DEBUG' or not level then
        _P(fmtMsg)
    end
end

---@param message string
function muffinLogger.Debug(message)
    if logLevel == 'DEBUG' then
        muffinLogger.Log(message, 'DEBUG')
    end
end

---@param message string
function muffinLogger.Info(message)
    muffinLogger.Log(message, 'INFO')
end

---@param message string
function muffinLogger.Warn(message)
    muffinLogger.Log(message, 'WARN')
end

---@param message string
function muffinLogger.Critical(message)
    muffinLogger.Log(message, 'CRITICAL')
end

SearchParty['log']      = muffinLogger
--Shortcuts
SearchParty['Debug']    = muffinLogger.Debug
SearchParty['Info']     = muffinLogger.Info
SearchParty['Warn']     = muffinLogger.Warn
SearchParty['Critical'] = muffinLogger.Critical