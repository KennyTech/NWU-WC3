scope SymbioticRelationship{

    define{
        private ID = 'A0KU'
        private DURATION = 5
        private HEALTH_BONUS(LVL) = (5+15*LVL)
        private HEALTH(LVL) = (5+10*LVL)
        private ARMOR_BONUS(LVL) = 1+LVL
    }
    
    private nothing onExpire(){
        timer t=GetExpiredTimer()
        integer h=GetHandleId(t)
        unit u=GetUnit(h,1)
        integer lvl=GetUnitAbilityLevel(u,ID)
        // Effects
        if(GetHp(u)<=0.4*MaxHp(u)){
            addHp(u,HEALTH_BONUS(lvl))
        } else {
            addHp(u,HEALTH(lvl))
        }
        // End condition
        if(GetIntDec(h,0)==0){
            ReleaseTimerEx()
        }
        // LEAKS
        t=null
        u=null
    }

    private boolean onCast(){
        timer t=NewTimer()
        integer h=GetHandleId(t)
        unit caster=GetTriggerUnit()
        // Armor bonus
        AddBonusTimed(caster,BONUS_TYPE_ARMOR,ARMOR_BONUS(GetUnitAbilityLevel(caster,ID)),DURATION)
        // TABLE
        SetInt(h,0,DURATION)
        SetUnit(h,1,caster)
        // START
        TimerStart(t,1,true,function onExpire)
        // LEAKS
        t=null
        return false
    }

    public nothing Init(){
        SpellReg(ID)
    }
}