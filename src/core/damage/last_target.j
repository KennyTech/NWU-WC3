library LastTarget initializer init requires TimerUtils

    function GetLastTarget takes unit whichUnit returns unit
        return LoadUnitHandle(HT,GetHandleId(whichUnit),105)
    endfunction
    
    private function onAttack takes nothing returns boolean
        call SaveAgentHandle(HT,GetHandleId(GetAttacker()),105,GetTriggerUnit())
        return false
    endfunction

    private function init takes nothing returns nothing
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ATTACKED,function onAttack)
    endfunction

endlibrary