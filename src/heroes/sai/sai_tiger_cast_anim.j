scope SaiTigerCastAnim

    globals
        private constant integer SPELL_ID = 'CW42' 
    endglobals
    
    private function Actions takes nothing returns boolean 
        local unit c = GetSpellAbilityUnit()
        call TriggerSleepAction(0.2)
        call SetUnitAnimation(c, "spell")
        set c = null
        return false
    endfunction
    
    //===========================================================================
    
    public function Init takes nothing returns nothing
        call SpellCast(SPELL_ID, function Actions)
    endfunction

endscope