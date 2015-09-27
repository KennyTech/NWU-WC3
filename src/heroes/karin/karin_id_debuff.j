scope KarinIdDebuff

    globals
        private constant integer SPELL_ID    = 'CW16'    // Ability ID of "Identify Armor Reduce (Karin)" 
        private constant integer BUFF_ID    = 'BK07'    // Buff ID of "Identified"  
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetAttacker(), BUFF_ID) > 0 
    endfunction
    
    private function Actions takes nothing returns nothing // Decrease Identified units' armor per attack they make
        local unit c = GetAttacker()
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        if GetUnitAbilityLevel(c, SPELL_ID) < 2*level then
            call SetUnitAbilityLevel(c, SPELL_ID, GetUnitAbilityLevel(c, SPELL_ID) + 1)
        endif
        set c = null
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ATTACKED)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope