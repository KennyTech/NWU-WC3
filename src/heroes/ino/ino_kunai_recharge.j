scope InoKunaiRecharge

    globals
        private constant integer SPELL_ID1   = 'CW70' // 1 charge
        private constant integer SPELL_ID2   = 'CW71' // 2 charge
        private constant integer SPELL_ID3   = 'CW72' // 3 charge
        private constant integer SPELL_ID4   = 'CW73' // Disabled
        private constant integer SPELL_ID5   = 'CW74' // Learn
        private constant integer SPELL_ID6   = 'A0LP' // 4
        private constant integer SPELL_ID7   = 'A0LQ' // 5
        private constant integer CREEP_PLAYER_1 = 0 // Red = 0
        private constant integer CREEP_PLAYER_2 = 6 // Green = 6
        private constant string SFX          = "Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl"
    endglobals
    
    private function Actions takes nothing returns nothing // Actions upon death (bounty)
        local unit killer = GetKillingUnit()
        local unit killed = GetDyingUnit()
        local integer level 
        local unit u
        local group g = CreateGroup()
        local integer n
        local real x = GetUnitX(killed)
        local real y = GetUnitY(killed)
        
        call GroupEnumUnitsInRange(g,x,y,1200,null)
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            set level = GetUnitAbilityLevel(u, SPELL_ID5)
            if IsUnitEnemy(u, GetOwningPlayer(killed)) and IsUnitEnemy(killed, GetOwningPlayer(killer)) and level > 0 and GetPlayerId(GetOwningPlayer(killed)) == CREEP_PLAYER_1 or GetPlayerId(GetOwningPlayer(killed)) == CREEP_PLAYER_2 then
                call DestroyEffect(AddSpecialEffect(SFX,GetUnitX(u),GetUnitY(u)))
                if GetUnitAbilityLevel(u, SPELL_ID4) > 0 then
                    call UnitRemoveAbility(u, SPELL_ID4)
                    call UnitAddAbility(u, SPELL_ID1) 
                    call SetUnitAbilityLevel(u, SPELL_ID1, level)
                elseif GetUnitAbilityLevel(u, SPELL_ID1) > 0 then
                    call UnitRemoveAbility(u, SPELL_ID1)
                    call UnitAddAbility(u, SPELL_ID2) 
                    call SetUnitAbilityLevel(u, SPELL_ID2, level)
                elseif GetUnitAbilityLevel(u, SPELL_ID2) > 0 then
                    call UnitRemoveAbility(u, SPELL_ID2)
                    call UnitAddAbility(u, SPELL_ID3)
                    call SetUnitAbilityLevel(u, SPELL_ID3, level)
                elseif GetUnitAbilityLevel(u, SPELL_ID3) > 0 then
                    call UnitRemoveAbility(u, SPELL_ID3)
                    call UnitAddAbility(u, SPELL_ID6)
                    call SetUnitAbilityLevel(u, SPELL_ID6, level)
                elseif GetUnitAbilityLevel(u, SPELL_ID6) > 0 then
                    call UnitRemoveAbility(u, SPELL_ID6)
                    call UnitAddAbility(u, SPELL_ID7)
                    call SetUnitAbilityLevel(u, SPELL_ID7, level)                
                endif
            endif
            call GroupRemoveUnit(g, u)
        endloop
            
        set u = null
        set g = null
        set killed = null
        set killer = null
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddAction(t, function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope
