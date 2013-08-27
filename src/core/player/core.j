library PlayerCore

    globals
        string array Color
        private boolean array dropped
        private boolean array Reviving
    endglobals
    //=======================================================================
    function ShowTextToForce takes force f,real dur,string msg returns nothing
        if(IsPlayerInForce(GetLocalPlayer(),f))then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,dur,msg)
        endif
    endfunction
    //=======================================================================
    function IsPlayerHuman takes player p returns boolean
        if(GetPlayerSlotState(p)==PLAYER_SLOT_STATE_PLAYING)then
            if(GetPlayerController(p)==MAP_CONTROL_USER)then
                return true
            endif
        endif
        return false
    endfunction
    function IsPlayerObs takes player p returns boolean
        return udg_observer_slot_used and (p==udg_observer1 or p==udg_observer2)
    endfunction
    function IsPlayerLeaver takes player p returns boolean
        return udg_PlayerLeaver[GetPlayerId(p)+1]
    endfunction
    function IsUnitSoldierCreep takes unit u returns boolean
        return GetOwningPlayer(u)==udg_team1[0] or GetOwningPlayer(u)==udg_team2[0]
    endfunction
    //=======================================================================
    function GetPlayerNameColored takes player p returns string
        return Color[GetPlayerId(p)]+GetPlayerName(p)+"|r"
    endfunction
    //=======================================================================
    function GetPlayerStringColored takes player p, string s returns string
        return Color[GetPlayerId(p)]+s+"|r"
    endfunction
    //=======================================================================
    function IsHeroReviving takes player p returns boolean
        return Reviving[GetPlayerId(p)] 
    endfunction
    //=======================================================================
    function SetHeroReviving takes player p,boolean is returns nothing
        set Reviving[GetPlayerId(p)] = is
    endfunction
    //=======================================================================
    function GetPlayerHero takes player whichPlayer returns unit
        return udg_PlayerHero[GetPlayerId(whichPlayer)+1]
    endfunction
    function GetPlayerCircle takes player whichPlayer returns unit
        return udg_PlayerCircle[GetPlayerId(whichPlayer)] 
    endfunction
    //=======================================================================
    function GetNeutral takes player p returns player
        if IsPlayerAlly(p,udg_team1[0]) then
            return udg_team1[0]
        endif
        return udg_team2[0]
    endfunction
    //=======================================================================
    function DropPlayer takes player target,boolean leaving returns nothing
        local integer gold=GetPlayerState(target,PLAYER_STATE_RESOURCE_GOLD)
        local integer index=1
        //*** DISMINUIR PLAYER LEFT***
        if IsPlayerAlly(target,udg_team1[0]) then
            set udg_PlayersLeft1=udg_PlayersLeft1-1
            set gold=gold/udg_PlayersLeft1
        else
            set udg_PlayersLeft2=udg_PlayersLeft2-1
            set gold=gold/udg_PlayersLeft2
        endif
        //*** MENSAJES ***
        set udg_PlayerLeaver[GetPlayerId(target)+1] = true
        call StartSound(gg_snd_CreepAggroWhat1)
        if leaving then
            call ShowTextToForce(bj_FORCE_ALL_PLAYERS,10,GetPlayerNameColored(target)+"|r  has left the game.")
        else
            call ShowTextToForce(bj_FORCE_ALL_PLAYERS,10,GetPlayerNameColored(target)+"|r  has been dropped from the game.")
        endif
        //*** ASIGNAR RECURSOS***
        loop
            if IsPlayerAlly(target,udg_team1[0]) then
                call SetPlayerState(udg_team1[index],PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(udg_team1[index], PLAYER_STATE_RESOURCE_GOLD)+gold)
                call SetPlayerAlliance(target,udg_team1[index], ALLIANCE_SHARED_CONTROL, true)
                //call SetPlayerAlliance(target,udg_team1[index], ALLIANCE_SHARED_ADVANCED_CONTROL, true)
            else
                call SetPlayerState(udg_team2[index],PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(udg_team2[index], PLAYER_STATE_RESOURCE_GOLD)+gold)
                call SetPlayerAlliance(target,udg_team2[index], ALLIANCE_SHARED_CONTROL, true)
                //call SetPlayerAlliance(target,udg_team2[index], ALLIANCE_SHARED_ADVANCED_CONTROL, true)
            endif
            set index=index+1
            exitwhen index>5
        endloop
        call SetPlayerState(target,PLAYER_STATE_RESOURCE_GOLD,0)
    endfunction
    //=======================================================================
    function Defeat takes player p returns nothing
        if AllowVictoryDefeat( PLAYER_GAME_RESULT_DEFEAT ) then
            call RemovePlayer( p, PLAYER_GAME_RESULT_DEFEAT )
            if (GetPlayerController(p) == MAP_CONTROL_USER) then
                call CustomDefeatDialogBJ( p, "You have been kicked for being AFK!" )
            endif
        endif
    endfunction
    //=======================================================================
    private struct Init extends array
        static method onInit takes nothing returns nothing
            local integer i=0
            set udg_team1[0]  = Player(0)
            set udg_team1[1]  = Player(1)
            set udg_team1[2]  = Player(2)
            set udg_team1[3]  = Player(3)
            set udg_team1[4]  = Player(4)
            set udg_team1[5]  = Player(5)
            set udg_team2[0]  = Player(6)
            set udg_team2[1]  = Player(7)
            set udg_team2[2]  = Player(8)
            set udg_team2[3]  = Player(9)
            set udg_team2[4]  = Player(10)
            set udg_team2[5]  = Player(11)
            set Color[0]  = "|CFFFF0303" // red
            set Color[1]  = "|CFF0042FF" // blue
            set Color[2]  = "|CFF1CE6B9" // teal
            set Color[3]  = "|CFF540081" // purple
            set Color[4]  = "|CFFFFFF01" // yellow
            set Color[5]  = "|CFFFE8A0E" // orange
            set Color[6]  = "|CFF20C000" // green
            set Color[7]  = "|CFFE55BB0" // pink
            set Color[8]  = "|CFF959697" // grey
            set Color[9]  = "|CFF7EBFF1" // light blue
            set Color[10] = "|CFF106246" // dark green
            set Color[11] = "|CFF4E2A04" // brown
        endmethod
    endstruct

endlibrary