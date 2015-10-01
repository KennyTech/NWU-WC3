scope SaiTiger

    define
        private SPELL_ID       = 'CW42'
        private DUMMY_ID1      = 'cw04' 
        private SFX            = "Objects\\Spawnmodels\\Orc\\Orcblood\\OrdBloodWyvernRider.mdl"
        private SFX_TARGET     = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl"
        private MAX_TICKS_GROW = 14 // Max number of iterations to make Tiger Grow
    enddefine
    
    private function onHit takes proj this returns nothing
        call Fade(this.projUnit)
        call UnitDamageTarget(this.caster, this.targetUnit,(175+75*this.level)+(GetUnitState(this.targetUnit, UNIT_STATE_MAX_LIFE)*(0.05+0.05*this.level)), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS ) // Deals 250/325/400 + 10/15/20% target hp in spell dmg
        if IsUnitType(this.targetUnit, UNIT_TYPE_MAGIC_IMMUNE) == false then
            call AddStunTimed(this.targetUnit, 2 + 0.5 * this.level)
        endif
        call DestroyEffect(AddSpecialEffectTarget(SFX_TARGET, this.targetUnit, "chest"))
        call DestroyEffect(AddSpecialEffect(SFX, this.x, this.y))
    endfunction

    private function PursueLoop takes proj this returns nothing
        local unit dummy
        local real scale = RMinBJ(0.2 + this.ticks * 0.07, 0.2 + MAX_TICKS_GROW * 0.07 )
        if this.ticks < 14 then
            call SetUnitScale(this.projUnit, scale, scale, scale)
        endif
        if ModuloInteger(this.ticks, 3) == 0 then // Every 3 ticks create a sfx
            set dummy = CreateUnit(this.owner, DUMMY_ID1, this.x, this.y, GetUnitFacing(this.projUnit))
            call SetUnitScale(dummy, scale, scale, scale)
            call SetUnitAnimationByIndex(dummy , 3)
            call SetUnitTimeScale(dummy, 3)
            call Fade(dummy)
            set dummy = null
        endif
    endfunction
    
    private function Actions takes nothing returns boolean
        local unit caster = GetTriggerUnit()
        local unit target = GetSpellTargetUnit()
        local real x = GetUnitX(caster) 
        local real y = GetUnitY(caster) 
        local real x2 = GetUnitX(target)
        local real y2 = GetUnitY(target)
        local real angle = bj_RADTODEG * Atan2(y2-y,x2-x)
        local integer level = GetUnitAbilityLevel(caster, SPELL_ID)
        local unit tiger = CreateUnit(GetTriggerPlayer(), DUMMY_ID1, x, y, angle)
        local proj this = CreateProjTarget(caster, tiger, target, 1200, 0, true, true, 100, PursueLoop, 0, onHit, 0) 
    
        call SetUnitAnimationByIndex(tiger , 3 )
        call SetUnitTimeScale(tiger, 3) // Speed up animation
        call SetUnitPathing(tiger, false)
 
        set this.level = level
        
        set caster = null
        set target = null
        set tiger  = null
        
        return false
    endfunction

    public function Init takes nothing returns nothing
        call SpellCast(SPELL_ID, function Actions)
    endfunction

endscope
