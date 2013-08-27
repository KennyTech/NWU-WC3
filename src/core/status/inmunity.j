library Inmunity requires TimerUtils

    globals
        private string INMUNITY="Status|Inmunity"
    endglobals

    function UnitAddInmunity takes unit whichUnit returns nothing
        local integer id=GetHandleId(whichUnit)
        call SetHandleInt(id,INMUNITY,GetHandleInt(id,INMUNITY)+1)
        if GetUnitAbilityLevel(whichUnit,'A00B')==0 then
            call UnitAddAbility(whichUnit,'A00B')
            call UnitMakeAbilityPermanent(whichUnit,true,'A00B')
        endif
    endfunction

    function UnitRemoveInmunity takes unit whichUnit returns nothing
        local integer id=GetHandleId(whichUnit)
        local integer level=GetHandleInt(id,INMUNITY)-1
        call SetHandleInt(id,INMUNITY,level)
        if level<=0 then
            call UnitMakeAbilityPermanent(whichUnit,false,'A00B')
            call UnitRemoveAbility(whichUnit,'A00B')
            call RemoveHandle(id,INMUNITY)
        endif
    endfunction
    
    function IsInmune takes unit whichUnit returns boolean
        return GetUnitAbilityLevel(whichUnit,'A00B')>0 
    endfunction

    private function InmunityEnd takes nothing returns nothing
        call UnitRemoveInmunity(GetTimerUnit())
        call ReleaseTimerEx()
    endfunction

    function UnitAddInmuneTimed takes unit whichUnit,real time returns nothing
        call UnitAddInmunity(whichUnit)
        call TimerStart(NewTimerUnit(whichUnit),time,false,function InmunityEnd)
    endfunction

endlibrary