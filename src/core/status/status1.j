library Status1 requires TimerUtils,Inmunity

    globals
        constant integer ANIMATION = 'STUN'
        constant integer ANIMATION_BUFF = 'B104'
    endglobals
    
    function FlyTrick takes unit u returns nothing
        if UnitAddAbility(u,'Amrf') then
            call UnitRemoveAbility(u,'Amrf')
        endif
    endfunction
    
    function IsUnitTypeWard takes unit whichUnit returns boolean
        return GetUnitTypeId(whichUnit)=='oeye' or GetUnitTypeId(whichUnit)=='nwad'
    endfunction
    
    function SafeFilter takes nothing returns boolean
        local unit u = GetFilterUnit()
        local boolean b = GetWidgetLife(u)>0.405 and IsUnitType(u,UNIT_TYPE_MAGIC_IMMUNE)==false and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitInvulnerable(u)==false
        set u = null
        return b
    endfunction
    
    function UnitFilter takes unit u returns boolean
        return GetWidgetLife(u)>0.405 and IsUnitType(u,UNIT_TYPE_MAGIC_IMMUNE)==false and IsInmune(u)==false and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitInvulnerable(u)==false and IsUnitTypeWard(u)==false
    endfunction
    
    define
        UnitFilterEx(u) = UnitFilter(u)
        UnitFilterEx(u,p) = UnitFilter(u) and IsUnitEnemy(u,p)
    enddefine
    
    function UnitFilterAllied takes unit u returns boolean
        return GetWidgetLife(u)>0.405 and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitTypeWard(u)==false
    endfunction
    
endlibrary