scope SymbioticRelationship{

    define{
        private ID = 'A0KU'
        private DURATION = 5
        private HEALTH_BONUS(LVL) = (5+15*LVL)
        private HEALTH(LVL) = (5+10*LVL)
    }
    
    private nothing onExpire(){
        timer t=GetExpiredTimer()
        integer h=GetHandleId(t)
        unit u=GetUnit(h,1)
        real hp=GetWidgetLife(u)
        integer lvl=GetUnitAbilityLevel(u,ID)
        // Effects
        if(hp<=0.4*MaxHp(u)){
            hp+=HEALTH_BONUS(lvl)
        } else {
            hp+=HEALTH(lvl)
        }
        call SetWidgetLife(u,hp)
        // END
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
        // TABLE
        SetInt(h,0,DURATION)
        SetUnit(h,1,GetTriggerUnit())
        // START
        call TimerStart(t,1,true,function onExpire)
        // LEAKS
        t=null
        return false
    }

    public nothing Init(){
        SpellReg(ID)
    }
}