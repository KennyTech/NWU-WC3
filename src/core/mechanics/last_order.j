library LastOrder initializer Init
  function IsUnitCancelingOrders takes unit u returns boolean
     return LoadBoolean(udg_OldOrdersHashtable,GetHandleId(u),1)
  endfunction

  function AbortOrders takes unit u, boolean CancelOrder returns nothing
     call SaveBoolean(udg_OldOrdersHashtable,GetHandleId(u),1,CancelOrder)
  endfunction

  function GetUnitOldOrderType takes unit u, integer OrderNr returns integer
     return LoadInteger(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5))
  endfunction
  function GetUnitOldOrderID takes unit u, integer OrderNr returns integer
     return LoadInteger(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+1)
  endfunction
  function GetUnitOldOrderTarget takes unit u, integer OrderNr returns widget
     return LoadWidgetHandle(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+2)
  endfunction
  function GetUnitOldOrderX takes unit u, integer OrderNr returns real
     return LoadReal(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+3)
  endfunction
  function GetUnitOldOrderY takes unit u, integer OrderNr returns real
     return LoadReal(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+4)
  endfunction

  function SetUnitOldOrderType takes unit u, integer OrderNr, integer Type returns nothing
     call SaveInteger(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5),Type)
  endfunction
  function SetUnitOldOrderID takes unit u, integer OrderNr, integer ID returns nothing
     call SaveInteger(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+1,ID)
  endfunction
  function SetUnitOldOrderTarget takes unit u, integer OrderNr, widget Target returns nothing
     call SaveWidgetHandle(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+2,Target)
  endfunction
  function SetUnitOldOrderX takes unit u, integer OrderNr, real X returns nothing
     call SaveReal(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+3,X)
  endfunction
  function SetUnitOldOrderY takes unit u, integer OrderNr, real Y returns nothing
     call SaveReal(udg_OldOrdersHashtable,GetHandleId(u),2+(OrderNr*5)+4,Y)
  endfunction


  function CreateOrder takes unit u, integer OrderNr, integer OrderType, integer OrderID, widget Target, real X, real Y returns nothing
     local integer i = GetHandleId(u)

     set OrderNr = 2+(OrderNr*5)
     call SaveInteger      ( udg_OldOrdersHashtable, i, OrderNr  , OrderType )
     call SaveInteger      ( udg_OldOrdersHashtable, i, OrderNr+1, OrderID )
     if Target==null then
  //      call BJDebugMsg("LastOrder CreateOrder target == null")
        call RemoveSavedHandle( udg_OldOrdersHashtable, i, OrderNr+2 )
     endif
     call SaveWidgetHandle ( udg_OldOrdersHashtable, i, OrderNr+2, Target )
     call SaveReal         ( udg_OldOrdersHashtable, i, OrderNr+3, X )
     call SaveReal         ( udg_OldOrdersHashtable, i, OrderNr+4, Y )
  endfunction


  function IssueOldOrder takes unit u, integer OrderNr returns nothing
     local integer OrderType

  //   call DisableTrigger( gg_trg_LastOrder )
     if GetUnitTypeId(u)!=0 and IsUnitType(u, UNIT_TYPE_DEAD)==false then
        set OrderType = GetUnitOldOrderType(u,OrderNr)

  //      call DisplayTimedTextToForce( GetPlayersAll(), 10, "Issuing order: "+OrderId2StringBJ(GetUnitOldOrderID(u,OrderNr)) )

        if OrderType == 1 then //TARGET
           if GetUnitOldOrderTarget(u,OrderNr)!=null then
              call IssueTargetOrderById(u, GetUnitOldOrderID(u,OrderNr), GetUnitOldOrderTarget(u,OrderNr) )
           endif
        elseif OrderType == 2 then //POINT
           call IssuePointOrderById(u, GetUnitOldOrderID(u,OrderNr), GetUnitOldOrderX(u,OrderNr), GetUnitOldOrderY(u,OrderNr) )
        elseif OrderType == 3 then //IMMEDIATE
           call IssueImmediateOrderById(u, GetUnitOldOrderID(u,OrderNr) )
        endif
     endif
  //   call EnableTrigger( gg_trg_LastOrder )
  endfunction


  function LastOrder_Actions takes nothing returns nothing
     local unit   u = GetTriggerUnit()
     local widget t = GetOrderTarget()

  //   call BJDebugMsg(OrderId2StringBJ(GetIssuedOrderId())+" = "+I2S(GetIssuedOrderId()))

     //reemplazo past order con last order
     call CreateOrder(u, 1, GetUnitOldOrderType(u,0), GetUnitOldOrderID(u,0), GetUnitOldOrderTarget(u,0), GetUnitOldOrderX(u,0), GetUnitOldOrderY(u,0) )

     //create a new last order
     if GetTriggerEventId() == EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER then
  //      call BJDebugMsg("LastOrder Event TARGET Order ")
        call CreateOrder(u, 0, 1, GetIssuedOrderId(), t, GetWidgetX(t), GetWidgetY(t) )
     elseif GetTriggerEventId() == EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER then
  //      call BJDebugMsg("LastOrder Event POINT Order ")
        call CreateOrder(u, 0, 2, GetIssuedOrderId(), t, GetOrderPointX(), GetOrderPointY() )
     elseif GetTriggerEventId() == EVENT_PLAYER_UNIT_ISSUED_ORDER then
  //      call BJDebugMsg("LastOrder Event NOTARGET Order ")
        call CreateOrder(u, 0, 3, GetIssuedOrderId(), t, GetUnitX(u), GetUnitY(u) )
     endif

     if IsUnitCancelingOrders(u) then
  //      call BJDebugMsg( "Canceling order" )
  //      call DisableTrigger( gg_trg_LastOrder )
        call PauseUnit(u,true)
        call IssueImmediateOrder( u, "stop" )
        call PauseUnit(u,false)
  //      call EnableTrigger( gg_trg_LastOrder )
     endif

     set u = null
     set t = null
  endfunction


  function OnAdd takes nothing returns boolean
  //    call BJDebugMsg("Clear Unit Data")
      call FlushChildHashtable( udg_OldOrdersHashtable, GetHandleId(GetFilterUnit()) )
      return false
  endfunction

  //===========================================================================
  function LastOrder_Conditions takes nothing returns boolean
     //* Excludes specific orders or unit types from registering with the system
     //* 
     //* 851972: stop
     //*         Stop is excluded from the system because it is the order that
     //*         tells a unit to do nothing. It should be ignored by the system.
     //*
     //* 851971: smart
     //* 851986: move
     //* 851983: attack
     //* 851984: attackground
     //* 851985: attackonce
     //* 851990: patrol
     //* 851993: holdposition
     //*         These are the UI orders that are passed to the system.
     //*
     //* 851973: stunned
     //*         This order is issued when a unit is stunned onto the stunner
     //*         It's ignored by the system, since you'd never want to reissue it
     //* 
     //* >= 852055, <= 852762
     //*         These are all spell IDs from defend to incineratearrowoff with
     //*         a bit of leeway at the ends for orders with no strings.
     //* 
     local integer id = GetIssuedOrderId()
     return GetUnitAbilityLevel(GetTriggerUnit(),'Aloc')==0 and (id == 851971 or id == 851986 or id == 851983 or id == 851984 or id == 851990 or id == 851993 or (id >= 852055 and id <= 852762))
  endfunction
  private void Init(){
      local trigger trg // = CreateTrigger()
      local region  re  = CreateRegion()
      local rect    m   = GetWorldBounds()

  //    call BJDebugMsg("Init LastOrder")

      set udg_OldOrdersHashtable = InitHashtable()

      set gg_trg_LastOrder = CreateTrigger(  )
      call TriggerRegisterAnyUnitEventBJ( gg_trg_LastOrder, EVENT_PLAYER_UNIT_ISSUED_ORDER )
      call TriggerRegisterAnyUnitEventBJ( gg_trg_LastOrder, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER )
      call TriggerRegisterAnyUnitEventBJ( gg_trg_LastOrder, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER )
      call TriggerAddCondition(gg_trg_LastOrder, Condition( function LastOrder_Conditions ) )
      call TriggerAddAction( gg_trg_LastOrder, function LastOrder_Actions )

      //Entering world trigger that clears old data from handle ids
      set trg = CreateTrigger()
      call RegionAddRect(re, m)
      call TriggerRegisterEnterRegion(trg, re, Condition(function OnAdd))
      call RemoveRect(m)
  }
  endlibrary