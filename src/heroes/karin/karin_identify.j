scope KarinIdentify

    globals
        private constant integer SPELL_ID    = 'CW09'    // Ability ID of "Karin - Identify" 
        private constant integer SPELL_ID2    = 'CW17'    // Ability ID of "Karin - Identify Aura" 
        private constant integer SPELL_ID3    = 'CW16'    // Ability ID of "Identify Armor Reduce (Karin)"  
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction

    private function EnemyFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE) == false
    endfunction

    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u
        local group idGroup = LoadGroupHandle(HT, id, 1)
        local integer p = LoadInteger(HT, id, 2)
        
        loop
            set u = FirstOfGroup(KarinIDGroup[p])
        exitwhen u == null
            call GroupRemoveUnit(KarinIDGroup[p], u)
            // call DisplayTextToForce( GetPlayersAll(), GetUnitName(u) + " <-- flushing this unit")
            call UnitRemoveAbility(u, SPELL_ID2)
            call UnitRemoveAbility(u, SPELL_ID3)
        endloop
        
        call FlushChildHashtable(HT, id)
        call PauseTimer(t)
        call DestroyTimer(t)
        
        set idGroup = null
        set t = null
        set u = null
    endfunction
    
    private function Actions takes nothing returns nothing // Actions upon start of channeling 
        local group g = CreateGroup()
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local unit c = GetTriggerUnit()
        local unit u
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local group idGroup = CreateGroup()
        
        set Karin[GetPlayerId(GetOwningPlayer(c))] = c
        
        call GroupEnumUnitsInRange(g,x,y,250+level*25,function EnemyFilter) // Enumerate enemies to identify
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitIllusion(u) == false and GetUnitDefaultMoveSpeed(u) >= 150 then // Enemy, not clone, not ward
                call GroupAddUnit(idGroup, u)
                call GroupAddUnit(KarinIDGroup[GetPlayerId(GetOwningPlayer(c))], u) // For Bounty Death later
                // call DisplayTextToForce( GetPlayersAll(), GetUnitName(u) + " <-- added unit to bounty creep")
                call UnitAddAbility(u, SPELL_ID2)
                call UnitAddAbility(u, SPELL_ID3)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call SaveGroupHandle(HT, id, 1, idGroup)
        call SaveInteger(HT, id, 2, GetPlayerId(GetOwningPlayer(c)))
        call TimerStart(t, 10, false, function TimerActions)
        
        set c = null
        set u = null
        set g = null
        set t = null
        set idGroup = null
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