scope HanBoilReleaseOff

    globals
        private constant integer SPELL_ID   = 'CW52' 
        private constant integer ID_CANCEL  = 'CW53'
        private constant integer SLOW_ID    = 'CW54'
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_CANCEL
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        call TriggerSleepAction(0.2)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),SPELL_ID, true)
        call UnitRemoveAbility(c, ID_CANCEL)
        call UnitRemoveAbility(c, SLOW_ID)
        set c = null
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