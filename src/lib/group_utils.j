library GroupUtils initializer init

    globals
        constant group ENUM = CreateGroup()
        unit enumUnit
        player enumPlayer
        group enumGroup
    endglobals

    private function init takes nothing returns nothing
        set udg_GROUP = CreateGroup()
    endfunction

    function NewGroup takes nothing returns group
        if udg_groupCount==0 then
            return CreateGroup()
        endif
        set udg_groupCount = udg_groupCount-1
        call SaveInteger(TimerUtils_HashTable,GetHandleId(udg_group[udg_groupCount]),0,0)
        return udg_group[udg_groupCount]
    endfunction
    
    function ReleaseGroup takes group g returns nothing
        local integer i=GetHandleId(g)
        if g==null then
            //call GameError("Internal error #GU2")
            return 
        endif
        if(LoadInteger(TimerUtils_HashTable,i,0)==0x28829022) then
            //call GameError("Internal error #GU1")
            return
        endif
        call SaveInteger(TimerUtils_HashTable,i,0,0x28829022)
        call GroupClear(g)
        set udg_group[udg_groupCount] = g
        set udg_groupCount = udg_groupCount + 1
    endfunction
    
endlibrary