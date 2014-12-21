library Damage requires Status,Blink

    globals
        constant integer DAMAGE_FISICO = 1
        constant integer DAMAGE_SPELL  = 2
        constant integer DAMAGE_PURE   = 3
    endglobals
    
    function Damage_Pure takes unit source,unit target,real amount returns nothing
        local real TargetLife 
        if IsUnitTypeWard(target)==false then
            set TargetLife = GetWidgetLife(target)-amount
            if TargetLife < 0.405 then
                call DisableTrigger( DamageEvent_currentTrg )
                call UnitDamageTarget( source, target, -500000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS)
                call EnableTrigger( DamageEvent_currentTrg )
            else
                call SetWidgetLife(target,TargetLife)
                call BlinkRemoval(target,GetOwningPlayer(source),GetOwningPlayer(target))
            endif
            call AssistRegister(target,source)
        endif
    endfunction
    
    function Damage_IsValidAttack takes nothing returns boolean
        return GetEventDamage()>0 and GetLastTarget(GetEventDamageSource())==GetTriggerUnit()
    endfunction
endlibrary