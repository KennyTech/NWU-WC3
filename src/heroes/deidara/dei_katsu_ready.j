scope DeiKatsuReady

    globals
        private constant integer SPELL_ID       = 'CW62' 
        private constant integer DUMMY_ID1      = 'cw15'
        private constant integer ORB_ID         = 'CW67'
        private constant integer KATSU_RDY_ID   = 'CW66'
        private constant hashtable HT           = InitHashtable()
        private group KATSU_CD_GROUP            = CreateGroup() // Prevent stack bug
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetAttacker(), KATSU_RDY_ID) > 0 and IsUnitEnemy(GetTriggerUnit(), GetOwningPlayer(GetAttacker()))
    endfunction
    
    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit attacker = LoadUnitHandle(HT, id, 1)
        
        call UnitAddAbility(attacker, KATSU_RDY_ID)
        call GroupRemoveUnit(KATSU_CD_GROUP, attacker)
        
        call FlushChildHashtable(HT,id)
        call PauseTimer(t)
        call DestroyTimer(t)
    
        set t = null
        set attacker = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit attacker = GetAttacker()
        local unit attacked = GetTriggerUnit()
        local unit dummy_attacker
        local real x = GetUnitX(attacker) 
        local real y = GetUnitY(attacker)
        local integer level = GetUnitAbilityLevel(attacker, SPELL_ID)

        set dummy_attacker = CreateUnit(GetOwningPlayer(attacker),DUMMY_ID1,x,y,GetUnitFacing(attacker))
        call UnitApplyTimedLife(dummy_attacker,'BTLF',3.5)
        call UnitAddAbility(dummy_attacker, ORB_ID)
        call SetUnitAbilityLevel(dummy_attacker, ORB_ID, GetUnitAbilityLevel(attacker, SPELL_ID))
        call IssueTargetOrder(dummy_attacker, "attack", attacked)
        
        call SaveUnitHandle(HT, id, 1, attacker)
        
        call UnitRemoveAbility(attacker, KATSU_RDY_ID)
        
        if IsUnitInGroup(attacker, KATSU_CD_GROUP) == false then
            call TimerStart(t, 18-level*3, false, function TimerActions)
        endif
        
        call GroupAddUnit(KATSU_CD_GROUP, attacker)

        set attacker = null
        set attacked = null
        set t = null
        set dummy_attacker = null
        
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ATTACKED)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        set t = null
    endfunction

endscope