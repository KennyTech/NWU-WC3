scope KBDeath

    globals
        private constant integer KB_ID      = 'C000'    // ID of hero: Killer Bee
        private constant integer KB_BOOK_ID = 'CW08'    // ID of ability: "Killer Bee - 8-Tail Chakra Aura Book"
    endglobals

    private function Conditions takes nothing returns boolean
        return GetUnitTypeId(GetDyingUnit()) == KB_ID
    endfunction

    private function Actions takes nothing returns nothing
        call AddUnitAnimationProperties(GetDyingUnit(), "alternate", false) // Undo transform upon death.
        call UnitRemoveAbility(GetDyingUnit(), KB_BOOK_ID) // Remove MS Aura Book as well.
    endfunction

    public function InitDeath takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_DEATH )
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction( t, function Actions )
        set t = null
    endfunction

endscope
