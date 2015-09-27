scope KarinInit 

    globals
    //=============================SETUP START===================================
        private constant integer KAR_ID = 'C001' // Hero ID of Karin
        private constant integer BOOK_ID = 'CW17' // ID of ability: "Identify Aura Book"
    //=============================SETUP END===================================
    endglobals

    //===========================================================================
    public function Init takes nothing returns nothing
        local integer i = 0
        loop
        exitwhen i > 12
            set KarinChainGroup[i] = CreateGroup()
            set KarinIDGroup[i] = CreateGroup()
            set LF_Karin_Timer[i] = CreateTimer()
            set i = i + 1
        endloop
        call DisableSpellbook(BOOK_ID)
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope

