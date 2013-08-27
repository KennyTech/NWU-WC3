library ITEMS initializer init

    function CountItemsOfType takes unit u,item id returns integer
       local integer max = UnitInventorySize(u)-1
       local integer index = 0
       local integer n = 0
       local integer itype = GetItemTypeId(id)
       loop
       exitwhen index>max
           if GetItemTypeId(UnitItemInSlot(u,index))==itype then
               set n = n + 1
           endif
           set index = index + 1
       endloop
       set u = null
       set id = null
       return n
    endfunction

    function CountItemsOfTypeById takes unit u,integer itype returns integer
       local integer max = UnitInventorySize(u)-1
       local integer index = 0
       local integer n = 0
       loop
       exitwhen index>max
           if GetItemTypeId(UnitItemInSlot(u,index))==itype then
               set n = n + 1
           endif
           set index = index + 1
       endloop
       set u = null
       return n
    endfunction

    private nothing init(){
        set udg_ItemHT = InitHashtable()
    }

endlibrary