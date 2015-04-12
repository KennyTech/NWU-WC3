scope Players

    private function filtro takes unit u returns boolean
        return true
    endfunction

    private function cambiarDuenosFilter takes nothing returns boolean
        local unit u=GetFilterUnit()
        if(GetOwningPlayer(u)==Player(0))then
            call SetUnitOwner(u,udg_team1[0],false)
            call SetUnitColor(u,ConvertPlayerColor(0))
        else
            call SetUnitOwner(u,udg_team2[0],false)
            call SetUnitColor(u,ConvertPlayerColor(6))
        endif
        set u=null
        return false
    endfunction

    private function cambiarDuenos takes nothing returns nothing
        call GroupEnumUnitsOfPlayer(ENUM,Player(0),Condition(function cambiarDuenosFilter))
        call GroupEnumUnitsOfPlayer(ENUM,Player(6),Condition(function cambiarDuenosFilter))
    endfunction
    
    public function colores takes nothing returns nothing
        local integer G2I
        local integer G3I
        local integer i
        set Color[GetPlayerId(udg_team1[0])]="|c00ff0303"
        set Color[GetPlayerId(udg_team1[1])]="|c000042ff"
        set Color[GetPlayerId(udg_team1[2])]="|c001ce6b9"
        set Color[GetPlayerId(udg_team1[3])]="|c00540081"
        set Color[GetPlayerId(udg_team1[4])]="|c00fffc01"
        set Color[GetPlayerId(udg_team1[5])]="|c00ff8000"
        set Color[GetPlayerId(udg_team2[0])]="|c0020c000"
        set Color[GetPlayerId(udg_team2[1])]="|c00e55bb0"
        set Color[GetPlayerId(udg_team2[2])]="|c00959697"
        set Color[GetPlayerId(udg_team2[3])]="|c007ebff1"
        set Color[GetPlayerId(udg_team2[4])]="|c00106246"
        set Color[GetPlayerId(udg_team2[5])]="|c004e2a04"
        // moscas
        
        
        call SetPlayerColor(udg_team1[0],PLAYER_COLOR_RED)
        call SetPlayerColor(udg_team1[1],PLAYER_COLOR_BLUE)
        call SetPlayerColor(udg_team1[2],PLAYER_COLOR_CYAN)
        call SetPlayerColor(udg_team1[3],PLAYER_COLOR_PURPLE)
        call SetPlayerColor(udg_team1[4],PLAYER_COLOR_YELLOW)
        call SetPlayerColor(udg_team1[5],PLAYER_COLOR_ORANGE)
        call SetPlayerColor(udg_team2[0],PLAYER_COLOR_GREEN)
        call SetPlayerColor(udg_team2[1],PLAYER_COLOR_PINK)
        call SetPlayerColor(udg_team2[2],PLAYER_COLOR_LIGHT_GRAY)
        call SetPlayerColor(udg_team2[3],PLAYER_COLOR_LIGHT_BLUE)
        call SetPlayerColor(udg_team2[4],PLAYER_COLOR_AQUA)
        call SetPlayerColor(udg_team2[5],PLAYER_COLOR_BROWN)
        set G2I=1
        set G3I=5
        loop
            if GetPlayerSlotState(udg_team1[G2I])==PLAYER_SLOT_STATE_EMPTY then
                call SetPlayerName(udg_team1[G2I],GetObjectName('e016')+" "+I2S(G2I))
            else
                set udg_PlayerRealName[GetPlayerId(udg_team1[G2I])] = GetPlayerName(udg_team1[G2I])
            endif
            if GetPlayerSlotState(udg_team2[G2I])==PLAYER_SLOT_STATE_EMPTY then
                call SetPlayerName(udg_team2[G2I],GetObjectName('e016')+" "+I2S(5+G2I))
            else
                set udg_PlayerRealName[GetPlayerId(udg_team2[G2I])] = GetPlayerName(udg_team2[G2I])
            endif
            set G2I=G2I+1
            exitwhen G2I>G3I
        endloop
    endfunction
    
    private function circles takes nothing returns nothing
        //------------------------ PLAYER CIRCLE ------------------------
        local integer NPI=125
        local integer i
        call SetUnitOwner(gg_unit_n01K_0019,udg_team1[1],false)
        call SetUnitOwner(gg_unit_n01K_0018,udg_team1[2],false)
        call SetUnitOwner(gg_unit_n01K_0020,udg_team1[3],false)
        call SetUnitOwner(gg_unit_n01K_0016,udg_team1[4],false)
        call SetUnitOwner(gg_unit_n01K_0021,udg_team1[5],false)
        call SetUnitOwner(gg_unit_n01K_0082,udg_team2[1],false)
        call SetUnitOwner(gg_unit_n01K_0083,udg_team2[2],false)
        call SetUnitOwner(gg_unit_n01K_0072,udg_team2[3],false)
        call SetUnitOwner(gg_unit_n01K_0084,udg_team2[4],false)
        call SetUnitOwner(gg_unit_n01K_0080,udg_team2[5],false)
        set udg_PlayerCircle[GetPlayerId(udg_team1[1])]=gg_unit_n01K_0019
        set udg_PlayerCircle[GetPlayerId(udg_team1[2])]=gg_unit_n01K_0018
        set udg_PlayerCircle[GetPlayerId(udg_team1[3])]=gg_unit_n01K_0020
        set udg_PlayerCircle[GetPlayerId(udg_team1[4])]=gg_unit_n01K_0016
        set udg_PlayerCircle[GetPlayerId(udg_team1[5])]=gg_unit_n01K_0021
        set udg_PlayerCircle[GetPlayerId(udg_team2[1])]=gg_unit_n01K_0082
        set udg_PlayerCircle[GetPlayerId(udg_team2[2])]=gg_unit_n01K_0083
        set udg_PlayerCircle[GetPlayerId(udg_team2[3])]=gg_unit_n01K_0072
        set udg_PlayerCircle[GetPlayerId(udg_team2[4])]=gg_unit_n01K_0084
        set udg_PlayerCircle[GetPlayerId(udg_team2[5])]=gg_unit_n01K_0080

        set i=1
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=2
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=3
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=4
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=5
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=7
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=8
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=9
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=10
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
        set i=11
        if GetLocalPlayer()==Player(i)then
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,255)
        else
            call SetUnitVertexColor(udg_PlayerCircle[GetPlayerId(Player(i))],255,255,255,NPI)
        endif
    endfunction
    
    private function host takes nothing returns nothing
        local integer x=0
        set udg_Host=null
        loop
            exitwhen x>5
            if IsPlayerHuman(udg_team1[x]) then
                set udg_Host=udg_team1[x]
                set x=5
            endif
            set x=x+1
        endloop
        if udg_Host==null then
            set x=0
            loop
                exitwhen x>5
                if IsPlayerHuman(udg_team2[x]) then
                    set udg_Host=udg_team2[x]
                    set x=5
                endif
                set x=x+1
            endloop
        endif
    endfunction
    
    public function alianzas takes nothing returns nothing
        local integer x=0
        local integer y=0
        set x=0
        loop
            exitwhen x>5
            loop
                exitwhen y>5
                if(x!=y)then
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(0),true)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(1),true)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(2),true)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(3),true)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(4),true)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(5),true)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(6),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team1[y],ConvertAllianceType(7),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(0),true)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(1),true)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(2),true)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(3),true)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(4),true)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(5),true)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(6),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team2[y],ConvertAllianceType(7),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(0),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(1),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(2),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(3),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(4),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(5),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(6),false)
                    call SetPlayerAlliance(udg_team1[x],udg_team2[y],ConvertAllianceType(7),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(0),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(1),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(2),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(3),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(4),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(5),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(6),false)
                    call SetPlayerAlliance(udg_team2[x],udg_team1[y],ConvertAllianceType(7),false)
                endif
                set y=y+1
            endloop
            set y=0
            set x=x+1
        endloop
        set x=0
        loop
            exitwhen x>5
            call SetPlayerTeam(udg_team1[x],0)
            call SetPlayerTeam(udg_team2[x],1)
            set x=x+1
        endloop
    endfunction
    
    public function iniciacion takes nothing returns nothing
        local integer x=0
        local integer y=0
        //------------------------ OBSERVERS ------------------------
        if GetPlayerState(udg_team1[0],PLAYER_STATE_OBSERVER)!=0 or GetPlayerState(udg_team2[0],PLAYER_STATE_OBSERVER)!=0 then
            set udg_observer_slot_used=true
            set udg_team1[0]=Player(13)
            set udg_team2[0]=Player(14)
            set udg_observer1=Player(0)
            set udg_observer2=Player(6)
            call SetAllyColorFilterState(0)
            loop
                exitwhen x>5
                call SetPlayerAlliance(Player(0),udg_team1[x],ConvertAllianceType(0),true)
                call SetPlayerAlliance(Player(0),udg_team1[x],ConvertAllianceType(4),true)
                call SetPlayerAlliance(Player(0),udg_team2[x],ConvertAllianceType(0),false)
                call SetPlayerAlliance(Player(0),udg_team2[x],ConvertAllianceType(4),false)
                set x=x+1
            endloop
        endif
        //------------------------ ALIANZAS ------------------------
        call alianzas()
        set x=0
        loop
            exitwhen x>5
            if IsPlayerHuman(udg_team1[x]) then
                set udg_PlayersLeft1=udg_PlayersLeft1+1
            endif
            if IsPlayerHuman(udg_team2[x]) then
                set udg_PlayersLeft2=udg_PlayersLeft2+1
            endif
            set x=x+1
        endloop
        //------------------------ SINGLE MODE ------------------------
        if udg_PlayersLeft1+udg_PlayersLeft2==1 then
            set udg_SingleMode = true
        endif
        call host()
       //------------------------ NOMBRES ------------------------
        
        call SetPlayerName(udg_team1[0],GetObjectName('e015'))
        call SetPlayerName(udg_team2[0],GetObjectName('e014'))
        //call SetPlayerName(udg_player01,GetObjectName(1848657208))
        
        call circles()
        
        //------------------------ CAMBIAR DUEÑOS SI ES NECESARIO ------------------------
        if(udg_team1[0]!=Player(0) or udg_team2[0]!=Player(6))then
            call cambiarDuenos()
        endif
        
        //------------------------ RECURSOS ------------------------
        set x=0
        loop
            exitwhen x>5
            if(IsPlayerHuman(udg_team1[x]))then
                call SetPlayerState(udg_team1[x],PLAYER_STATE_RESOURCE_GOLD,1000)
                call SetPlayerState(udg_team1[x],PLAYER_STATE_RESOURCE_LUMBER,0)
            endif
            if(IsPlayerHuman(udg_team2[x]))then
                call SetPlayerState(udg_team2[x],PLAYER_STATE_RESOURCE_GOLD,1000)
                call SetPlayerState(udg_team2[x],PLAYER_STATE_RESOURCE_LUMBER,0)
            endif
            set x=x+1
        endloop
        
        call colores()
        
        //------------------------ HANDICAP XP AP-RANDOM-REQS ------------------------
        set x=1
        loop
            exitwhen x>5
            call SetPlayerHandicapXP(udg_team1[x],1)
            call SetPlayerHandicapXP(udg_team2[x],1)
            call SetPlayerHandicap(udg_team1[x],1)
            call SetPlayerHandicap(udg_team2[x],1)
            call SetPlayerTechResearched(udg_team1[x],'R000',1)
            call SetPlayerTechResearched(udg_team2[x],'R002',1)
            call SetPlayerTechMaxAllowed(udg_team1[x],'HERO',1)
            call SetPlayerTechMaxAllowed(udg_team2[x],'HERO',1)
            set x=x+1
        endloop
        
        //------------------------ BOUNTY ------------------------
        call SetPlayerState(udg_team1[0],PLAYER_STATE_GIVES_BOUNTY,1)
        call SetPlayerState(udg_team2[0],PLAYER_STATE_GIVES_BOUNTY,1)
        
        //------------------------ NO TRADING ------------------------
        call SetMapFlag( MAP_LOCK_RESOURCE_TRADING, true )
    endfunction
    
    function StartTrigger_Player takes nothing returns nothing
        call iniciacion()
    endfunction
endscope