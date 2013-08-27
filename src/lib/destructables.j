library Destructables

    function KillDestructableEnum takes nothing returns nothing
        local integer TreeId = GetDestructableTypeId( GetEnumDestructable() )
        if TreeId=='LTlt' or TreeId=='VTlt' or TreeId=='ATtr' or TreeId=='ATtc' or TreeId=='BTtw' or TreeId=='BTtc' or TreeId=='ZTtw' or TreeId=='ZTtc' or TreeId=='FTtw' then
           call KillDestructable( GetEnumDestructable() )
        endif
    endfunction

    function EnumDestructablesInCircle takes real radius, real x,real y,code actionFunc returns nothing
        local rect r
        if (radius >= 0) then
            set r = Rect(x-radius,y-radius,x+radius,y+radius)
            call EnumDestructablesInRect(r, null, actionFunc)
            call RemoveRect(r)
        endif
        set r = null 
    endfunction

    function KillDestructablesInCircle takes real x,real y,real radius returns nothing
        call EnumDestructablesInCircle(radius,x,y,function KillDestructableEnum)
    endfunction

    function KillDestructableCount takes nothing returns nothing
        local integer TreeId = GetDestructableTypeId( GetEnumDestructable() )
        if GetDestructableLife(GetEnumDestructable()) > 0 and (TreeId=='LTlt' or TreeId=='VTlt' or TreeId=='ATtr' or TreeId=='ATtc' or TreeId=='BTtw' or TreeId=='BTtc' or TreeId=='ZTtw' or TreeId=='ZTtc' or TreeId=='FTtw') then
           set udg_CountDestructables = udg_CountDestructables + 1
           call KillDestructable(GetEnumDestructable())
        endif
    endfunction
    
    struct Dest extends array
        private static destructable array stack
        private static real array time
        private static integer size = 0
        private static timer t = CreateTimer()
        private static integer index = 0
        
        define private PERIOD = 1.0
        define private DELTA = 0.1
        
        private static method periodic takes nothing returns nothing
            thistype.index = 0
            whilenot(thistype.index>=thistype.size){
                thistype.time[thistype.index] -= PERIOD
                if(thistype.time[thistype.index] <= DELTA){
                    RemoveDestructable(thistype.stack[thistype.index])
                    thistype.size--
                    thistype.stack[thistype.index] = thistype.stack[thistype.size]
                    thistype.time[thistype.index] = thistype.time[thistype.size]
                    thistype.stack[thistype.size+1] = null
                    /*if(TEST_MODE){
                        BJDebugMsg("Dest - removing")
                    }*/
                } else {
                    thistype.index++
                }
            }
            if(thistype.size<=0){
                PauseTimer(thistype.t)
                thistype.size=0
            }
        endmethod
        
        static method push takes destructable d,real time returns nothing
            /*if(TEST_MODE){
                BJDebugMsg("Dest - pushing")
            }*/
            thistype.stack[thistype.size] = d
            thistype.time[thistype.size] = time
            if thistype.size == 0 then
                TimerStart(thistype.t,PERIOD,true,function thistype.periodic)
            endif
            thistype.size++
        endmethod
        
    endstruct
    
    define
        destPush(d,t) = Dest.push(d,t)
    enddefine
    
    
endlibrary