scope OnokiUltimate

    define{
        private ABIL_ID = 'A103'
        private SPELLBOOK_ID = 'A10T'
        private SLOW_ID = 'A10A'
        private BUFF_ID = 'A10A'
        private ABIL_AOE = 425
        private ABIL_DIEWHEN = 0.1
        private DAMAGE_FACTOR(LVL) = 0.04+0.01*LVL
        private DURATION = 5
        private NORMAL_BLOOD = "Objects\\Spawnmodels\\Undead\\UndeadBlood\\UndeadBloodGargoyle.mdl"
        private DEATH_BLOOD = "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodFootman.mdl"
    }
    
    private function damageUnit takes unit source,unit m returns nothing
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
    endfunction

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent(ABIL_ID,function onSpell)
        call DisableSpellbook(SPELLBOOK_ID)
    endfunction
    
endscope
