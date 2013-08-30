function Chidori_Learn_Actions takes nothing returns nothing
    local unit Caster = GetTriggerUnit()

    call UnitAddAbility(Caster, 'A05N' )
    call SetUnitAbilityLevel(Caster, 'A05N', GetUnitAbilityLevel(Caster,'A09J') )
    call UnitMakeAbilityPermanent(Caster,true,'A05N')

    set Caster = null
endfunction

//===========================================================================
function Chidori_Learn_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A09J'
endfunction
function InitTrig_Chidori_Learn takes nothing returns nothing
    set gg_trg_Chidori_Learn = CreateTrigger(  )
    call DisableTrigger( gg_trg_Chidori_Learn )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chidori_Learn, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_Chidori_Learn, Condition( function Chidori_Learn_Conditions ) )
    call TriggerAddAction( gg_trg_Chidori_Learn, function Chidori_Learn_Actions )
endfunction