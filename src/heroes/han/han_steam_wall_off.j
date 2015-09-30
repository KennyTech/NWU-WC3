scope HanSteamWallOff

    globals
        private constant integer SPELL_ID   = 'CW46' 
        private constant integer ID_CANCEL  = 'CW47'
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_CANCEL
    endfunction

    private function Removal takes nothing returns nothing
        if GetDestructableTypeId(GetEnumDestructable()) == 'CWd1' then
            call RemoveDestructable(GetEnumDestructable())
        endif
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local player p = GetTriggerPlayer()
        local rect r = Rect(x+1000,y+1000,x-1000,y-1000) //Temp-fix
        
        call TriggerSleepAction(0.2)
        call EnumDestructablesInRect(r, null, function Removal)
        call SetPlayerAbilityAvailable(p,SPELL_ID, true)
        call UnitRemoveAbility(c, ID_CANCEL)
        
        set c = null
        set p = null
        set r = null
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
