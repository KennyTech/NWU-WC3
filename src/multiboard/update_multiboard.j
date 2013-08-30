library Multiboard initializer Init
    function setItemValue takes multiboard mb,integer c,integer r,string value returns nothing
        local multiboarditem mbi=null
        set mbi=MultiboardGetItem(mb,r-1,c-1)
        call MultiboardSetItemValue(mbi,value)
        call MultiboardReleaseItem(mbi)
    endfunction
    function MultiboardKill takes player p returns nothing
        local integer id=GetPlayerId(p)+1
        if udg_Multiboard_Row_For_Player[id]!=0 then
            call setItemValue(bj_lastCreatedMultiboard,3,udg_Multiboard_Row_For_Player[id],"|c00ff0303"+I2S(udg_Multiboard_Player_Kills[id]))
        endif
    endfunction
    function MultiboardDeath takes player p returns nothing
        local integer id=GetPlayerId(p)+1
        if udg_Multiboard_Row_For_Player[id]!=0 then
            call setItemValue(bj_lastCreatedMultiboard,4,udg_Multiboard_Row_For_Player[id],"|c000042ff"+I2S(udg_Multiboard_Player_Deaths[id]))
        endif
    endfunction
    function MultiboardAssist takes player p returns nothing
        local integer id=GetPlayerId(p)+1
        if udg_Multiboard_Row_For_Player[id]!=0 then
            call setItemValue(bj_lastCreatedMultiboard,5,udg_Multiboard_Row_For_Player[id],"|c0000ff42"+I2S(udg_Multiboard_Player_Assists[id]))
        endif
    endfunction
    function MultiboardTitle takes player p returns nothing
        local integer i=GetPlayerId(p)+1
        local string s="|c00a0a0a0("+I2S(udg_Multiboard_Player_Kills[i])+"/"+ I2S(udg_Multiboard_Player_Deaths[i])+"/"+I2S(udg_Multiboard_Player_Assists[i])+") - ("+ I2S(udg_PlayerCSKilled[i])+"/"+I2S(udg_PlayerCSDenied[i])+")" 
        if GetLocalPlayer() == p and udg_Multiboard_Row_For_Player[i]!=0 then
            call MultiboardSetTitleText( bj_lastCreatedMultiboard,s)
        endif
    endfunction
    //*** CAMBIAR TITULO ***
    private function ChangeTitleEnum takes nothing returns nothing
        call MultiboardTitle(GetEnumPlayer())
    endfunction
    private function ChangeTitle takes nothing returns nothing
        call ForForce(bj_FORCE_ALL_PLAYERS,function ChangeTitleEnum)
    endfunction
    private function Init takes nothing returns nothing
        call TimerStart(CreateTimer(),2,false,function ChangeTitle)
    endfunction
endlibrary