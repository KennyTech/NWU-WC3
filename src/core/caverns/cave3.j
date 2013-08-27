scope Cave3 initializer init
    function Cave3_Enter takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local real x = GetRectCenterX(gg_rct_Kyuubi_Cave_Entrance2)
        local real y = GetRectCenterY(gg_rct_Kyuubi_Cave_Entrance2)
        if GetUnitAbilityLevel(u,'Aloc')==0 and GetUnitTypeId(u)!='n01J' and GetUnitBullets(u)==0   then
            call DisableTrigger( gg_trg_Unit_Enters_Kyuubi_Cave2 )
            call RemoveProjectiles(u)
            call SetUnitX(u,x)
            call SetUnitY(u,y)
            call PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0)
            call IssuePointOrderById(u,851986,x,y)
            call TriggerSleepAction(0.1)
            call EnableTrigger( gg_trg_Unit_Enters_Kyuubi_Cave2 )
        endif
        set u = null
    endfunction

    private nothing init(){
        set gg_trg_Unit_Enters_Kyuubi_Cave3 = CreateTrigger(  )
        call TriggerRegisterEnterRectSimple( gg_trg_Unit_Enters_Kyuubi_Cave3, gg_rct_Kyuubi_Cave_Entrance3 )
        call TriggerAddAction( gg_trg_Unit_Enters_Kyuubi_Cave3, function Cave3_Enter )
    }
endscope