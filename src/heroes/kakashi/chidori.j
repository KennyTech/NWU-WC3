scope Chidori

    public function onHit takes proj m returns nothing
        if m.Hit then
            if UnitAbsorbSpell(m.targetUnit)==false then
                call Damage_Spell(m.caster,m.targetUnit, 100+150*GetUnitAbilityLevel(m.caster,'A05N'))
                call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl",m.x,m.y))
            endif
        endif
        call SetUnitTimeScale(m.caster,1)
        call DestroyEffect(m.efecto)
        call SetUnitPathing(m.caster,true)
        call UnitRemoveInmunity(m.caster)
    endfunction

    public function onSpell takes nothing returns boolean
        local proj m
        local unit u=GetTriggerUnit()
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_CHANNEL then
            if GetSpellAbilityId()=='A05N' then
                call AddSpecialEffectTimed(AddSpecialEffectTarget("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl",u,"hand right"),1)
            endif
        else
            call SetUnitTimeScale(u,3)
            call SetUnitPathing(u,false)
            call UnitAddInmunity(u)
            set proj(CreateProjTarget(u,u,GetSpellTargetUnit(),900,0,true,false,90,onLoopFX,0,onHit,0)).efecto=AddSpecialEffectTarget("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl",u,"hand right")
        endif
        set u=null
        return false
    endfunction

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('A05N',function onSpell)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_SPELL_CHANNEL,function onSpell)
    endfunction

endscope

/*
function ChidoriMain takes nothing returns nothing
   local timer t = GetExpiredTimer()
   local integer i = GetHandleId( t )
   local unit Dummy
   local unit Target = LoadUnitHandle( udg_TimerHashtable, i, 0 )
   local unit Missile = LoadUnitHandle( udg_TimerHashtable, i, 1 )
   local real Speed = LoadReal( udg_TimerHashtable, i, 2 )
   local real dx = GetUnitX(Target) - GetUnitX(Missile)
   local real dy = GetUnitY(Target) - GetUnitY(Missile)
   local real Angle = bj_RADTODEG * Atan2(dy, dx)
   local real DistanceToTarget = SquareRoot(dx * dx + dy * dy)

   call SetUnitFacing( Missile, Angle )
   call IssueImmediateOrder( Missile, "stop" )
   set dx = GetUnitX(Missile) + Speed * Cos(Angle * bj_DEGTORAD)
   set dy = GetUnitY(Missile) + Speed * Sin(Angle * bj_DEGTORAD)
   call SetUnitX(Missile, dx)
   call SetUnitY(Missile, dy)
   call DestroyEffect( AddSpecialEffect("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl",dx,dy) )
    if GetUnitAbilityLevel(Missile,'B03O')==0 and GetUnitAbilityLevel(Missile,'A00B')==0 then
        call UnitAddAbility( Missile, 'A00B' )
    endif
   
   
   if DistanceToTarget<=80 or IsUnitType(Missile, UNIT_TYPE_DEAD)==true then
      if IsUnitType(Missile, UNIT_TYPE_DEAD)==false then
         if UnitAbsorbSpell(Target)==false then
            call Damage_Spell(Missile, Target, 100+150*GetUnitAbilityLevel(Missile,'A05N'))

//            set Dummy = CreateUnit( GetOwningPlayer(Missile),'h012', dx,dy, 0 )
//            call SetUnitPathing( Dummy, false )
//            call UnitAddAbility( Dummy, 'A02F' )
//            call IssueTargetOrder( Dummy, "cripple", Target )
//            call UnitApplyTimedLife( Dummy, 'BTLF', 1 )
//            call ShowUnit( Dummy, false )
//            set Dummy = null

            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl",dx,dy) )
          endif
      endif

//      call PauseUnit(Missile,false)
      call SetUnitPathing( Missile, true )
      call SetUnitTimeScalePercent( Missile, 100 )
      call UnitRemoveAbility( Missile, 'A00B' )
//      call SetUnitInvulnerable( Missile, false )
      call IssueTargetOrder( Missile, "attack", Target )
      call DestroyEffect( LoadEffectHandle( udg_TimerHashtable, i, 3) )

      call FlushChildHashtable( udg_TimerHashtable, i )
      call PauseTimer( t )
      call DestroyTimer( t )
//   elseif (DistanceToTarget<=160) then
//      call PauseUnit(Missile,true)
   elseif (DistanceToTarget<=200) then
      call SetUnitAnimation( Missile, "Throw" )
   endif
   set Target = null
   set Missile = null
endfunction

function Chidori_Actions takes nothing returns nothing
    local timer t
    local integer i
    local unit Missile = GetTriggerUnit()

    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_CHANNEL then
       call FX_Destroy( AddSpecialEffectTarget("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", Missile,"hand right"), 1 )
    else
//       call SetUnitInvulnerable( Missile, true )
    if GetUnitAbilityLevel(Missile,'B03O')==0 then
        call UnitAddAbility( Missile, 'A00B' )
    endif
       call SetUnitTimeScalePercent( Missile, 300 )
       call SetUnitAnimation( Missile, "Spell Channel" )

       set t = CreateTimer()
       set i = GetHandleId( t )
       call SetUnitPathing( Missile, false )
       call SaveUnitHandle( udg_TimerHashtable, i, 0, GetSpellTargetUnit() )
       call SaveUnitHandle( udg_TimerHashtable, i, 1, GetTriggerUnit() )
       call SaveReal      ( udg_TimerHashtable, i, 2, 20 )
       call SaveEffectHandle( udg_TimerHashtable, i, 3, AddSpecialEffectTarget( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", Missile,"hand right" ) )
       call TimerStart( t,.02,true,function ChidoriMain)
       set t = null
    endif

    set Missile = null
endfunction

//===========================================================================
function Chidori_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A05N'
endfunction
function InitTrig_Chidori takes nothing returns nothing
    local integer index = 0
    set gg_trg_Chidori = CreateTrigger()
    call DisableTrigger( gg_trg_Chidori )
    loop
        call TriggerRegisterPlayerUnitEvent(gg_trg_Chidori, Player(index), EVENT_PLAYER_UNIT_SPELL_CHANNEL, null)
        call TriggerRegisterPlayerUnitEvent(gg_trg_Chidori, Player(index), EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
        set index = index + 1
        exitwhen index == bj_MAX_PLAYER_SLOTS
    endloop
    call TriggerAddCondition( gg_trg_Chidori, Condition( function Chidori_Conditions ) )
    call TriggerAddAction( gg_trg_Chidori, function Chidori_Actions )
endfunction
*/