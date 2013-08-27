scope KyuubiLeaves initializer init

	function Kyuubi_Leaves takes nothing returns boolean
	    local unit u = GetTriggerUnit()
	    if GetUnitTypeId(u) == 'n01J'  then
	        call SetUnitPosition(u,15500,-9600)
	    endif
	    set u = null
	    return false
	endfunction

    private nothing init(){
	    set gg_trg_Kyuubi_Leaves = CreateTrigger(  )
	    call TriggerRegisterLeaveRectSimple( gg_trg_Kyuubi_Leaves, gg_rct_Kyubi )
	    call TriggerAddCondition( gg_trg_Kyuubi_Leaves, Condition( function Kyuubi_Leaves ) )
	}
endscope