scope SaiInkBlink

    globals
        private constant integer SPELL_ID         = 'CW34' 
        private constant integer EVAS_BOOK_ID     = 'CW44' 
        private constant integer EVAS_SPELL_ID    = 'CW43' 
        private constant hashtable HT             = InitHashtable()
        private group SaiInkGroup                 = CreateGroup()
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction

    private function AntiEvasAbuse takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1)
        call GroupRemoveUnit(SaiInkGroup, c)
        set c = null
        set t = null
    endfunction
    
    private function RemoveEvas takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1)
        call UnitRemoveAbility(c, EVAS_BOOK_ID)
        set c = null
        set t = null
    endfunction
    
    private function Actions takes nothing returns nothing 
        local unit c = GetTriggerUnit()
        local timer t = CreateTimer()
        local timer t2 = CreateTimer()
        local integer id = GetHandleId(t)
        local integer id2 = GetHandleId(t2)
        call SaveUnitHandle(HT, id, 1, c)
        call SaveUnitHandle(HT, id2, 1, c)
        if IsUnitInGroup(c, SaiInkGroup) == false then
            call UnitAddAbility(c, EVAS_BOOK_ID)
            call SetUnitAbilityLevel(c, EVAS_SPELL_ID, GetUnitAbilityLevel(c, SPELL_ID))
            call GroupAddUnit(SaiInkGroup, c)
            call TimerStart(t, 1.5, false, function RemoveEvas)
            call TimerStart(t2, 20.5-3*(GetUnitAbilityLevel(c, SPELL_ID)), false, function AntiEvasAbuse)
        endif
        set c = null
        set t = null
        set t2 = null
    endfunction
    
    //===========================================================================
    
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null

        call DisableSpellbook(EVAS_BOOK_ID)
    endfunction

endscope