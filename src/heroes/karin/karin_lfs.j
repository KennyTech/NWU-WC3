scope KarinLFS

    globals
        private constant integer SPELL_ID    = 'CW14'    // Ability ID of "Karin - Life Force" 
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function Actions takes nothing returns nothing // Actions upon start of channeling 
        local integer i = GetPlayerId(GetTriggerPlayer())
        call PauseTimer(LF_Karin_Timer[i])
        call DestroyTimer(LF_Karin_Timer[i])
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope