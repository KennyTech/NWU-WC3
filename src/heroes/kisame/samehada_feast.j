scope SamehadaFeasts
{
    define{
        private ID             = 'A0KV'
        private MANA_BURN(lvl) = 0.07*lvl
        private EFFECT         = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl"
        private ATTACH         = "origin"
    }
    
    private boolean onCast(){
        unit u=GetTriggerUnit()
        GroupEnumUnitsInRange(ENUM,GetUnitX(u),GetUnitY(u),250,null)
        loop
            exitwhen LoopNull()==true
            if(UnitFilterEx(enumUnit,GetTriggerPlayer())){
                real maxMana = GetUnitState(enumUnit,UNIT_STATE_MAX_MANA)*MANA_BURN(GetUnitAbilityLevel(u,ID))
                if maxMana > 0 then
                    call Damage_Spell(u,enumUnit,maxMana)
                    call removeMp(enumUnit,maxMana)
                    call ManaBurn(enumUnit,(R2I(maxMana)),false)
                    timedEffect(enumUnit,EFFECT,0.5,ATTACH)
                endif
            }
        endloop
        u=null
        return false
    }

    public nothing Init(){
        SpellReg(ID)
    }
}