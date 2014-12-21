scope KyuubiLeaves initializer init

    function Kyuubi_Leaves takes nothing returns boolean
        if isKyuubi(GetTriggerUnit()) then
            SetUnitPosition(GetTriggerUnit(), KYUUBI_SPAWN_X, KYUUBI_SPAWN_Y)
        endif
        return false
    endfunction

    private nothing init(){
        trigger t = CreateTrigger(  )
        TriggerRegisterLeaveRectSimple( t, gg_rct_Kyubi )
        TriggerAddCondition( t, Condition( function Kyuubi_Leaves ) )
    }
endscope