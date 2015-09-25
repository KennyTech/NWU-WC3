scope HanBoilReleaseOn

    globals
        private constant integer SPELL_ID   = 'CW52' 
        private constant integer ID_CANCEL  = 'CW53'
        private constant integer SLOW_ID    = 'CW54'
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1) // load caster
        local integer level = LoadInteger(HT, id, 2) 
        local real mana = GetUnitState(c, UNIT_STATE_MANA)
        //local real life = GetUnitState(c, UNIT_STATE_LIFE)
        
        if mana > 0.5+level and GetUnitAbilityLevel(c, SLOW_ID) > 0 then // periodic 0.25 = 6/10/14/18 per sec upkeep
            call SetUnitState(c, UNIT_STATE_MANA, mana - (0.5+level))
        //elseif life > 0.905+level and GetUnitAbilityLevel(c, SLOW_ID) > 0 then
        //    call SetUnitState(c, UNIT_STATE_LIFE, life - (0.5+level))
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),SPELL_ID, true)
            call UnitRemoveAbility(c, ID_CANCEL)
            call UnitRemoveAbility(c, SLOW_ID)
            if level == 1 then
                call UnitRemoveAbility(c, 'AId4') // +4 armor abil
            elseif level == 2 then
                call UnitRemoveAbility(c, 'AId5') // +5 armor abil
            elseif level == 3 then
                call UnitRemoveAbility(c, 'AId5') // +5 armor abil
                call UnitRemoveAbility(c, 'AId1') // +1 armor abil
            else
                call UnitRemoveAbility(c, 'AId7') // +7 armor abil
            endif
            call FlushChildHashtable(HT,id)
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
        
        set t = null
        set c = null
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local integer level = GetUnitAbilityLevel(c,SPELL_ID)
        
        call SaveUnitHandle(HT, id, 1, c) 
        call SaveInteger(HT, id, 2, level)
        
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),SPELL_ID, false)
        call UnitAddAbility(c, ID_CANCEL)
        call UnitAddAbility(c, SLOW_ID)
        call SetUnitAbilityLevel(c, ID_CANCEL, level)
        call SetUnitAbilityLevel(c, SLOW_ID, level)
        if level == 1 then
            call UnitAddAbility(c, 'AId4') // +4 armor abil
        elseif level == 2 then
            call UnitAddAbility(c, 'AId5') // +5 armor abil
        elseif level == 3 then
            call UnitAddAbility(c, 'AId5') // +5 armor abil
            call UnitAddAbility(c, 'AId1') // +1 armor abil
        else
            call UnitAddAbility(c, 'AId7') // +7 armor abil
        endif
        call TimerStart(t,0.25,true,function TimerActions) // Start upkeep

        set c = null
        set t = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        set t = null
    endfunction

endscope