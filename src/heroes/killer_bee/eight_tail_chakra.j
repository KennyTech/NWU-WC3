scope KB8TailChakra

    globals
        private constant integer SPELL_ID   = 'CW03'    // ID of ability: "Killer B - 8-Tail Chakra"
        private constant integer AURA_ID    = 'CW07'    // ID of ability: "Killer B - 8-Tail Chakra Aura"
        private constant integer BOOK_ID    = 'CW08'    // ID of ability: "Killer B - 8-Tail Chakra Aura Book"
        private constant hashtable HT = InitHashtable()  
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
       
    private function TimerActions takes nothing returns nothing // End of ult duration
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1)
        local integer level = LoadInteger(HT, id, 2)

        call SetHeroAgi(c, (GetHeroAgi(c,false) - (5+ 5*level)), false) // Revert AGI bonus
        call AddUnitAnimationProperties(c, "alternate", false) // Undo transform
        call UnitRemoveAbility(c, BOOK_ID) // Remove MS+AS
        call PauseTimer(t) 
        call DestroyTimer(t) 
            
        set c = null
        set t = null
    endfunction   
       
    private function Actions takes nothing returns nothing // Initial actions
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit c = GetTriggerUnit()
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        
        call SaveUnitHandle(HT, id, 1, c)
        call SaveInteger(HT, id, 2, level)
        
        call AddUnitAnimationProperties(c, "alternate", true) // Transform Killer B
        call UnitAddAbility(c, BOOK_ID) // Add MS+AS (this is how I detect KB is in ult form)
        call SetUnitAbilityLevel(c, AURA_ID, GetUnitAbilityLevel(c, SPELL_ID))
        call SetHeroAgi(c, (GetHeroAgi(c,false) + (5+ 5*level)), false) // increase base AGI by 10/15/20
        call TimerStart(t,20,false,function TimerActions) // 20 second duration
        
        set c = null
        set t = null
    endfunction
    
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null

        // Preload and Disable
        call DisableSpellbook(BOOK_ID)
    endfunction

endscope

