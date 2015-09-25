scope DeiKatsuLearn initializer Init

    globals
        private constant integer LEARN_ID   = 'CW62'
        private constant integer SPELL_ID   = 'CW66'
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetLearnedSkill() == LEARN_ID
    endfunction
    
     private function Actions takes nothing returns nothing
        local unit u = GetTriggerUnit()
        call UnitAddAbility(u,SPELL_ID)
        set u = null
    endfunction
    
    //=== Event ========================================================================
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_HERO_SKILL)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        set t = null
    endfunction

endscope