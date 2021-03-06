scope KarinKFA  

    globals
        private constant integer SPELL_ID       = 'CW11'    // "Karin - Kongou Fuusa"
        private constant integer D_SPELL_ID     = 'CW13'    // "Karin - Kongou Fuusa Dummy Chains"
        private constant integer D_SPELL_ID2    = 'CW12'    // "Karin - Kongou Fuusa Dummy AoE"
        private constant integer DUMMY          = 'h01K'    // Dummy Caster
    endglobals
    
    private function onDamage takes unit damagedUnit, unit HeroKarin, real damage returns nothing
        local real x = GetUnitX(GetTriggerUnit())
        local real y = GetUnitY(GetTriggerUnit())
        local unit u
        local unit d
        local integer level = GetUnitAbilityLevel(HeroKarin, SPELL_ID)
        
        if Damage_IsAttack() and GetUnitAbilityLevel(HeroKarin,'BK04')>0 then
        
        call UnitRemoveAbility(HeroKarin,'BK04')
        
        set KF_Level = level // For Drain later
        
        call GroupEnumUnitsInRange(ENUM,x,y,250,null) // Enumerate # of enemies to seal
        loop
            set u = FirstOfGroup(ENUM)
        exitwhen u == null
            if u == damagedUnit or IsUnitType(damagedUnit, UNIT_TYPE_HERO) == true and IsUnitEnemy(u, GetOwningPlayer(HeroKarin)) then
                set d = CreateUnit(GetOwningPlayer(HeroKarin), DUMMY, x, y, 0)
                call UnitApplyTimedLife(d,'BTLF',1.0)
                call UnitAddAbility(d, D_SPELL_ID)
                call SetUnitAbilityLevel(d, D_SPELL_ID, level)
                call IssueTargetOrder(d, "entanglingroots", u)
            elseif IsUnitEnemy(u, GetOwningPlayer(HeroKarin)) then
                set d = CreateUnit(GetOwningPlayer(HeroKarin), DUMMY, x, y, 0)
                call UnitApplyTimedLife(d,'BTLF',1.0)
                call UnitAddAbility(d, D_SPELL_ID2)
                call SetUnitAbilityLevel(d, D_SPELL_ID2, level)
                call IssueTargetOrder(d, "entanglingroots", u)
            endif
            call GroupRemoveUnit(ENUM,u)
        endloop
        
        endif
    
        set u = null
        set d = null
    endfunction
    
    public function Init takes nothing returns nothing
        call RegisterDamageResponse(onDamage)
    endfunction

endscope
