scope InoKunaiLearn

    globals
        private constant integer LEARN_ID   = 'CW74'
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetLearnedSkill() == LEARN_ID
    endfunction
    
     private function Actions takes nothing returns nothing
        local unit u = GetTriggerUnit()
        if GetUnitAbilityLevel(u, 'CW70') == 0 and GetUnitAbilityLevel(u, 'CW71') == 0 and GetUnitAbilityLevel(u, 'CW72') == 0 and GetUnitAbilityLevel(u, 'CW73') == 0 and GetUnitAbilityLevel(u, 'A0LP') == 0 and GetUnitAbilityLevel(u, 'A0LQ') == 0 then
            call UnitAddAbility(u,'A0LQ')
        endif
        if GetUnitAbilityLevel(u, 'A0LQ') > 0 then
            call SetUnitAbilityLevel(u, 'A0LQ', GetUnitAbilityLevel(u, LEARN_ID))
        endif
        set u = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_HERO_SKILL)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope
