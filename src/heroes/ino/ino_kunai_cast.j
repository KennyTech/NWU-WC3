scope InoKunaiCast

    globals
        private constant integer SPELL_ID1   = 'CW70' // 1 charge
        private constant integer SPELL_ID2   = 'CW71' // 2 charge
        private constant integer SPELL_ID3   = 'CW72' // 3 charge
        private constant integer SPELL_ID4   = 'CW73' // Disabled
        private constant integer SPELL_ID5   = 'CW74' // Learn
        private constant integer DUMMY_ID1   = 'cw18'
        private constant hashtable HT        = InitHashtable()
        private unit CurrentPick
        private real CenterX = 0
        private real CenterY = 0
        private real CurrentDistance = 0 
        private group AnyGroup = CreateGroup()
        private group ResultingGroup = CreateGroup()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID1 or GetSpellAbilityId() == SPELL_ID2 or GetSpellAbilityId() == SPELL_ID3 
    endfunction

    private function EnemyFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())) == true and IsUnitVisible(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())) == true and IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE) == false
    endfunction
    
    private function EnemyFilterHeroPriority takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())) == true and IsUnitVisible(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())) == true and IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE) == false and IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) == true
    endfunction

    private function Enum takes nothing returns nothing
        local unit u = GetEnumUnit()
        local real dx = GetUnitX(u) - CenterX
        local real dy = GetUnitY(u) - CenterY
        local real d = (dx*dx + dy*dy) / 10000.
        if d < CurrentDistance then
            set CurrentDistance = d
            set CurrentPick = u
        endif
        set u = null
    endfunction

    private function GetClosestUnitsInRange takes real x, real y, real radius, integer n, boolexpr filter returns group
        call GroupEnumUnitsInRange(AnyGroup, x, y, radius, filter)
        set ResultingGroup = CreateGroup()
        set CenterX = x
        set CenterY = y
        loop
            exitwhen n == 0
            set CurrentPick = null
            set CurrentDistance = 100000
            call ForGroup(AnyGroup, function Enum)
            exitwhen CurrentPick == null
            call GroupRemoveUnit(AnyGroup, CurrentPick)
            call GroupAddUnit(ResultingGroup, CurrentPick)
            set n = n - 1
        endloop
        return ResultingGroup
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        local unit u
        local group g = CreateGroup()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local player p = GetOwningPlayer(c)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID5)
        local unit dummy
        local boolexpr b1
        local boolexpr b2
        local real x2 
        local real y2 
        local real angle
        local integer damage
        
        call TriggerSleepAction(0.01) // Prevents uncontrollable bug
        
        set b1 = Filter(function EnemyFilterHeroPriority)
        set b2 = Filter(function EnemyFilter)
        
        if GetSpellAbilityId() == SPELL_ID1 then // Use last charge
            call UnitRemoveAbility(c, SPELL_ID1) // Remove current
            call UnitAddAbility(c, SPELL_ID4) // Add disabled
            call SetUnitAbilityLevel(c, SPELL_ID4, level)
        elseif GetSpellAbilityId() == SPELL_ID2 then // Use 2nd charge
            call UnitRemoveAbility(c, SPELL_ID2) // Remove current 
            call UnitAddAbility(c, SPELL_ID1) // Add 1 charge remaining
            call SetUnitAbilityLevel(c, SPELL_ID1, level)
        else // Use 3rd charge
            call UnitRemoveAbility(c, SPELL_ID3) // Remove current
            call UnitAddAbility(c, SPELL_ID2) // Add 2 charge remaining
            call SetUnitAbilityLevel(c, SPELL_ID2, level)
        endif
        
        //==============================================================================
        call GetClosestUnitsInRange(x,y,775,1, b1)
        
        if CurrentPick == null then
            call GetClosestUnitsInRange(x,y,775,1, b2)
        endif
        
        if CurrentPick != null then
            set x2 = GetUnitX(CurrentPick)
            set y2 = GetUnitY(CurrentPick)
            set angle = bj_RADTODEG*Atan2(y2-y,x2-x)
            
            set dummy = CreateUnit(p,DUMMY_ID1,x,y,angle)
            call Fade(dummy)
            
            set damage = R2I(GetUnitDamage(c, udg_HeroMainStat[GetUnitPointValue(c)]))
            call DamageBonus(dummy, GetUnitDamage(c, 0, damage)) // Based on Ino's ATK?
            call IssueTargetOrder(dummy, "attack", CurrentPick)
            call SetUnitTimeScale(dummy, 2)
        
        endif
        
        
        set p = null
        set u = null
        set g = null
        set c = null
        set dummy = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope
