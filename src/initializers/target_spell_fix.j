scope TargetSpellFix initializer init{

    private rect getRect(unit u){
        if(RectContainsUnit(gg_rct_MainRegion, u)){
            return gg_rct_MainRegion
        }
        if(RectContainsUnit(gg_rct_Kyubi, u)){
            return gg_rct_Kyubi
        }
        return null
    }

    private void Actions(){
        unit u = GetTriggerUnit()
        real x = GetOrderPointX()
        real y = GetOrderPointY()
        int  i = GetIssuedOrderId()
        rect r = getRect(u)

        if (r != null and !RectContainsCoords(r, x, y) and i != ORDER_move and i != ORDER_attackground and i != ORDER_smart){
            call AbortOrder(u)
            static if TEST_MODE then
                call BJDebugMsg("[ORDER] You cannot order your hero to cast a spell outside map")
            endif
        }
        u = null
    }

    private void init(){
        trigger t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER )
        TriggerAddAction(t, function Actions)
    }

}