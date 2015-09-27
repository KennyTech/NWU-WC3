scope KarinKFA 

    globals
        private constant integer SPELL_ID   = 'CW11'    // Spell ID of "Karin - Kongou Fuusa"
        private constant integer D_SPELL_ID = 'CW13'    // Dummy Spell ID of "Karin - Kongou Fuusa Dummy Chains"
        private constant integer D_SPELL_ID2 = 'CW12'   // Dummy Spell ID of "Karin - Kongou Fuusa Dummy AoE"
        private constant integer BUFF_ID    = 'BK04'    // Buff ID of "Kongou Fuusa (black orb)"      
        private constant integer DUMMY      = 'h01K'    // Unit ID of Dummy Caster
    endglobals

    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetAttacker(), BUFF_ID) > 0 and IsUnitEnemy(GetAttacker(), GetOwningPlayer(GetTriggerUnit()))
    endfunction
    
    private function EnemyFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false
    endfunction
    
    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local integer i = LoadInteger(HT, id, 1)
        local unit u
        
        loop
            set u = FirstOfGroup(KarinChainGroup[i])
        exitwhen u == null
            call GroupRemoveUnit(KarinChainGroup[i], u)
        endloop
        
        call FlushChildHashtable(HT, id)
        call PauseTimer(t)
        call DestroyTimer(t)
            
        set t = null
        set u = null
    endfunction
    
    private function Actions takes nothing returns nothing
        local group g = CreateGroup()
        local unit u
        local unit d
        local real x = GetUnitX(GetTriggerUnit())
        local real y = GetUnitY(GetTriggerUnit())
        local integer level = GetUnitAbilityLevel(GetAttacker(), SPELL_ID)
        local integer i = GetPlayerId(GetOwningPlayer(GetAttacker()))
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        
        set KF_level[i] = level // For Drain later
        set KF_Karin[i] = GetAttacker() // For Drain later
        
        call SaveInteger(HT, id, 1, i)
        
        call TimerStart(t, 1.5+(0.5*level), false, function TimerActions) // Flush at 2/2.5/3/3.5 secs chain duration
        
        call UnitRemoveAbility(KF_Karin[i], BUFF_ID) 
        
        call GroupEnumUnitsInRange(g,x,y,175,function EnemyFilter) // Enumerate # of enemies to seal
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if u == GetTriggerUnit() then
                set d = CreateUnit(GetOwningPlayer(KF_Karin[i]), DUMMY, x, y, 0)
                call UnitApplyTimedLife(d,'BTLF',1.0)
                call UnitAddAbility(d, D_SPELL_ID)
                call SetUnitAbilityLevel(d, D_SPELL_ID, level)
                call IssueTargetOrder(d, "entanglingroots", u)
                call GroupAddUnit(KarinChainGroup[i], u)
            elseif IsUnitEnemy(u, GetOwningPlayer(KF_Karin[i])) then
                set d = CreateUnit(GetOwningPlayer(KF_Karin[i]), DUMMY, x, y, 0)
                call UnitApplyTimedLife(d,'BTLF',1.0)
                call UnitAddAbility(d, D_SPELL_ID2)
                call SetUnitAbilityLevel(d, D_SPELL_ID2, level)
                call IssueTargetOrder(d, "entanglingroots", u)
                call GroupAddUnit(KarinChainGroup[i], u)
            endif
            
            call GroupRemoveUnit(g,u)
        endloop
        
        set g = null
        set u = null
        set d = null
        set t = null
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