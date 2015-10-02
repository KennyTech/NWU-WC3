scope KarinLFC

    globals
        private constant integer SPELL_ID = 'CW14'    // Ability ID of "Karin - Life Force" 
        private constant string EFFECT    = "Objects\\Spawnmodels\\Human\\HumanBlood\\HeroBloodElfBlood.mdl"
        private constant hashtable HT     = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function DamageFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false
    endfunction
    
    private function TimerActions takes nothing returns nothing // Periodic healing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u
        local real x
        local real y
        local integer level = GetUnitAbilityLevel(HeroKarin,SPELL_ID)
        
        local integer DUR = LoadInteger(HT,id,1) - 1
        call SaveInteger(HT,id,1,DUR)
            
        if DUR > 0 then
        
            set x = GetUnitX(HeroKarin)
            set y = GetUnitY(HeroKarin)
        
            call GroupEnumUnitsInRange(ENUM,x,y,500+level*100,function DamageFilter) // Enumerate # of allies to heal
            loop
                set u = FirstOfGroup(ENUM)
            exitwhen u == null
                if IsUnitAlly(u,GetOwningPlayer(HeroKarin)) and GetUnitState(u, UNIT_STATE_LIFE) < GetUnitState(u, UNIT_STATE_MAX_LIFE) and IsUnitType(HeroKarin, UNIT_TYPE_STUNNED) == false and IsUnitType(HeroKarin, UNIT_TYPE_POLYMORPHED) == false then
                    call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) + 3.75*level)
                endif
                call GroupRemoveUnit(ENUM,u)
            endloop
        
        else 
            call UnitRemoveAbility(HeroKarin, 'A0LN')
            call ReleaseTimerEx()
        endif
    
        set u = null
        set t = null
    endfunction
    
    private function Actions takes nothing returns nothing
        local timer t       = NewTimer()
        local integer id    = GetHandleId(t)
        
        set HeroKarin = GetTriggerUnit()
        call TriggerSleepAction(0.2)
        call UnitAddAbility(HeroKarin, 'A0LN')
        call SaveInteger(HT,id,1,80)
        call TimerStart(t, 0.125, true, function TimerActions)
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
