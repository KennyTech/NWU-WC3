scope OnokiUltimate

    define{
        private ABIL_ID = 'A0LG'
        private SPELLBOOK_ID = 'A10T'
        private SLOW_ID = 'A10A'
        private BUFF_ID = 'B10B'
        private ABIL_AOE = 425
        private ABIL_DIEWHEN = 0.1
        private CHECK_PERIOD = 0.33
        private DAMAGE_PERCENT(LVL) = (0.04+0.01*LVL)
        private DAMAGE_FACTOR(LVL)  = DAMAGE_PERCENT(LVL)*CHECK_PERIOD
        private DURATION = 5
        private NORMAL_BLOOD = "Objects\\Spawnmodels\\Undead\\UndeadBlood\\UndeadBloodGargoyle.mdl"
        private DEATH_BLOOD = "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodFootman.mdl"
        private SEARCH_AOE = 2000 // ENOUGH BIG TO ENUM ALL UNITS WITH THE DEBUFF
    }
    
    /*private function damageUnit takes unit source,unit m returns nothing
        real max = GetUnitState(m,UNIT_STATE_MAX_LIFE)
        if (GetWidgetLife(m)<max*0.1) then
            call DestroyEffect(AddSpecialEffectTarget(DEATH_BLOOD,m,"chest"))
        else
            max=max*DAMAGE_FACTOR(GetUnitAbilityLevel(source,ABIL_ID))
            call DestroyEffect(AddSpecialEffectTarget(NORMAL_BLOOD,m,"chest"))
        endif
        call Damage_Pure(source,m,max)
    endfunction
    
    private function RemoveActions takes nothing returns nothing
        call RemoveAbility(GetEnumUnit(),SPELLBOOK_ID)
        call UnitRemoveAbility(GetEnumUnit(),BUFF_ID)
    endfunction
    
    private function Actions takes nothing returns nothing
        if IsUnitType(GetEnumUnit(),UNIT_TYPE_DEAD)==false and GetUnitAbilityLevel(GetEnumUnit(),SPELLBOOK_ID)>0 then
            call damageUnit(GetUnit(GetHandleId(GetExpiredTimer()),2),GetEnumUnit())
        endif
    endfunction
    
    private function Loop takes nothing returns nothing
        timer t=GetExpiredTimer()
        integer h=GetHandleId(t) 
        group g=GetGroup(h,1)
        // Damage
        call ForGroup(g,function Actions)
        // Spell end
        if GetIntDec(h,0)<=0 then
            call ForGroup(g,function RemoveActions)
            call ReleaseGroup(g)
            call ReleaseTimerEx()
        endif
        // Leaks
        t=null
        g=null
    endfunction
    
    private function onSpell takes nothing returns boolean
        unit caster=GetTriggerUnit()
        // AOE DAMAGE
        group g=NewGroup()
        GroupEnumUnitsInRange(ENUM,GetUnitX(caster),GetUnitY(caster),ABIL_AOE,null)
        loop
            exitwhen LoopNull()==true
            if UnitFilterEx(enumUnit,GetTriggerPlayer()) then
                call damageUnit(caster,enumUnit)
                AddAbility(enumUnit,SPELLBOOK_ID)
                call SetUnitAbilityLevel(enumUnit,SLOW_ID,GetUnitAbilityLevel(caster,ABIL_ID))
                GroupAddUnit(g,enumUnit)
            endif
        endloop
        // TIMER
        timer t=NewTimer()
        integer h=GetHandleId(t)
        // Set Data
        SetInt(h,0,DURATION)
        SetGroup(h,1,g)
        SetUnit(h,2,caster)
        TimerStart(t,1,true,function Loop)
        // LEAKS
        caster=null
        t=null
        g=null
        return false
    endfunction*/


    private function onCallback takes nothing returns nothing
        timer t     = GetExpiredTimer()
        int h       = GetHandleId(t)
        unit target = GetUnit(h, 0)
        unit caster = GetUnit(h, 1)

        if GetUnitAbilityLevel(target, BUFF_ID) == 0 then
            call ReleaseTimerEx()
            static if TEST_MODE then
                call Test_SuccessMsg("OnokiUltimate - DEBUFF of " + GetUnitName(enumUnit) + " has finished")
            endif
        else
            real damage = GetUnitState(target, UNIT_STATE_MAX_LIFE)
            // Unit is under x%, then kill it. Else, aplly a factor
            if (GetWidgetLife(target) < damage * ABIL_DIEWHEN) then
                call DestroyEffect(AddSpecialEffectTarget(DEATH_BLOOD, target, "chest"))
            else
                damage = damage * DAMAGE_FACTOR(GetUnitAbilityLevel(caster, ABIL_ID))
                call DestroyEffect(AddSpecialEffectTarget(NORMAL_BLOOD, target, "chest"))
            endif
            call Damage_Pure(caster, target, damage)
        endif

        t = null
        target = null
        caster = null

    endfunction

    private function waitForDebuff takes nothing returns nothing
        unit caster = GetTimerUnit()

        call GroupEnumUnitsInRange(ENUM, GetUnitX(caster), GetUnitY(caster), SEARCH_AOE, null)

        loop
            exitwhen LoopNull() == true
            if GetUnitAbilityLevel(enumUnit, BUFF_ID) > 0 then
                timer t = NewTimer()
                int h = GetHandleId(t)
                call SetUnit(h, 0, enumUnit)
                call SetUnit(h, 1, caster)
                call TimerStart(t, CHECK_PERIOD, true, function onCallback)
                static if TEST_MODE then
                    call Test_SuccessMsg("OnokiUltimate - Started checking DEBUFF of " + GetUnitName(enumUnit))
                endif
                t = null
            endif
        endloop

        call ReleaseTimerEx()

        caster = null

    endfunction

    private function onSpell takes nothing returns boolean
        call TimerStart(NewTimerUnit(GetTriggerUnit()), 0, false, function waitForDebuff)
        return false
    endfunction

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent(ABIL_ID,function onSpell)
    endfunction
    
endscope
