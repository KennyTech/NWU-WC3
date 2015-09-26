scope InoDash

    globals
        private constant integer SPELL_ID   = 'CW76' 
        private constant integer DUMMY_ID1  = 'cw18'
        private constant integer PETAL_ID   = 'cw20'
        private constant real DASH_DISTANCE = 300
        private constant hashtable HT = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function Remove takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u = LoadUnitHandle(HT,id,1)
        call RemoveUnit(u)
        call PauseTimer(t)
        call DestroyTimer(t)
        call FlushChildHashtable(HT, id)
        set u = null
        set t = null
    endfunction

    private function DashFade takes unit u returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        call SaveUnitHandle(HT,id,1,u)
        call TimerStart(t,1.1,false,function Remove)
        set t = null
    endfunction

    private function Dash takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit caster = LoadUnitHandle(HT, id, 1) 
        local real angle = LoadReal(HT, id, 2)
        local real distance = LoadReal(HT, id, 3) - 80
        local unit dummy
        local real x = LoadReal(HT, id, 4) +(80)*Cos(angle*bj_DEGTORAD)
        local real y = LoadReal(HT, id, 5) +(80)*Sin(angle*bj_DEGTORAD)
        local item i
        local integer level = GetUnitAbilityLevel(caster, SPELL_ID) 
        local integer n = GetPlayerId(GetOwningPlayer(caster))
        
        call SaveReal(HT, id, 3, distance)
        call SaveReal(HT, id, 4, x)
        call SaveReal(HT, id, 5, y)
        
        // Recharge Kunai
        call UnitRemoveAbility(caster, 'CW70')
        call UnitRemoveAbility(caster, 'CW71')
        call UnitRemoveAbility(caster, 'CW73')
        call UnitAddAbility(caster, 'CW72')
        call SetUnitAbilityLevel(caster, 'CW72', GetUnitAbilityLevel(caster,'CW74'))

        // Dash
        if distance > 0 then 
            
            call SetUnitX(caster, x)
            call SetUnitY(caster, y)
            
            set dummy = CreateUnit(GetOwningPlayer(caster), DUMMY_ID1, x,y, angle)
            call SetUnitVertexColor(dummy,255,255,255,125) 
            call DashFade(dummy)
            call SetUnitAnimation(dummy, "walk") 
            call SetUnitTimeScale(dummy, 3.00) // speed up animation by 3x
            
            if level == 2 then
                call UnitAddAbility(dummy, 'AItf') // +15
            elseif level == 3 then
                call UnitAddAbility(dummy, 'AItx') // +20
                call UnitAddAbility(dummy, 'AItn') // +10
            elseif level == 4 then
                call UnitAddAbility(dummy, 'AItx') // +20
                call UnitAddAbility(dummy, 'AItf') // +15
                call UnitAddAbility(dummy, 'AItn') // +10
            endif
            
            set dummy = CreateUnit(GetOwningPlayer(caster), PETAL_ID, x, y, angle)
            call SetUnitTimeScale(dummy, 1.50)
            call UnitApplyTimedLife(dummy,'BTLF',0.1)
            
        else 
            
            // Move to nearest pathable
            set i = CreateItem('afac', x, y)
            set x = GetItemX(i)
            set y = GetItemY(i)
            call RemoveItem(i)
            call SetUnitX(caster, x)
            call SetUnitY(caster, y)
            // ================================
            
            call ShowUnit(caster, true)
            if (GetLocalPlayer() == GetOwningPlayer(caster)) then
                call ClearSelection()
                call SelectUnit(caster, true)
            endif
            
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
            
        endif
        
        set t = null
        set caster = null
        set dummy = null
        set i = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit caster = GetTriggerUnit()
        local real x = GetUnitX(caster) 
        local real y = GetUnitY(caster) 
        local real angle = GetUnitFacing(caster)
        
        call ShowUnit(caster, false)
        
        call TimerStart(t,0.1,true,function Dash) 
        
        call SaveUnitHandle(HT, id, 1, caster)
        call SaveReal(HT, id, 2, angle)
        call SaveReal(HT, id, 3, DASH_DISTANCE) 
        call SaveReal(HT, id, 4, x) 
        call SaveReal(HT, id, 5, y) 
        
        set t = null
        set caster = null
    endfunction

    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope