scope PeriodicGold initializer init
    function Periodic_Gold takes nothing returns nothing
        local integer index=1
        loop
            if IsPlayerLeaver(udg_team1[index])==false and GetPlayerSlotState(udg_team1[index]) == PLAYER_SLOT_STATE_PLAYING  then
                call SetPlayerState(udg_team1[index],PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(udg_team1[index], PLAYER_STATE_RESOURCE_GOLD)+udg_PeriodicGold)
            endif
            if IsPlayerLeaver(udg_team2[index])==false and GetPlayerSlotState(udg_team2[index]) == PLAYER_SLOT_STATE_PLAYING  then
                call SetPlayerState(udg_team2[index],PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(udg_team2[index], PLAYER_STATE_RESOURCE_GOLD)+udg_PeriodicGold)
            endif
            set index=index+1
            exitwhen index>5
        endloop
    endfunction

    function Periodic_Gold_Actions takes nothing returns nothing
        call PauseTimer(GetExpiredTimer())
        call TimerStart(GetExpiredTimer(),0.87,true,function Periodic_Gold)
        if udg_GameExpMode == 0 then
            set udg_PeriodicGold=1
        else
            set udg_PeriodicGold=2
        endif
    endfunction

    //===========================================================================
    private nothing init(){
        call TimerStart(CreateTimer(),90,false,function Periodic_Gold_Actions)
    }
endscope