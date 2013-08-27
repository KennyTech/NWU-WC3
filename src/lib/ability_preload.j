library AbilityPreload

    globals
        private unit PreloadUnit
        private integer ID
    endglobals

    function AbilityPreload takes integer abilityid returns nothing
        call UnitAddAbility(PreloadUnit, abilityid)
    endfunction

    private function DisabkeSpellbookDo takes nothing returns nothing
        debug call BJDebugMsg(GetObjectName(ID))
        call SetPlayerAbilityAvailable(GetEnumPlayer(),ID,false)  
        debug call BJDebugMsg("lol")
    endfunction
    
    function DisableSpellbook takes integer id returns nothing
        set ID = id
        call ForForce(bj_FORCE_ALL_PLAYERS,function DisabkeSpellbookDo)
        // SpellBooks que no pueden prelodearse
        if id!='A0D7' and id!='A06Z' then //Kakuzu||Yugito
            call UnitAddAbility(PreloadUnit,id)
        endif
        debug call BJDebugMsg("spellbook")
    endfunction
    
    private module PreloadModule
        private static method onInit takes nothing returns nothing
            set PreloadUnit = CreateUnit(Player(15), 'zsmc', 0., 0., 0.)
            call ShowUnit(PreloadUnit, false)
            call UnitAddAbility(PreloadUnit, 'Aloc')
        endmethod
    endmodule
    
    private struct Init extends array
        implement PreloadModule
    endstruct

endlibrary