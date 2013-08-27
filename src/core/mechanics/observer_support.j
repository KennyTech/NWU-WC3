function ReorderCreep takes unit u returns nothing
    local unit lastTarget=GetLastTarget(u)
    call SetUnitPosition(u,GetUnitX(u),GetUnitY(u))
    if lastTarget!=null and IsUnitVisible(lastTarget,GetOwningPlayer(lastTarget)) and GetWidgetLife(lastTarget)>0.405  then
        call IssueTargetOrderById(u,OrderId("attack"),lastTarget)
    else
        call DisableTrigger(GetTriggeringTrigger())
        call IssuePointOrderByIdLoc(u,OrderId("attack"),GetNextWayPoint(u))
        call EnableTrigger(GetTriggeringTrigger())
    endif
    set lastTarget=null
endfunction

function IsMoveOrder takes nothing returns boolean
    if GetIssuedOrderId()==851986 then
        debug call BJDebugMsg("REORDER CREEP!")
        call ReorderCreep(GetTriggerUnit())
    endif
    return false
endfunction

function Observer_Support_InRange_Action takes nothing returns boolean
    if IsUnitSoldierCreep(GetTriggerUnit()) then
        call ReorderCreep(GetTriggerUnit())
    endif
    return false
endfunction

function IsUnitFoggedToAnyTeam takes nothing returns boolean
    local unit u=GetAttacker()
    if IsUnitFogged(u,udg_team1[1]) or IsUnitFogged(u,udg_team2[1]) then
        if GetOwningPlayer(GetTriggerUnit())==udg_team1[0] then
            call CreateFogTimed(CreateFogModifierRadius(udg_team1[1],FOG_OF_WAR_VISIBLE,GetUnitX(u),GetUnitY(u),128,true,false),1)
        elseif GetOwningPlayer(GetTriggerUnit())==udg_team2[0] then
            call CreateFogTimed(CreateFogModifierRadius(udg_team2[1],FOG_OF_WAR_VISIBLE,GetUnitX(u),GetUnitY(u),128,true,false),1)
        endif
    endif
    set u=null
    return false
endfunction

function Trig_Observer_Support_Actions takes nothing returns nothing
	local trigger t
	if udg_observer_slot_used then
        debug call BJDebugMsg("Observers playing!")
        //*** Order ***
		set t=CreateTrigger()
		call TriggerRegisterPlayerUnitEvent(t,udg_team1[0],EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER,null)
		call TriggerRegisterPlayerUnitEvent(t,udg_team2[0],EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER,null)
		call TriggerAddCondition(t,Condition(function IsMoveOrder))
		//*** In Range ***
        set t=CreateTrigger()
		call GroupEnumUnitsOfPlayer(ENUM,udg_team1[0],null)
		loop
			set enumUnit=FirstOfGroup(ENUM)
			exitwhen enumUnit==null
			call GroupRemoveUnit(ENUM,enumUnit)
			if GetUnitAcquireRange(enumUnit)!=0 then
				call TriggerRegisterUnitInRange(t,enumUnit,600,null)
			endif
		endloop
		call GroupClear(ENUM)
		call GroupEnumUnitsOfPlayer(ENUM,udg_team2[0],null)
		loop
			set enumUnit=FirstOfGroup(ENUM)
			exitwhen enumUnit==null
			call GroupRemoveUnit(ENUM,enumUnit)
			if GetUnitAcquireRange(enumUnit)!=0 and IsUnitType(enumUnit,UNIT_TYPE_STRUCTURE)then
				call TriggerRegisterUnitInRange(t,enumUnit,600,null)
			endif
		endloop
		call TriggerAddCondition(t,Condition(function Observer_Support_InRange_Action))
        //*** Attack ***
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ATTACKED,function IsUnitFoggedToAnyTeam)
        call GroupClear(ENUM)
        set t=null
	endif
    call DestroyTimer(GetExpiredTimer())
endfunction

function StartTrigger_Observer_Support takes nothing returns nothing
    call TimerStart(CreateTimer(),2,false,function Trig_Observer_Support_Actions)
endfunction