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

    private boolean Actions(){
        unit u = GetTriggerUnit()
        rect r = getRect(u)
        real x = GetSpellTargetX()
        real y = GetSpellTargetY()
        int i  = GetSpellAbilityId()

        if (r != null and !RectContainsCoords(r, x, y) and (i == SASUKE_T or i == BEE_R)){
            call AbortOrder(u)
            debug call BJDebugMsg("[ORDER] You cannot order your hero to cast a spell outside map")
        }

        u = null
        r = null
        return false
    }

    private void init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_SPELL_CAST, function Actions)
    }

}