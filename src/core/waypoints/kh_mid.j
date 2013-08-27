scope KhMid initializer init
    function Trig_Middle_Line_Konoha_Move_Actions takes nothing returns nothing
        local unit u = GetTriggerUnit()
        if GetOwningPlayer(u)==udg_team1[0]  then
            call SetUnitAbilityLevel(u,'A0GU',9)
            call SetNextWayPoint(u)
        elseif GetOwningPlayer(u)==udg_team2[0]  then
            call SetUnitAbilityLevel(u,'A0GU',2)
            call SetNextWayPoint(u)
        endif
        set u = null
    endfunction

    //===========================================================================
    private nothing init(){
        set gg_trg_Middle_Line_Konoha_Move = CreateTrigger(  )
        call TriggerRegisterEnterRectSimple( gg_trg_Middle_Line_Konoha_Move, gg_rct_Path_Middle_Konoha )
        call TriggerAddAction( gg_trg_Middle_Line_Konoha_Move, function Trig_Middle_Line_Konoha_Move_Actions )
    }
endscope