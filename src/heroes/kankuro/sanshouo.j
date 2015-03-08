scope Sanshouuo

    define
        private PUPPET_ID       = 'o00M'
        private AOE             = 900
        private PROTECTION_BUFF = 'B033'
        private ABIL_ID         = 'A082'
    enddefine

    private boolean onCast(){
        unit caster = GetTriggerUnit()
        unit puppet = CreateUnit(GetTriggerPlayer(), PUPPET_ID, GetSpellTargetX(), GetSpellTargetY(), GetUnitFacing(caster))
        integer lvl = GetUnitAbilityLevel(caster, ABIL_ID)
        call UnitApplyTimedLife(puppet,'BTLF', 3+2*lvl)
        call SetUnitAnimation(puppet,"spell TWO")
        call SetUnitMaxState(puppet, UNIT_STATE_MAX_LIFE, R2I(GetUnitState(puppet,UNIT_STATE_MAX_LIFE))+(400*lvl)+(150*GetUnitAbilityLevel(caster, 'A07K')))
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl",GetUnitX(puppet),GetUnitY(puppet)))
        caster=null
        puppet=null
        return false
    }
    
    private void onDamage(unit target,unit source,real damage){
        if(GetUnitAbilityLevel(target, PROTECTION_BUFF) > 0){

            call Damage_BlockAll()

            // Search puppet and damage it

            boolean found = false

            call GroupEnumUnitsInRange(ENUM, GetUnitX(target), GetUnitY(target), AOE, null)

            loop
                unit puppet = FirstOfGroup(ENUM)
                exitwhen puppet == null
                call GroupRemoveUnit(ENUM, puppet)
                if(GetUnitTypeId(puppet) == PUPPET_ID && isUnitAlive(puppet) && !IsUnitHidden(puppet)){
                    found = true
                    call Damage_Pure(source, puppet, RAbsBJ(damage))
                }
            endloop

            if(!found){
                call UnitRemoveAbility(target, PROTECTION_BUFF)
            }

            puppet = null
        }
    }

    private boolean onDeath(){
        unit puppet = GetTriggerUnit()
        if(GetUnitTypeId(puppet) == PUPPET_ID){
            real x = GetUnitX(puppet)
            real y = GetUnitY(puppet)
            call GroupEnumUnitsInRange(ENUM, x, y, 3000, null)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl", x, y))
            loop
                unit target = FirstOfGroup(ENUM)
                exitwhen target == null
                call UnitRemoveAbility(target, PROTECTION_BUFF)
                call GroupRemoveUnit(ENUM, target)
            endloop
            call ShowUnit(puppet, false)
        }
        puppet = null
        return false
    }

    public void Init(){
        call GT_RegisterSpellEffectEvent(ABIL_ID, function onCast)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DEATH, function onDeath)
        call Damage_Register(onDamage)
    }

endscope