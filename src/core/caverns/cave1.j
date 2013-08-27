scope Cave1 initializer init
    function Cave1_Enter takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local real x = GetRectCenterX(gg_rct_Kyuubi_Cave_Entrance4)
        local real y = GetRectCenterY(gg_rct_Kyuubi_Cave_Entrance4)
        if GetUnitAbilityLevel(u,'Aloc')==0 and GetUnitTypeId(u)!='n01J' and GetUnitBullets(u)==0  then
            call DisableTrigger( gg_trg_Unit_Enters_Kyuubi_Cave4 )
            call RemoveProjectiles(u)
            call SetUnitX(u,x)
            call SetUnitY(u,y)
            call PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0)
            call IssuePointOrderById(u,851986,x,y)
            call TriggerSleepAction(0.1)
            call EnableTrigger( gg_trg_Unit_Enters_Kyuubi_Cave4 )
        endif
        set u = null
    endfunction

    //===========================================================================
    private nothing init(){
        set gg_trg_Unit_Enters_Kyuubi_Cave1 = CreateTrigger(  )
        call TriggerRegisterEnterRectSimple( gg_trg_Unit_Enters_Kyuubi_Cave1, gg_rct_Kyuubi_Cave_Entrance1 )
        call TriggerAddAction( gg_trg_Unit_Enters_Kyuubi_Cave1, function Cave1_Enter )
    }
endscope