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

/* Will cause future spell damages (the amplify part) to activate on-attack abilities (ie Sasuke's Passive).
This means with Hoshikage passive power, Sasuke can use [W] and sometimes it will automatically instantly activate [R].
LINE 27: Damage_IsAttack() gets activated sometimes, I added Damage_IsPhysical() part which did not fix it.
I also diagnosed HoshikageSpellBonus to display the amplified damage it's negative as spell damage should be).
Should I change DSChokuto to activate if damage is negative? (damage < 0)

scope DSChokuto

    private function onDamage takes unit target, unit caster, real damage returns nothing
        local unit dummy
        if GetUnitAbilityLevel(caster,'A085')>0 and Damage_IsAttack() and Damage_IsPhysical() and IsUnitType(target, UNIT_TYPE_STRUCTURE)==false and IsUnitEnemy(caster, GetOwningPlayer(target)) and GetLastTarget(caster)==target then
            call UnitRemoveAbility(caster,'A085')
            set dummy = CreateUnit(GetOwningPlayer(caster),'e00L',GetUnitX(target),GetUnitY(target),0)
            call UnitAddAbility(dummy,'A09C')
            call SetUnitAbilityLevel(dummy,'A09C',GetUnitAbilityLevel(caster,'A003'))
            call IssueImmediateOrder(dummy,"thunderclap")
            call UnitApplyTimedLife(dummy,'BTLF',2)
            set dummy = null
        endif
    endfunction

    public function Init takes nothing returns nothing
        call RegisterDamageResponse(onDamage)
    endfunction
    
    */
