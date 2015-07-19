library TimerUtils requires Faux

    globals
        hashtable HT=InitHashtable()
        public hashtable HashTable = InitHashtable()
        private integer timerCount = 0
        private timer array timers
        private timer T
    endglobals
    
    function Clear takes handle subject returns nothing
        call FauxFlush(GetHandleId(subject))
    endfunction

    function NewTimer takes nothing returns timer
        if timerCount==0 then  
            return CreateTimer()
        endif
        set timerCount = timerCount-1
        call SaveInteger(HashTable,GetHandleId(timers[timerCount]),1,0)
        return timers[timerCount]
    endfunction

    function ReleaseTimer takes timer t returns nothing
        local integer i=GetHandleId(t)
        if t==null then
            //call GameError("Internal Error #TU1")
            return
        endif
        if timerCount>8190 then
            //call GameError("Internal Error #TU2")
            call DestroyTimer(t)
        else
            call PauseTimer(t)
            call RemoveSavedInteger(HashTable,i,0) // TU
            call RemoveSavedHandle(HashTable,i,3) // TU
            call FlushChildHashtable(HT,i) // GLOBAL
            call Clear(t) // FAUX
            if(LoadInteger(HashTable,i,1)==1) then
                //call GameError("Internal Error #TU3")
                return
            endif
            call SaveInteger(HashTable,i,1,1)
            set timers[timerCount] = t
            set timerCount = timerCount + 1
        endif
    endfunction
    
    //----------------------------  
    // Timer Data  
    function SetTimerData takes timer t,integer value returns nothing
        call SaveInteger(HashTable, GetHandleId(t), 0, value)
    endfunction
    
    function NewTimerEx takes integer value returns timer
        set T=NewTimer()
        call SetTimerData(T,value)
        return T
    endfunction
    
    function NewTimerUnit takes unit whichUnit returns timer
        local timer T=NewTimer()
        call SaveAgentHandle(HashTable,GetHandleId(T),3,whichUnit)
        return T
    endfunction
    
    function GetTimerUnit takes nothing returns unit
        return LoadUnitHandle(HashTable, GetHandleId(GetExpiredTimer()),3)
    endfunction

    function GetTimerData takes timer t returns integer
        return LoadInteger(HashTable,GetHandleId(t), 0)
    endfunction
    
    function GetTimerDataEx takes nothing returns integer
        return LoadInteger(HashTable,GetHandleId(GetExpiredTimer()), 0)
    endfunction
    
    function ReleaseTimerEx takes nothing returns nothing
        call ReleaseTimer(GetExpiredTimer())
    endfunction
    
endlibrary