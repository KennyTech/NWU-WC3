scope UpperPortalEnter initializer init
    function UpperPortal_Enter takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local real x = GetRectCenterX(gg_rct_Portal_Down)
        local real y = GetRectCenterY(gg_rct_Portal_Down)
        if GetUnitAbilityLevel(u,'Aloc')==0 and GetUnitBullets(u)==0 then
            call DisableTrigger( gg_trg_Hero_Enters_Lower_Portal )
            call RemoveProjectiles(u)
            call SetUnitX(u,x)
            call SetUnitY(u,y)
            call PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0)
            call TriggerSleepAction(0.1)
            call EnableTrigger( gg_trg_Hero_Enters_Lower_Portal )
        endif
        set u = null
    endfunction

    private nothing init(){
        set gg_trg_Hero_Enters_Upper_Portal = CreateTrigger(  )
        call TriggerRegisterEnterRectSimple( gg_trg_Hero_Enters_Upper_Portal, gg_rct_Portal_Up )
        call TriggerAddAction( gg_trg_Hero_Enters_Upper_Portal, function UpperPortal_Enter )
    }
endscope