scope Leaver initializer init

    private function onLeave takes nothing returns boolean
        call DropPlayer(GetTriggerPlayer(),true)
        return false
    endfunction

    private nothing init(){
        local trigger t=CreateTrigger()
        local integer i=1
        loop
            call TriggerRegisterPlayerEvent(t,udg_team1[i],EVENT_PLAYER_LEAVE)
            call TriggerRegisterPlayerEvent(t,udg_team2[i],EVENT_PLAYER_LEAVE)
            set i = i + 1
            exitwhen i>5
        endloop
        call TriggerAddCondition(t,Condition(function onLeave))
    }
    
endscope