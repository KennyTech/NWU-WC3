scope TeamSell initializer init 
    function Trig_Team_Sell_Actions takes nothing returns boolean
        local player p = GetItemPlayer(GetSoldItem())
        local integer index = 1
        local integer gold
        debug call BJDebugMsg(I2S(GetPlayerId(p)))
        if IsPlayerLeaver(p) then
            set gold = GetItemGoldCost(GetSoldItem())/2
            loop
                if IsPlayerAlly(p,udg_team1[0]) then
                    if IsPlayerHuman(udg_team1[index]) and IsPlayerLeaver(udg_team1[index])==false then
                        call SetPlayerState(udg_team1[index], PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(udg_team1[index], PLAYER_STATE_RESOURCE_GOLD) + gold/udg_PlayersLeft1)
                    endif
                else
                    if IsPlayerHuman(udg_team2[index]) and IsPlayerLeaver(udg_team2[index])==false then
                        call SetPlayerState(udg_team2[index], PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(udg_team2[index], PLAYER_STATE_RESOURCE_GOLD) + gold/udg_PlayersLeft2)
                    endif       
                endif
                set index=index+1
                exitwhen index>5
            endloop
            call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)-gold)
        endif
        return false
    endfunction

    private nothing init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_PAWN_ITEM,function Trig_Team_Sell_Actions)
    }
endscope