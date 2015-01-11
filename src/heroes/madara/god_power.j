scope GodPower
    
    define private isSusanoMadara(targetTypeId) = (targetTypeId == 'o00L' || targetTypeId == 'o00N' || targetTypeId == 'o00O')
    
    public void onDamage(unit target,unit source,real damage){
        int targetTypeId = GetUnitTypeId(target);
        
        if ( isSusanoMadara(targetTypeId) )
        {
            if ( IsUnitType(source, UNIT_TYPE_HERO) )
            {
                float targetLife = GetWidgetLife(target) - 1;
                
                if ( targetLife <= 0 )
                {
                    SetHandleBoolean(GetHandleId(target), "GodPower|killed", true);
                    KillUnit(target);
                }
                else
                {
                    Damage_Block(RAbsBJ(damage) - 1);
                }
            }
            else
            {
                Damage_Block(RAbsBJ(damage));
            }
        }        
    }
    
    public function Loop takes nothing returns nothing
        local timer t=GetExpiredTimer()
        local integer id=GetHandleId(t)
        local unit d=GetHandleUnit(id,"d")
        local unit u=GetHandleUnit(id,"u")
        local integer i=GetHandleInt(id,"i")+1
        local real x=GetUnitX(d)
        local real y=GetUnitY(d)
        local real r=GetRandomReal(0,1300)
        local real a=GetRandomReal(0,bj_PI*2)
        call SetWidgetLife(u,GetHandleReal(id,"hp"))
        call SetUnitState(u,UNIT_STATE_MANA,GetHandleReal(id,"mp"))
        call SetHandleInt(id,"i",i)
        call AddSpecialEffectTimed(AddSpecialEffect("Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl",x+r*Cos(a),y+r*Sin(a)),(6*20-i)/20)
        if Mod(i,10) then
            call SetUnitAnimation(d,"Spell Channel")
            call UnitDamageArea(u,x,y,1300,(10+20*GetUnitAbilityLevel(u,'A0KC'))/2,DAMAGE_SPELL,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl")
        endif
        if i==100 then
            set d=NewFX("Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl",x,y,2000,0,3)
            call SetUnitFlyHeight(d,0,2000)
            call SetHandleHandle(id,"w",d)
        endif
        set d=null
        set u=null
        set t=null
    endfunction
    
    public function onSpell takes nothing returns boolean
        local unit u=GetTriggerUnit()
        local real x=GetUnitX(u)
        local real y=GetUnitY(u)
        local real a=GetUnitFacing(u)
        local player p=GetTriggerPlayer()
        local timer t=NewTimer()
        local integer idt=GetHandleId(t)
        local integer idd
        local integer n=GetUnitAbilityLevel(u,'A0KD')
        local integer i
        local unit d
        call DestroyEffect(AddSpecialEffect("GaaraVolcanoDeath.mdx",x,y))
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl",x,y))
        call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)-200)
        call RemoveProjectiles(u)
        call PauseUnit(u,true)
        call SetUnitPathing(u,false)
        call SetUnitInvulnerable(u,false)
        call ShowUnit(u,false)
        if n==1 then
            set i='o00L'
        elseif n==2 then
            set i='o00N'
        else
            set i='o00O'
        endif
        set d=CreateUnit(p,i,x,y,a)
        set idd=GetHandleId(d)
        call SetUnitAnimation(d,"Spell Channel")
        call SetUnitX(d,x)
        call SetUnitY(d,y)
        if GetUnitAbilityLevel(u,'A0KC')>0 then
            call AddAbility(d,'A0KE')
            call SetHandleInt(idd,"MRinnegan|n",GetUnitAbilityLevel(u,'A0KC'))
        endif
        call SelectUnitForPlayerSingle(d,p)
        call UnitApplyTimedLife(d,'BTLF',6)
        call SetHandleHandle(idd,"GodPower|t",t)
        call SetHandleHandle(idt,"d",d)
        call SetHandleHandle(idt,"u",u)
        call SetHandleReal(idt,"hp",GetWidgetLife(u))
        call SetHandleReal(idt,"mp",GetUnitState(u,UNIT_STATE_MANA))
        call TimerStart(t,0.05,true,function Loop)
        set t=null
        set d=null
        set u=null
        return false
    endfunction
    
    public function onDeath takes nothing returns boolean
        local unit d=GetTriggerUnit()
        local unit u
        local timer t
        local integer n=GetUnitTypeId(d)
        local integer idd
        local integer idt
        if n=='o00L' or n=='o00N' or n=='o00O' then
            set idd=GetHandleId(d)
            set t=GetHandleTimer(idd,"GodPower|t")
            set idt=GetHandleId(t)
            set u=GetHandleUnit(idt,"w")
            if u!=null then
                call RemoveFX(u,0)
            endif
            set u=GetHandleUnit(idt,"u")
            call ReleaseTimer(t)
            if GetHandleBoolean(idd,"GodPower|killed")==false then
                set n=GetUnitAbilityLevel(u,'A0KD')
                call NewFXT("war3mapImported\\NewDirtEXNofire.mdx",GetUnitX(d),GetUnitY(d),0,0,5,1)
                call UnitDamageStunArea(u,GetUnitX(d),GetUnitY(d),1300,20+n,DAMAGE_SPELL,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",2.5)
            endif
            call Clear(d)
            call RemoveUnit(d)
            call ShowUnit(u,true)
            call PauseUnit(u,false)
            call SetUnitInvulnerable(u,false)
            call SetUnitPathing(u,true)
            call SelectUnitForPlayerSingle(u,GetTriggerPlayer())
            set u=null
            set t=null
        endif
        set d=null
        return false
    endfunction

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('A0KD',function onSpell)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DEATH,function onDeath)
        call Damage_Register(onDamage)
    endfunction
endscope