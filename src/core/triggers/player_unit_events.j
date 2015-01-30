library RegisterPlayerUnitEvent

    globals
        private trigger array t
    endglobals
    
    function GT_RegisterPlayerEventAction takes playerunitevent p, code c returns nothing
        local integer i = GetHandleId(p)
        local integer k = 15
        if t[i] == null then
            set t[i] = CreateTrigger()
            loop
                call TriggerRegisterPlayerUnitEvent(t[i], Player(k), p, null)
                exitwhen k == 0
                set k = k - 1
            endloop
        endif
        call TriggerAddCondition(t[i], Filter(c))
    endfunction
    
    function GT_RegisterPlayerEvent takes trigger t,playerunitevent p returns nothing
        local integer i=0
        loop
            call TriggerRegisterPlayerUnitEvent(t, Player(i), p, null)
            exitwhen i==15
            set i=i+1
        endloop
    endfunction
    
endlibrary