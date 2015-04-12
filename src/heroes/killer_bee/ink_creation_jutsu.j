scope KBInkCreation

    globals
        private constant integer SPELL_ID   = 'CW01' // ID of ability: "Killer Bee - Ink Creation Jutsu"
        private constant integer SFX_ID     = 'CW05' // ID of ability: Cluster Rockets (Ink Creation)
        private constant integer DUST_ID    = 'CW06' // ID of ability: "Killer Bee - Dust" (Ink)
        //private constant integer DUMMY_ID   = 'DUMY' // Unit ID of "Dummy Caster" - NWU has this unit already
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
   
    private function Actions takes nothing returns nothing // Visuals, ability effect already hardcoded (howl of terror)
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local location loc = GetUnitLoc(c)
        local unit d // dummy
            
        set d = CreateUnit(GetOwningPlayer(c), NORMAL_DUMMY_ID, x, y, 0)
        call SetUnitVertexColor(d,255,255,255,0)
        call UnitApplyTimedLife(d,'BTLF',1.0)
        call UnitAddAbility(d, SFX_ID)
        call UnitAddAbility(d, DUST_ID)
        call IssueImmediateOrderById(d, 852625) // Dust Ability Order ID
        call IssuePointOrder(d, "clusterrockets", x, y) // SX - no damage (ink balls visual)
        set c = null
        set d = null
    endfunction
    
    //===========================================================================
    
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null

        // Preload 
        call AbilityPreload(DUST_ID)
    endfunction

endscope



