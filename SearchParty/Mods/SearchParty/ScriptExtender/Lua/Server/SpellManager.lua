local spellManager = {}

function spellManager.AddSpells()
    local spells = {
        "Target_SP_Transform"
    }
    for _, spellName in pairs(spells) do
        Osi.AddSpell(Osi.GetHostCharacter(), spellName, 1)
    end
    SearchParty['Info']("Added spells")
end

SearchParty['SpellManager'] = spellManager
