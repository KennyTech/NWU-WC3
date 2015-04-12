scope VictoryShinobi initializer Init

    function Trig_Victory_Shinobi_Conditions takes nothing returns boolean
        if ( not ( GetTriggerUnit() == gg_unit_h00Q_0009 ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Victory_Shinobi_Func001002 takes nothing returns nothing
        call CustomDefeatBJ( GetEnumPlayer(), "TRIGSTR_4684" )
        call FlagPlayer(GetEnumPlayer(), MMD_FLAG_LOSER)
    endfunction

    function Trig_Victory_Shinobi_Func002002 takes nothing returns nothing
        call CustomVictoryBJ( GetEnumPlayer(), true, true )
        call FlagPlayer(GetEnumPlayer(), MMD_FLAG_WINNER)
    endfunction

    function Trig_Victory_Shinobi_Actions takes nothing returns nothing
        call ForForce( GetPlayersAllies(udg_team1[0]), function Trig_Victory_Shinobi_Func001002 )
        call ForForce( GetPlayersAllies(udg_team2[0]), function Trig_Victory_Shinobi_Func002002 )
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_DEATH )
        call TriggerAddCondition( t, Condition( function Trig_Victory_Shinobi_Conditions ) )
        call TriggerAddAction( t, function Trig_Victory_Shinobi_Actions )
    endfunction

endscope