scope KarinEasterEgg

    globals
        private constant integer SPELL_ID    = 'CW10'    // Ability ID of "Karin - Mind's Eye"
    endglobals
        
    private function SasFilter takes nothing returns boolean
        return GetUnitTypeId(GetFilterUnit()) == SASUKE // Sasuke (gives Karin hearts visual when near)
    endfunction

    private unit searchKarin(){
        int i = 0
        while(i <= 11){
            if(GetUnitTypeId(GetPlayerHero(Player(i))) == KARIN){
                return GetPlayerHero(Player(i))
            }
            i++
        }
        return null
    }

    private void Actions(){

        unit karin = searchKarin()
        bool matchSas = false

        if(karin != null){
             // Easter Egg. Is Sasuke nearby Karin ??? If yes, visual hearts SFX
            GroupEnumUnitsInRange(ENUM, GetUnitX(karin), GetUnitY(karin), 600, function SasFilter)

            if(FirstOfGroup(ENUM) != null){
                UnitAddAbility(karin, 'CW18')
            } else {
                UnitRemoveAbility(karin, 'CW18')
            }
        }

    }

    //===========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterTimerEventPeriodic( t, 4.0 ) // Runs every 4 seconds
        call TriggerAddAction( t, function Actions )
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope
