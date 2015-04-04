scope Kaiten

    define{
        private BYAKUGAN           = 'A038'
        private KAITEN             = 'A03C'
        private stunDuration(lvl)  = 0.75 * lvl
        private spellDamage(lvl)   = 75*lvl
        private AOE                = 300
        private TREE_AOE           = 350
        private KNOCKBACK_DISTANCE = 300
    }

    private function onSpell takes nothing returns boolean
        unit caster = GetTriggerUnit()
        real duration = stunDuration(GetUnitAbilityLevel(caster, BYAKUGAN))
        real damage = spellDamage(GetUnitAbilityLevel(caster, KAITEN))
        proj projectile

        UnitAddInvulnerableTimed(caster, 1)
        UnitAddInmuneTimed(caster, 1)

        real x = GetUnitX(caster)
        real y = GetUnitY(caster)

        EnumDestructablesInCircle(TREE_AOE, x, y, function KillDestructableEnum)
        GroupEnumUnitsInRange(ENUM, x, y, AOE, null)

        loop
            unit target = FirstOfGroup(ENUM)
            exitwhen target == null
            call GroupRemoveUnit(ENUM, target)
            if UnitFilter(target) and IsUnitEnemy(target, GetTriggerPlayer()) then
                if duration > 0 then
                    call AddStunTimed(target, duration)
                endif
                Damage_Spell(caster, target, damage)
                projectile       = CreateProj(caster, target, GetUnitX(target) + KNOCKBACK_DISTANCE*Cos(ABU(caster,target)),GetUnitY(target)+KNOCKBACK_DISTANCE*Sin(ABU(caster,target)),0,500,0,false,onLoopFX,0,0,0)
                projectile.pause = true
            endif
        endloop
        GroupClear(ENUM)
        target = null
        return false
    endfunction

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent(KAITEN,function onSpell)
    endfunction

endscope