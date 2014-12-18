scope SamehadaFeasts
{
    define{
        private ID             = 'A0KV'
        private MANA_BURN(lvl) = 0.07*lvl
        private EFFECT         = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl"
        private ATTACH         = "origin"
    }
    
    private boolean onCast(){
        unit u = GetTriggerUnit()
        real mp = 0
        GroupEnumUnitsInRange(ENUM,GetUnitX(u),GetUnitY(u),250,null)
        loop
            exitwhen LoopNull()
            if(UnitFilterEx(enumUnit,GetTriggerPlayer())){
                if(isKyuubi(enumUnit)){
                    BlueText(enumUnit, "No effect!")
                } else {
                    real burnMana = GetUnitState(enumUnit,UNIT_STATE_MAX_MANA)*MANA_BURN(GetUnitAbilityLevel(u,ID))
                    if(burnMana > 0){
                        Damage_Spell(u, enumUnit, burnMana)
                        removeMp(enumUnit,burnMana)
                        mp += burnMana/2
                        ManaBurn(enumUnit,(R2I(burnMana)),false)
                        timedEffect(enumUnit,EFFECT,0.5,ATTACH)
                    }
                }
            }
        endloop
        //addMp(u,mp) --> nope, this doesn't work
        addMpDelayed(u,mp)
        u = null
        return false
    }

    public nothing Init(){
        SpellReg(ID)
    }
}