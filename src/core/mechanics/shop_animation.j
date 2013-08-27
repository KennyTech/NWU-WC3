scope ShopAnimation initializer init

/*
    private function endAnimation takes nothing returns nothing
        local timer t=GetExpiredTimer()
        local string s=""
        local player p=LoadPlayerHandle(HT,GetHandleId(t),0)
        local unit u=GetTimerUnit()
        if GetLocalPlayer()==p then
            set s="stand"
        endif
        call SetUnitAnimation(u,s)
        call RemoveSavedBoolean(HT,GetHandleId(p),GetHandleId(u))
        call ReleaseTimer(t)
        set t=null
    endfunction
    
    private function GetTime takes integer id returns real
        if id==ARTISAN then
            return 3.0
        elseif id=='n00Q' then
            return 5.2
        elseif id=='n011' then
            return 3.0
        elseif id=='n013' then
            return 3.0
        elseif id=='n01I' then
            return 3.7
        elseif id=='n01O' then
            return 5.267
        elseif id=='n01P' then
            return 2.0
        else
            return 2.5
        endif
    endfunction

    private function onSelect takes nothing returns boolean
        local string s=""
        local player p=GetTriggerPlayer()
        local timer t
        local unit u=GetTriggerUnit()
        if GetUnitPointValue(u)==1000 and LoadBoolean(HT,GetHandleId(p),GetHandleId(u))==false then
            if GetLocalPlayer()==p and GetPlayerController(p) == MAP_CONTROL_USER and GetPlayerSlotState(p)==PLAYER_SLOT_STATE_PLAYING then
                set s="stand"
            endif
            call SetUnitAnimationWithRarity(GetTriggerUnit(),s,RARITY_RARE)
            call SaveBoolean(HT,GetHandleId(p),GetHandleId(u),true)
            set t=NewTimerUnit(u)
            call SaveAgentHandle(HT,GetHandleId(t),0,p)
            call TimerStart(t,GetTime(GetUnitTypeId(u)),false,function endAnimation)
            set t=null
        endif
        set p=null
        return false
    endfunction
*/    
    private function onDeselect takes nothing returns boolean
        if GetUnitPointValue(GetTriggerUnit())==1000 and GetLocalPlayer()==GetTriggerPlayer() then
            call SetUnitAnimation(GetTriggerUnit(), "stand")
        endif
        return false
    endfunction
    
    private function onSelect takes nothing returns boolean
        local unit u=GetTriggerUnit()
        local string anim=""
        local integer id=GetUnitTypeId(u)
        if GetUnitPointValue(u)==1000 and GetLocalPlayer() == GetTriggerPlayer() then
            if id==ARTISAN then
                set anim="stand work"
            elseif id=='n00Q' then
                set anim="stand 3"
            elseif id=='n012' then
                set anim="spell slam"
            elseif id=='n013' then
                set anim="stand 3"
            elseif id=='n01I' then
                set anim="stand victory"
            elseif id=='n01O' then
                set anim="stand victory"
            elseif id=='n01P' then
                set anim="stand victory"
            elseif id=='n01Q' then
                set anim="stand victory"
            endif
            if anim!="" then
                call SetUnitAnimation(u,anim)
                call QueueUnitAnimation(u,anim)
            endif
        endif
        set u=null
        return false
    endfunction

    private nothing init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_SELECTED,function onSelect)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DESELECTED,function onDeselect)
    }
endscope