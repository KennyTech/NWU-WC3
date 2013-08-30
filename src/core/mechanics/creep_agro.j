scope AgroSystem
    
    function reorder_enum takes nothing returns nothing
        local unit u=GetEnumUnit()
        call RemoveSavedBoolean(HT,GetHandleId(u),119)
        call RemoveSavedHandle(HT,GetHandleId(u),105)
        call SetNextWayPoint(u)
        set u=null
    endfunction
    
    /**
     *  
     */
    private function reorder takes nothing returns nothing
        local timer t=GetExpiredTimer()
        local group g=LoadGroupHandle(HT,GetHandleId(t),0)
        call ForGroup(g,function reorder_enum)
        call ReleaseGroup(g)
        call ReleaseTimer(t)
        set g=null
        set t=null
    endfunction
    
    private function EnumCreeps takes nothing returns boolean
        local unit u=GetFilterUnit()
        local integer id=GetHandleId(u)
        if GetWidgetLife(u)>0.405 and IsUnitSoldierCreep(u) and IsUnitAlly(u,GetOwningPlayer(udg_CreepAgro_Attacked))==true and LoadBoolean(HT,id,119)==false then
            call SaveAgentHandle(HT,id,105,udg_CreepAgro_Attacker)
            call SaveBoolean(HT,id,119,true)
            call IssueTargetOrderById(u,851983,udg_CreepAgro_Attacker)
            return true
        endif
        set u=null
        return false
    endfunction

    /**
     *  Executed when EVENT_PLAYER_UNIT_ATTACKED & EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER.
     *  Checks if the attacker unit is at 500 range from attacked one and if the attacked
     *  unit is a hero and if the attacker unit is controller by a human and if the units
     *  are enemies, if that condition is satisfied, 
     *
     *  @private
     */
    private function onAttack takes nothing returns nothing
        local group creeps
        local timer t
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_ATTACKED then
           set udg_CreepAgro_Attacked = GetTriggerUnit()
           set udg_CreepAgro_Attacker = GetAttacker()
        else
           set udg_CreepAgro_Attacked = GetOrderTargetUnit()
           set udg_CreepAgro_Attacker = GetTriggerUnit()
           if GetIssuedOrderId() > 851983 then // 851983 = order attack
              return
           endif
        endif
        if IsUnitInRange(udg_CreepAgro_Attacked,udg_CreepAgro_Attacker,700) and IsUnitType(udg_CreepAgro_Attacked,UNIT_TYPE_HERO)==true and GetPlayerController(GetOwningPlayer(udg_CreepAgro_Attacker))==MAP_CONTROL_USER and IsUnitEnemy(udg_CreepAgro_Attacked,GetOwningPlayer(udg_CreepAgro_Attacker))==true then
            set creeps=NewGroup()
            set t=NewTimer()
            call GroupEnumUnitsInRange(creeps,GetUnitX(udg_CreepAgro_Attacker),GetUnitY(udg_CreepAgro_Attacker),500,Filter(function EnumCreeps))
            call SaveAgentHandle(HT,GetHandleId(t),0,creeps)
            call TimerStart(t,2.75,false,function reorder)
            set creeps=null
            set t=null
        endif
    endfunction

    /**
     *  Executed in map init
     *  Creates a trigger that listen for 
     *  EVENT_PLAYER_UNIT_ATTACKED and EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER
     */
    function StartTrigger_Agro_System takes nothing returns nothing
        local trigger t=CreateTrigger()
        call GT_RegisterPlayerEvent(t,EVENT_PLAYER_UNIT_ATTACKED)
        call GT_RegisterPlayerEvent(t,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
        call TriggerAddAction(t,function onAttack)
        set t=null
    endfunction

endscope
