scope BugShieldStart
    
    define 
        private LIFE(LVL)   = 80+30*LVL
        private ABIL        = 'A03T'
        private SFX         = "BugShield.mdx"
        private DAMAGE(LVL) = 80+30*LVL
        private DAMAGE_AOE  = 550
        private DURATION    = 15
        private DAMAGE_SFX  = "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl"
    enddefine

    private function BugShieldRemove takes unit u,boolean destroyed returns nothing
        int h = GetHandleId(u)
        unit caster = LoadUnitHandle(HT,h,KEY_BUG_SHIELD_CASTER)
        if destroyed then
            UnitDamageArea(caster, GetUnitX(u), GetUnitY(u), DAMAGE_AOE, GetReal(h, KEY_BUG_SHIELD_DAMAGE), DAMAGE_SPELL, DAMAGE_SFX)
        endif
        DestroyEffect(LoadEffectHandle(HT,h,KEY_BUG_SHIELD))
        ReleaseTimer(LoadTimerHandle(HT,h,KEY_BUG_SHIELD_TIMER))
        RemoveSavedHandle(HT,h,KEY_BUG_SHIELD_TIMER)
        RemoveSavedHandle(HT,h,KEY_BUG_SHIELD)
        caster=null
    endfunction

    private void timedEnd(){
        BugShieldRemove(GetTimerUnit(), false)
    }
    
    private function onSpell takes nothing returns boolean
        unit target   = GetSpellTargetUnit()
        unit caster   = GetTriggerUnit()
        integer id    = GetHandleId(target)
        integer level = GetUnitAbilityLevel(caster, ABIL)
        timer t

        // Create and attach the effect if isn't already created
        if not HaveSavedHandle(HT, id, KEY_BUG_SHIELD) then
            call SaveEffectHandle(HT, id, KEY_BUG_SHIELD, AddSpecialEffectTarget(SFX,target,"chest"))
        endif

        // Retart or Get a new timer
        if HaveSavedHandle(HT, id, KEY_BUG_SHIELD_TIMER) then
            t = GetTimer(id, KEY_BUG_SHIELD_TIMER)
            PauseTimer(t)
        else
            t = NewTimerUnit(target)
            SetTimer(id, KEY_BUG_SHIELD_TIMER, t)
        endif

        // Persistence Values
        SetReal(id, KEY_BUG_SHIELD,        LIFE(level))
        SetReal(id, KEY_BUG_SHIELD_TIME,   15)
        SetReal(id, KEY_BUG_SHIELD_DAMAGE, DAMAGE(level))

        // Check for mind control
        if(IsMindControlled(caster)){
            SetUnit(id, KEY_BUG_SHIELD_CASTER, GetMindController(caster))
        } else {
            SetUnit(id, KEY_BUG_SHIELD_CASTER, caster)
        }

        TimerStart(t, DURATION, false, function timedEnd)

        // Leaks
        target=null
        caster=null
        t=null

        return false
    endfunction
    
    private void onDamage(unit target,unit source,real damage){
        int h=GetHandleId(target)
        if HaveSavedHandle(HT,h,KEY_BUG_SHIELD) then
            real preLife=LoadReal(HT,h,KEY_BUG_SHIELD)
            real life=preLife-RAbsBJ(damage)
            SaveReal(HT,h,KEY_BUG_SHIELD,life)
            if life<=0 then
                BugShieldRemove(target,true)
                Damage_Block(preLife)
            else
                Damage_BlockAll()
            endif
        endif
    }

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent(ABIL, function onSpell)
        call Damage_Register(onDamage)
    endfunction

endscope