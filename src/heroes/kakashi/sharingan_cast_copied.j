function Trig_Sharingan_Cast_Copied_Actions takes nothing returns nothing
    local unit Caster = GetTriggerUnit()
    local integer i = GetHandleId(Caster)

    if GetSpellAbilityId() == LoadInteger(udg_UnitHashtable, i, 13) then
       call UnitRemoveAbility( Caster, 'A03G' )
       call UnitAddAbility( Caster, 'A06A' )
       call SetUnitAbilityLevel( Caster, 'A06A', GetUnitAbilityLevel(Caster,'A04Z') )
       call UnitMakeAbilityPermanent( Caster, true, 'A06A')

       call PolledWait( LoadInteger(udg_UnitHashtable, i, 14) )

       call UnitRemoveAbility( Caster, 'A06A' )
       call UnitAddAbility( Caster, 'A03G' )
       call SetUnitAbilityLevel( Caster, 'A03G', GetUnitAbilityLevel(Caster,'A04Z') )
       call UnitMakeAbilityPermanent( Caster, true, 'A03G')
    endif

    set Caster = null
endfunction

//===========================================================================
function Trig_Sharingan_Cast_Copied_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == 'O009'
endfunction
function InitTrig_Sharingan_Cast_Copied takes nothing returns nothing
    set gg_trg_Sharingan_Cast_Copied = CreateTrigger(  )
    call DisableTrigger( gg_trg_Sharingan_Cast_Copied )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sharingan_Cast_Copied, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sharingan_Cast_Copied, Condition( function Trig_Sharingan_Cast_Copied_Conditions ) )
    call TriggerAddAction( gg_trg_Sharingan_Cast_Copied, function Trig_Sharingan_Cast_Copied_Actions )
endfunction