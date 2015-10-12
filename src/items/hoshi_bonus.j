scope HoshikageSpellBonus initializer init

    private function onDamage takes unit damagedUnit, unit damageSource, real damage returns nothing
        local integer item_count = GetInventoryIndexOfItemTypeBJ(damageSource, 'I04C')
        local real bonus         = 0.20
        if Damage_IsSpell() and item_count > 0 then
            call Damage_Spell(damageSource,damagedUnit,damage*bonus)
        endif
    endfunction

    private function init takes nothing returns nothing
        call RegisterDamageResponse(onDamage)
    endfunction
    
endscope
