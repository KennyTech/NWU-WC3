scope KonohaVictory initializer Init

    function Trig_Victory_Konoha_Conditions takes nothing returns boolean
        if ( not ( GetTriggerUnit() == gg_unit_h00P_0085 ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Victory_Konoha_Func001002 takes nothing returns nothing
        call CustomVictoryBJ( GetEnumPlayer(), true, true )
        call FlagPlayer(GetEnumPlayer(), FLAG_WINNER)
    endfunction

    function Trig_Victory_Konoha_Func002002 takes nothing returns nothing
        call CustomDefeatBJ( GetEnumPlayer(), "TRIGSTR_2271" )
        call FlagPlayer(GetEnumPlayer(), MMD_FLAG_LOSER)
    endfunction

    function Trig_Victory_Konoha_Actions takes nothing returns nothing
        call ForForce( GetPlayersAllies(udg_team1[0]), function Trig_Victory_Konoha_Func001002 )
        call ForForce( GetPlayersAllies(udg_team2[0]), function Trig_Victory_Konoha_Func002002 )
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_DEATH )
        call TriggerAddCondition( t, Condition( function Trig_Victory_Konoha_Conditions ) )
        call TriggerAddAction( t, function Trig_Victory_Konoha_Actions )
    endfunction

endscope