scope KarinLFC

    globals
        private constant integer SPELL_ID        = 'CW14'    // Ability ID of "Karin - Life Force" 
        private constant hashtable HT            = InitHashtable()
        private constant integer INDI_ID         = 'h02J'
    endglobals
    
    private function DamageFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false
    endfunction
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function onExpire takes nothing returns nothing // Periodic healing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u
        local real x
        local real y
        local integer level = GetUnitAbilityLevel(HeroKarin,SPELL_ID)
        local unit dummy = LoadUnitHandle(HT,id,2)    
        local integer DUR = LoadInteger(HT,id,1) - 1

        call SaveInteger(HT,id,1,DUR)

            
        if DUR > 0 and GetWidgetLife(HeroKarin) > 0.405 then
        
            set x = GetUnitX(HeroKarin)
            set y = GetUnitY(HeroKarin)
            call SetUnitPosition(dummy,x-(12+level*4), y-(30*level))
            
            
            call GroupEnumUnitsInRange(ENUM,x,y,100+200*level,function DamageFilter) // Enumerate # of allies to heal
            loop
                set u = FirstOfGroup(ENUM)
            exitwhen u == null
                if IsUnitAlly(u,GetOwningPlayer(HeroKarin)) and GetUnitState(u, UNIT_STATE_LIFE) < GetUnitState(u, UNIT_STATE_MAX_LIFE) and IsUnitType(u, UNIT_TYPE_STRUCTURE) == false and GetUnitAbilityLevel(HeroKarin,'B02R') == 0 and GetUnitAbilityLevel(HeroKarin,'BSTN') == 0 and GetUnitAbilityLevel(HeroKarin,'BPSE') == 0 and GetUnitAbilityLevel(HeroKarin,'B007') == 0 and GetUnitAbilityLevel(HeroKarin,'B01O') == 0 and IsUnitType(HeroKarin, UNIT_TYPE_POLYMORPHED) == false and GetUnitAbilityLevel(HeroKarin,'B00X') == 0 and GetUnitAbilityLevel(HeroKarin,'B016') == 0 and GetUnitAbilityLevel(HeroKarin,'B01O') == 0 and GetUnitAbilityLevel(HeroKarin,'B003') == 0 and GetUnitAbilityLevel(HeroKarin,'BNsi') == 0 and GetUnitAbilityLevel(HeroKarin,'BUsl') == 0 and GetUnitAbilityLevel(HeroKarin,'B03X') == 0 and GetUnitAbilityLevel(HeroKarin,'B01H') == 0  then
                    call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) + 1.875*level)
                endif
                call GroupRemoveUnit(ENUM,u)
            endloop
        
        else 

            call RemoveUnit(dummy)
            call UnitRemoveAbility(HeroKarin, 'A0LN')
            call UnitRemoveAbility(HeroKarin, 'A0LR')
            call ReleaseTimerEx()
        endif
    
        set u = null
        set t = null
        set dummy = null
    endfunction
    
    private function Actions takes nothing returns nothing
        local timer t       = NewTimer()
        local integer id    = GetHandleId(t)
        local unit dummy
        local integer level = GetUnitAbilityLevel(HeroKarin, SPELL_ID)
        local real x        = GetUnitX(GetTriggerUnit())
        local real y        = GetUnitY(GetTriggerUnit())
        
        call TriggerSleepAction(0.2)
        
        call UnitAddAbility(HeroKarin, 'A0LN')
        
        set dummy = CreateUnit(GetOwningPlayer(HeroKarin),'h02J',GetUnitX(GetTriggerUnit()),GetUnitY(GetTriggerUnit()),0)
        call UnitApplyTimedLife(dummy,'BTLF',10)
        call SetUnitScale(dummy, 1.2+1.8*level, 1.2+1.8*level, 1.2+1.8*level)
        //call SetUnitVertexColor(dummy, 255, 20, 30, 150 )
        call UnitAddAbility(dummy, 'A0LR')
        call SetUnitAbilityLevel(dummy, 'A0LR', level)
        
        
        call SaveInteger(HT,id,1,160)
        call SaveUnitHandle(HT,id,2,dummy)
        call TimerStart(t, 0.0625, true, function onExpire)
        
        set dummy = null
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope

