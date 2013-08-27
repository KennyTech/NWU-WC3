scope WaterBubble{

    define{
        private ID          = 'A029'
        private AURA        = 'A028'
        private MORPH       = 'O004'
        private BUFF        = 'BEme'
        private DAMAGE(lvl) = 5+15*lvl
        private AOE         = 375
        private SLOW_BUFF   = 'B03Z'
    }
    
    private unit Kisame
    
    private nothing delay(){
        unit u=GetUnit(GetHandleId(GetExpiredTimer()),0)
        SetUnitAbilityLevel(u,AURA,GetUnitAbilityLevel(u,ID))
        ReleaseTimerEx()
        u=null
    }
    
    private nothing onExpire(){
        timer t=GetExpiredTimer()
        unit Caster=GetUnit(GetHandleId(t),0)
        call UnitDamageArea(Caster, GetUnitX(Caster),GetUnitY(Caster),AOE,DAMAGE(GetUnitAbilityLevel(Caster,ID)), DAMAGE_SPELL, null)
        if(GetUnitAbilityLevel(Caster,'BEme')==0){
            ReleaseTimerEx()
        }
        t=null
        Caster=null
    }
    
    private boolean onCast(){
        unit u=GetTriggerUnit()
        if(GetUnitTypeId(u)==MORPH){
            Kisame=u
            timer t=NewTimer()
            integer h=GetHandleId(t)
            SetUnit(h,0,u)
            TimerStart(t,1,true,function onExpire)
            t=NewTimer()
            SetUnit(h,0,u)
            TimerStart(t,0.1,false,function delay)
            t=null
        }
        u=null
        return false
    }
    
    define MANA_REMOVE(lvl) = 0.1+0.05*lvl
    
    private nothing onDamage(unit source,unit target,real damage){
        if( GetUnitAbilityLevel(target,SLOW_BUFF) > 0 && IsUnitEnemy(Kisame,GetOwningPlayer(target)) ){
            real mana=RAbsBJ(damage)*MANA_REMOVE(GetUnitAbilityLevel(Kisame,ID))
            addMp(Kisame,mana)
            removeMp(target,mana)
        }
    }

    public nothing Init(){
        SpellReg(ID)
        RegisterDamageResponse(onDamage)
    }
}