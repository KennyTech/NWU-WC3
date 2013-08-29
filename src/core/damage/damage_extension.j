library Damage requires Status,Blink

    globals
        constant integer DAMAGE_FISICO = 1
        constant integer DAMAGE_SPELL  = 2
        constant integer DAMAGE_PURE   = 3
    endglobals
    
    //======================================================
    // Damage Type
    function Damage_Pure takes unit source,unit target,real amount returns nothing
        local real TargetLife 
        if IsUnitTypeWard(target)==false then
            call BlinkRemoval(target,GetOwningPlayer(source),GetOwningPlayer(target))
            set TargetLife = GetWidgetLife(target)-amount
            if TargetLife < 0.405 then
                call DisableTrigger( DamageEvent_currentTrg )
                call UnitDamageTarget( source, target, -500000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS)
                call EnableTrigger( DamageEvent_currentTrg )
            else
                call SetWidgetLife(target,TargetLife)
            endif
            call AssistRegister(target,source)
        endif
    endfunction
    
    /*function Damage_Spell takes unit source, unit target, real damage returns boolean
        if IsUnitTypeWard(target)==false then
            return UnitDamageTarget(source,target,damage,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
        endif
        return false
    endfunction
    
    function Damage_Physical takes unit source,unit target,real damage,attacktype at,boolean attack,boolean ranged returns boolean
        if IsUnitTypeWard(target)==false then
            return UnitDamageTarget(source,target,damage,false,false,at,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
        endif
        return false
    endfunction*/
    
    function Damage_IsValidAttack takes nothing returns boolean
        return GetEventDamage()>0 and GetLastTarget(GetEventDamageSource())==GetTriggerUnit()
    endfunction
    
    //======================================================

    /*struct MagicDamage extends DamageModifier
        method onDamageTaken takes unit damageSource, real damage returns real
            local player p1=GetOwningPlayer(damageSource)
            local player p2=GetOwningPlayer(targetunit)
            local real result=0.0
            if p1!=udg_team1[0] and p1!=udg_team2[0] and p2!=udg_team1[0] and p2!=udg_team2[0] and (IsPlayerAlly(p1,p2)and(p1!=p2)) then
                set result = -damage
            else
                if damage<0 then
                    set result = -2*damage
                endif
            endif
            set p1=null
            set p2=null
            return result
        endmethod
    endstruct*/
    
    /*public function GetCreep takes nothing returns boolean
        set enumUnit=GetFilterUnit()
        if GetWidgetLife(enumUnit)>0.405 and IsUnitEnemy(enumUnit,enumPlayer) and (GetOwningPlayer(enumUnit)==udg_team1[0] or GetOwningPlayer(enumUnit)==udg_team2[0]) then
            return true
        endif
        return false
    endfunction
    
    struct Backdoor extends DamageModifier
        method onDamageTaken takes unit damageSource, real damage returns real
            local player p=GetOwningPlayer(damageSource)
            if p!=udg_team1[0] and p!=udg_team2[0] and IsUnitEnemy(this.targetunit,p) and (GetWidgetLife(this.targetunit)/GetUnitState(this.targetunit,UNIT_STATE_MAX_LIFE))>0.1 then
                // Buscamos si hay Creeps en el AoE de la torrre
                set enumPlayer=GetOwningPlayer(this.targetunit)
                call GroupEnumUnitsInRange(ENUM,GetUnitX(this.targetunit),GetUnitY(this.targetunit),1200,Filter(function GetCreep))
                if FirstOfGroup(ENUM)!=null then // Hay, no se bloquea
                    set damage=0.0
                else // Hay, se bloquea
                    call TextTag_Unit(this.targetunit,GetPlayerStringColored(p,"Block"),"")
                endif
                set p=null
                call GroupClear(ENUM)
                return -damage
            endif
            set p=null
            return 0.0
        endmethod
    endstruct*/
    
    //======================================================
    /*struct KankuroDamageBlock extends DamageModifier
        unit puppet
        method onDamageTaken takes unit damageSource, real damage returns real
            call Damage_Pure(damageSource,puppet,damage)
            return -damage
        endmethod
        static method create takes unit u, unit puppet returns thistype
            local thistype this=allocate(u,1)
            set this.puppet=puppet
            return this
        endmethod
    endstruct*/
    //======================================================
    /*struct DamageBlock extends DamageModifier
        boolean blockAll
        real percent
        real block
        real chance
        method onDamageTaken takes unit damageSource, real damage returns real
            if GetRandomReal(0,100)<=this.chance then
                if this.blockAll then
                    return -damage
                endif
                if this.block==0.0 then
                    return -this.percent*damage
                else
                    if this.block>=RAbsBJ(damage) then
                        return -damage
                    endif
                    return -this.block
                endif
            endif
            return 0.0
        endmethod
        static method create takes unit whichUnit,boolean blockAll,real percent,real block,real chance returns thistype
            local thistype this=allocate(whichUnit,1)
            set this.blockAll=blockAll
            set this.percent=percent
            set this.block=block
            set this.chance=chance
            return this
        endmethod
    endstruct*/
    //======================================================
    /*struct ObitoDamageBlock extends DamageModifier
        method onDamageTaken takes unit damageSource, real damage returns real
            int stack=GetInt(GetHandleId(this.targetunit),Kamui_KEY)-1
            BJDebugMsg(GetUnitName(this.targetunit) + " key: "+ I2S(Kamui_KEY) + " stack " + I2S(stack) )
            if stack>=0 then
                SetInt(GetHandleId(this.targetunit),Kamui_KEY,stack)
                DestroyEffect(AddSpecialEffectTarget("war3mapImported\\BlackBlink.mdx",this.targetunit,"chest"))
                return -damage
            else
                return 0.0
            endif
        endmethod
        static method create takes unit u returns thistype
            return allocate(u,1)
        endmethod
    endstruct*/
    //======================================================
    
endlibrary