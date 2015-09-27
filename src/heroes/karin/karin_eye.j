scope KarinEye 

    globals
        private constant integer SPELL_ID    = 'CW10'    // Ability ID of "Karin - Mind's Eye"
        private constant integer DUMMY       = 'cw01'    // Unit ID of "SX - Mind's Eye"
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function ColorIllusions takes group g, real x, real y, real n, unit c returns nothing
        local unit u
        call GroupEnumUnitsInRange(g,x,y,n,null)
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitIllusion(u) then
                call SetUnitVertexColor(u,75,75,225,225)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        set u = null
        set g = null
        set c = null
    endfunction
    
    private function Actions takes nothing returns nothing // Actions upon start of channeling 
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local unit d
        local unit c = GetTriggerUnit()
        local group g = CreateGroup()
        local unit u
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local integer n = GetPlayerId(GetOwningPlayer(c))
        
        // Color enemy illusions in the area blue every second for duration
        call ColorIllusions(g,x,y,1000,c)
        call TriggerSleepAction(1.0)
        
        // Visual
        set d = CreateUnit(GetOwningPlayer(GetTriggerUnit()), DUMMY, x, y, 0)
        call UnitApplyTimedLife(d,'BTLF',2.0)
        
        call ColorIllusions(g,x,y,1000,c)
        call TriggerSleepAction(1.0)
        call ColorIllusions(g,x,y,1000,c)
        call TriggerSleepAction(1.0)
        call ColorIllusions(g,x,y,1000,c)
        call TriggerSleepAction(1.0)
        if level >= 1 then
            call ColorIllusions(g,x,y,1000,c)
        endif
        call TriggerSleepAction(1.0)
        if level >= 2 then
            call ColorIllusions(g,x,y,1000,c)
        endif
        call TriggerSleepAction(1.0)
        if level >= 3 then
            call ColorIllusions(g,x,y,1000,c)
        endif
        call TriggerSleepAction(1.0)
        if level >= 4 then
            call ColorIllusions(g,x,y,1000,c)
        endif
      
        set c = null
        set d = null
        set g = null
        set u = null
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope