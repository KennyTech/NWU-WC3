library Spell requires proj

    globals
        spell enumSpell
        proj  enumProj
        player NEUTRAL=Player(15)
        hashtable HT=InitHashtable()
    endglobals

    function Cone takes real a, real b, real o returns boolean
         return Cos(b-a)>=Cos(o)
    endfunction

    function UIF takes unit attacker, unit target,real o returns boolean
         if Cone(GetUnitFacing(target)*bj_DEGTORAD ,Atan2(GetUnitY(attacker)-GetUnitY(target),GetUnitX(attacker)-GetUnitX(target)),o) then
              return true 
         endif
         return false
    endfunction

	struct spell
    //==========================
        // Variables utilizadas
	    player owner
        unit caster
        unit target
        unit misil
        unit dummy
        group g
        group damaged
        integer ticks
        integer level
        integer abilId
        integer bonus
        integer data
        real x
        real y
        real casterX
        real casterY
        real targetX
        real targetY
        real damage
        real time
        real angle
        real radio
        boolean finish
        effect sfx
        //==========================
		method destroy takes nothing returns nothing
            set damaged = null
            set g = null
            set level = 0
            set ticks = 0
			set time = 0
            set caster = null
            set target = null
            set misil = null
            set finish = false
            set sfx = null
            call this.deallocate()
		endmethod
        //==========================
        static method create takes nothing returns thistype
            local thistype this = allocate()
            set this.caster  = GetTriggerUnit()
            set this.target  = GetSpellTargetUnit()
            set this.abilId  = GetSpellAbilityId()
            set this.casterX = GetUnitX(this.caster)
            set this.casterY = GetUnitY(this.caster)
            set this.level   = GetUnitAbilityLevel(this.caster,this.abilId)
            set this.owner   = GetOwningPlayer(this.caster)
            if this.target == null then
                set this.targetX = GetSpellTargetX()
                set this.targetY = GetSpellTargetY()
            else
                set this.targetX = GetUnitX(this.target)
                set this.targetY = GetUnitY(this.target)
            endif
            set this.angle=Atan2(this.targetY-this.casterY,this.targetX-this.casterX)
            return this
        endmethod
	endstruct
    
    function GetTriggerSpell takes nothing returns spell
        return spell.create()
    endfunction
    
endlibrary