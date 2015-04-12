scope KBLariat

    define
        private SPELL_ID = 'A0LI' // ID of ability: "Killer B - Lariat"
        private ULT_ID   = 'CW03' // ID of ability: "Killer B - 8-Tail Chakra"
        private AURA_ID  = 'CW07' // ID of ability: "Killer B - 8-Tail Chakra Aura"
        private DUMMY    = 'cw00' // ID of unit: "SX KillerB" (dummy unit - afterimage)
        private EFFECT   = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl" // Lightning effect
    enddefine

    define
        private SPEED      = 1200
        private GetDamageAOE(ult_level) = 125 + 15 * ult_level
        private GetKnockbackAOE(ult_level)  = 140 + 15 * ult_level
        private GetDamage(level, ult_level) = 30 + 60 * level + 10 * ult_level
        private IsValidTarget(u) = IsUnitEnemy(u, this.owner) and UnitFilter(u) and !IsUnitInGroup(u,this.damaged)
    enddefine

    private function CreateDummyProjectile takes proj this returns nothing
        local unit dummy = CreateUnit(this.owner, DUMMY, this.x, this.y, this.angle * bj_RADTODEG)
        call SetUnitAnimationByIndex(dummy, 4) // let Killer B (dummy) show "walk" animation.
        call SetUnitTimeScale(dummy, 3.00) // Speed up animation by 3x.
        call SetUnitVertexColor(dummy, 255, 255, 255, 150) // Semi Fade Dummy
        call ProjGround(this.caster,  dummy, this.targetX, this.targetY, 0, SPEED, 0, 0, 0, true, false, 0, onHitRemoveFX, null, null)
        set dummy = null
    endfunction

    private function onForwardCollision takes nothing returns boolean
        local proj this = GetTriggerProj()
        local unit u = GetFilterUnit()
        if IsValidTarget(u) then
            call Damage_Physical(this.caster, u, this.damage)
            call GroupAddUnit(this.damaged, u)
        endif
        set u = null
        return false
    endfunction

    private function onBackwardCollision takes nothing returns boolean
        local proj this = GetTriggerProj()
        local unit u = GetFilterUnit()
        local real x
        local real y
        if IsValidTarget(u) then
            // Knockback
            x = GetUnitX(u) + 36 * Cos(this.angle)
            y = GetUnitY(u) + 36 * Sin(this.angle)
            // Don't allow units to be stuck
            if !IsTerrainWalkable(x, y) then
                set x = TerrainPathability_X
                set y = TerrainPathability_Y
            endif
            call SetUnitX(u, x)
            call SetUnitY(u, y)
            call IssueImmediateOrder(u, "stop")
        endif
        set u = null
        return false
    endfunction

    private function onTick takes proj this returns nothing

        local unit dummy

        // Create lightning SFX
        call DestroyEffect(AddSpecialEffect(EFFECT, this.x, this.y))

        // Create Dummies SFX every 3 ticks
        if Mod(this.ticks, 3) then
            call KillDestructablesInCircle(this.x, this.y, 90) // Destroy trees
            dummy = CreateUnit(this.owner, DUMMY, this.x, this.y, this.angle * bj_RADTODEG)
            call Fade(dummy)
            call SetUnitTimeScale(dummy, 3) // speed up animation by 3x
            call AddUnitAnimationProperties(dummy, "alternate", false)
            if GetUnitAbilityLevel(this.caster, AURA_ID) == 0 then
                call SetUnitAnimationByIndex(dummy, 4) // play normal walk animation in normal form
            else
                call SetUnitAnimationByIndex(dummy, 9) // play alternate walk animation in ult form
            endif
            set dummy = null
        endif

    endfunction

    private function onBackwardFinish takes proj this returns nothing
        call SetUnitVertexColor(this.caster, 255, 255, 255, 255) // Make Killer Bee non-transparent again.
        call SetUnitPathing(this.caster, true)
        if GetUnitAbilityLevel(this.caster, AURA_ID) > 0 then
            call SetUnitAnimationByIndex(this.caster, 8) // Play walk alternate animation at the end
        else
            call SetUnitAnimationByIndex(this.caster, 4) // Normal animation if not in ult form
        endif
    endfunction

    private function onForwardFinish takes proj this returns nothing
        if isUnitAlive(this.caster) and FirstOfGroup(this.damaged) != null then
            // Backward caster movement
            set this       = ProjGround(this.caster, this.caster, this.origenX, this.origenY, 0, SPEED, 0, GetKnockbackAOE(GetUnitAbilityLevel(this.caster, AURA_ID)), 0, true, true,  onTick, onBackwardFinish, Filter(function onBackwardCollision), null)
            set this.pause = true
            // Just create another proj for the dummy unit
            call CreateDummyProjectile(this)
        else
            call onBackwardFinish(this)
        endif
    endfunction

    private function onCast takes nothing returns boolean
        local unit caster   = GetTriggerUnit()
        local real angle    = GetSpellAngle()
        local real distance = GetSpellDistance()
        local real x        = GetSpellTargetX()
        local real y        = GetSpellTargetY()
        local proj this     = ProjGround(caster, caster, x, y, 0, SPEED, 0, GetDamageAOE(GetUnitAbilityLevel(caster, AURA_ID)), 0, true, true,  onTick, onForwardFinish, Filter(function onForwardCollision), null)
        call SetUnitVertexColor(caster, 255, 255, 255, 0) // Fade Killer B out
        call SetUnitPathing(caster, false)
        // Movement Properties
        set this.pause   = true
        set this.damage  = GetDamage(GetUnitAbilityLevel(caster, SPELL_ID), GetUnitAbilityLevel(caster, ULT_ID))
        // Dummy Projectile
        call CreateDummyProjectile(this)
        set caster = null
        return false
    endfunction

    public function Init takes nothing returns nothing
        call SpellCast(SPELL_ID)
    endfunction

endscope