// Use by function 'Call Fade(whichUnit)', used in Killer B's Seven Sword Dance and Lariat for fading afterimages effect.
// No additional setup is required 

library Fade

    globals
        private constant hashtable HASH = InitHashtable()
        private constant integer ALPHA_PER_TICK = 40
        private constant real UPDATE_INTERVAL = 0.08
    endglobals

    function UpdateFade takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local integer alpha = LoadInteger(HASH, id, 0)-ALPHA_PER_TICK
        if alpha > 0 then
            call SetUnitVertexColor(LoadUnitHandle(HASH, id, 1), 180, 180, 180, alpha)
            call SaveInteger(HASH, GetHandleId(t), 0, alpha)
        else
            call RemoveUnit(LoadUnitHandle(HASH, id, 1))
            call FlushChildHashtable(HASH, GetHandleId(t))
            call DestroyTimer(t)
        endif
        set t = null
    endfunction

    function Fade takes unit u returns nothing
        local timer t = CreateTimer()
        call SaveInteger(HASH, GetHandleId(t), 0, 250)
        call SaveUnitHandle(HASH, GetHandleId(t), 1, u)
        call TimerStart (t, UPDATE_INTERVAL, true, function UpdateFade)
        set t = null
    endfunction

endlibrary