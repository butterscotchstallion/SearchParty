local spellManager = {
    ['addedSpells'] = false
}

function spellManager.AddSpells()
    local spells = {
        "Target_SP_Transform"
    }
    for _, spellName in pairs(spells) do
        Osi.AddSpell(Osi.GetHostCharacter(), spellName, 1)
    end
    spellManager['addedSpells'] = true
    SearchParty['Info']("Added spells")
end

SearchParty['SpellManager'] = spellManager
