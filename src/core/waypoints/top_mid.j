scope TopMid initializer init
    function Trig_Upper_Line_Middle_Move_Actions takes nothing returns nothing
        local unit u = GetTriggerUnit()
        if GetOwningPlayer(u)==udg_team1[0]  then
            call SetUnitAbilityLevel(u,'A0GU',7)
            call SetNextWayPoint(u)
        elseif GetOwningPlayer(u)==udg_team2[0]  then
            call SetUnitAbilityLevel(u,'A0GU',3)
            call SetNextWayPoint(u)
        endif
        set u = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Upper_Line_Middle_Move = CreateTrigger(  )
        call TriggerRegisterEnterRectSimple( gg_trg_Upper_Line_Middle_Move, gg_rct_Path_Upper_Middle )
        call TriggerAddAction( gg_trg_Upper_Line_Middle_Move, function Trig_Upper_Line_Middle_Move_Actions )
    endfunction
endscope