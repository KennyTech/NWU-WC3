library Effect requires TimerUtils,Status1

    globals
        public unit U
    endglobals

    //================================================================
        public function AEFT takes nothing returns nothing
            local timer t=GetExpiredTimer()
            call DestroyEffect(GetHandleEffect(GetHandleId(t),"e"))
            call ReleaseTimer(t)
            set t=null
        endfunction
        
        public function AFTU takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local real r=GetHandleReal(id,"aftu|time")-0.1
            local unit u=GetTimerUnit()
            if r <= 0 or IsUnitType(u,UNIT_TYPE_DEAD) then
                call DestroyEffect(GetHandleEffect(id,"aftu|sfx"))
                call ReleaseTimer(t)
            else
                call SetHandleReal(id,"aftu|time",r)
            endif
            set t = null
            set u = null
        endfunction
        
        public function RFX takes nothing returns nothing
            local unit u=GetTimerUnit()
            call Clear(u)
            call RemoveUnit(u)
            call ReleaseTimerEx()
            set u = null
        endfunction
        
        public function Remove takes unit u returns nothing
            local integer id=GetHandleId(u)
            local effect e=GetHandleEffect(id,"effect|sfx")
            if e != null then
                call DestroyEffect(e)
                call RemoveHandle(id,"effect|sfx")
                set e = null
            endif
        endfunction
        
        public function NFXT takes nothing returns nothing
            call Remove(GetTimerUnit())
            call ReleaseTimerEx()
        endfunction
    //================================================================
    
    function NewFX takes string s,real x,real y,real z,real a,real scale returns unit
        set U = CreateUnit(Player(15),'e00L',x,y,a*bj_RADTODEG)
        call UnitAddAbility(U,'Aloc')
        call UnitAddAbility(U,'Amrf')
        call UnitRemoveAbility(U,'Amrf')
        call SetUnitScale(U,scale,scale,scale)
        call SetUnitFlyHeight(U,z,0)
        if s != "" then
            call SetHandleHandle(GetHandleId(U),"effect|sfx",AddSpecialEffectTarget(s,U,"origin"))
        endif
        return U
    endfunction
    
    function RemoveFX takes unit u,real time returns nothing
        call Remove(u)
        if time==0 then
            call Clear(u)
            call RemoveUnit(u)
        else
            call TimerStart(NewTimerUnit(u),time,false,function RFX)
        endif
        set u = null
    endfunction
    
    function NewFXT takes string s,real x,real y,real z,real a,real scale,real time returns nothing
        call TimerStart(NewTimerUnit(NewFX(s,x,y,z,a,scale)),time,false,function NFXT)
    endfunction

    function AddSpecialEffectTimed takes effect e,real time returns nothing
        local timer t = NewTimer()
        call SetHandleHandle(GetHandleId(t),"e",e)
        call TimerStart(t,time,false,function AEFT)
        set e = null
        set t = null
    endfunction
    
    function AttachEffectToUnit takes string s,unit u,string o,real r returns nothing
        local timer t=NewTimerUnit(u)
        local integer id=GetHandleId(t)
        call SetHandleReal(id,"aftu|time",r)
        call SetHandleHandle(id,"aftu|sfx",AddSpecialEffectTarget(s,u,o))
        call TimerStart(t,0.1,true,function AFTU)
        set t = null
    endfunction
    
    function FxVisiblity takes unit u,unit e returns nothing
        local boolean isInvi=GetUnitAbilityLevel(u,'B01F')>0 or GetUnitAbilityLevel(u,'BOwk')>0 or GetUnitAbilityLevel(u,'Binv')>0 
        if isInvi and GetUnitAbilityLevel(e,'A0JC')==0 then
            call UnitAddAbility(e,'A0JC')
            call UnitMakeAbilityPermanent(e,true,'A0JC')
        endif
        if isInvi == false and GetUnitAbilityLevel(e,'A0JC')>0 then
            call UnitMakeAbilityPermanent(e,false,'A0JC')
            call UnitRemoveAbility(e,'A0JC')
        endif
    endfunction
    
endlibrary