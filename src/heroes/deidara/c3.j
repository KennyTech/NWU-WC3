scope C3

  define
    private ABIL_ID1 = 'A09M'
    private ABIL_ID2 = 'A09W'
    private ABIL_ID3 = 'A09X'
    private ABIL_ID4 = 'A09Y'
    private ABIL_ID5 = 'A09Z'
  enddefine

  private function Explosion takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local int h = GetHandleId(t)

    local unit Caster = GetHandleUnit(h, "Caster")
    local real X = GetHandleReal(h, "X")
    local real Y = GetHandleReal(h, "Y")
    local effect FX  = GetHandleEffect(h, "FX")
    local integer SpellLVL = GetHandleInt(h, "SpellLVL")
    local integer AOE = GetHandleInt(h, "AOE")
    local real damage = GetHandleReal(h, "damage")
    local player Owner = GetHandlePlayer(h, "Owner")
    local unit Dummy = GetHandleUnit(h, "Dummy")
    local integer time = GetHandleInt(h, "TimeLeft") - 1
    call SetHandleInt(h, "TimeLeft", time)

    if time == 0 then
      call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",X,Y))
      call EnumDestructablesInCircle(AOE, X,Y,function KillDestructableEnum)
      call UnitDamageAreaSfx(Caster,X,Y,AOE,damage,DAMAGE_SPELL,'A053',1,ORDER_slow,null,null)
      set Dummy = CreateUnit(GetOwningPlayer(Caster),'h019', X,Y, 0)
      call SetUnitAnimation(Dummy,"death")
      call SetUnitTimeScale(Dummy, 10 * 0.01)
      call UnitApplyTimedLife( Dummy, 'BTLF', 10 )
      call SetSoundPosition(gg_snd_NightElfBuildingDeathLarge1,X,Y,0)
      call SetSoundVolume(gg_snd_NightElfBuildingDeathLarge1, 127)
      call StartSound(gg_snd_NightElfBuildingDeathLarge1)
      call TerrainDeformRipple(X,Y, 1000, -75, 500, 1, 2000/1800, 1/4, 975/1000, false)
      call ReleaseTimer(t)
    elseif time == 2 then
      call DestroyEffect(FX)
    endif
    set Dummy=null
    set Caster=null
    set Owner=null
    set t=null
    set FX=null
  endfunction

  private function onSpell takes nothing returns boolean
    local unit Caster = GetTriggerUnit()
    local real X = GetSpellTargetX()
    local real Y = GetSpellTargetY()
    local effect FX  = AddSpecialEffect("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl",X,Y)
    local integer SpellLVL = GetUnitAbilityLevel(Caster, GetSpellAbilityId())
    local integer AOE = 800+50*GetUnitAbilityLevel(Caster, GetSpellAbilityId())
    local real damage = 110+60*SpellLVL
    local player Owner = GetTriggerPlayer()
    local unit Dummy = CreateUnit(GetOwningPlayer(Caster),'h01A', X,Y, 0)
    local unit m
    local timer t
    local integer h

    if GetUnitTypeId(GetPlayerHero(Owner))==INO then
        set Caster=GetPlayerHero(Owner)
    endif

    call IssuePointOrderById(Dummy, ORDER_attackground, X, Y)
    call UnitApplyTimedLife( Dummy, 'BTLF', 10 )

    set t = NewTimer()
    set h = GetHandleId(t)
    call SetHandleHandle(h, "Caster", Caster)
    call SetHandleReal(h, "X", X)
    call SetHandleReal(h, "Y", Y)
    call SetHandleHandle(h, "FX", FX)
    call SetHandleInt(h, "SpellLVL", SpellLVL)
    call SetHandleInt(h, "AOE", AOE)
    call SetHandleReal(h, "damage", damage)
    call SetHandleHandle(h, "Owner", Owner)
    call SetHandleHandle(h, "Dummy", Dummy)
    call SetHandleInt(h, "TimeLeft", 3)

    call TimerStart(t, 1, true, function Explosion)
   
    set Dummy=null
    set Caster=null
    set Owner=null
    set t=null
    set FX=null
    return false
  endfunction
  
  public function Init takes nothing returns nothing
    call GT_RegisterSpellEffectEvent(ABIL_ID1, function onSpell)
    call GT_RegisterSpellEffectEvent(ABIL_ID2, function onSpell)
    call GT_RegisterSpellEffectEvent(ABIL_ID3, function onSpell)
    call GT_RegisterSpellEffectEvent(ABIL_ID4, function onSpell)
    call GT_RegisterSpellEffectEvent(ABIL_ID5, function onSpell)
  endfunction

endscope

/*

function Trig_C3_Damage takes nothing returns boolean
    local unit m = GetFilterUnit()
    local unit u = GetTriggerUnit()
    if IsUnitEnemy(m,udg_S_Deidara_C3_Player[GetUnitIndex(u)]) and IsUnitType(m,UNIT_TYPE_DEAD)==false and IsUnitType(m,UNIT_TYPE_STRUCTURE)==false then
        //if UnitAbsorbSpell(m)==false then
            call Damage_Spell(udg_PlayerHero[GetPlayerId(udg_S_Deidara_C3_Player[GetUnitIndex(u)])+1],m,110+60*GetUnitAbilityLevel(u,GetSpellAbilityId()))
            call CasterCastTarget(m,'A053',"slow")
        //endif
    endif
    set m = null
    set u = null
    return false
endfunction

function Trig_C3_Actions takes nothing returns nothing
   local unit Dummy
   local unit Caster = GetTriggerUnit()
   local real X = GetSpellTargetX()
   local real Y = GetSpellTargetY()
   local effect FX
   local integer SpellLVL = GetUnitAbilityLevel(Caster, GetSpellAbilityId())
   local integer AOE = 800+50*GetUnitAbilityLevel(Caster, 'A09N')
   local real Damage = 110+60*SpellLVL
   set udg_S_Deidara_C3_Player[GetUnitIndex(Caster)] = GetTriggerPlayer()
   set FX = AddSpecialEffect("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl",X,Y)
   set Dummy = CreateUnit(GetOwningPlayer(Caster),'h01A', X,Y, 0)
   call IssuePointOrderById(Dummy,851984,X,Y)
   set Dummy = null
   call PolledWait( 1.00 )
   call DestroyEffect( FX )
   call PolledWait( 2.00 )
   call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",X,Y))

   call EnumDestructablesInCircle(AOE, X,Y,function KillDestructableEnum)
   call GroupEnumUnitsInRange(udg_GROUP,X,Y,AOE,Filter(function Trig_C3_Damage))
   //call UnitDamageAndEffectArea(Caster, X,Y, AOE, Damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, 'A053', SpellLVL, OrderId("slow"), null, null, true )

   set Dummy = CreateUnit(GetOwningPlayer(Caster),'h019', X,Y, 0)
   call SetUnitAnimation(Dummy,"death")
   call SetUnitTimeScalePercent(Dummy, 10)
   call SetSoundPosition(gg_snd_NightElfBuildingDeathLarge1,X,Y,0)
   call SetSoundVolume(gg_snd_NightElfBuildingDeathLarge1, 127)
   call StartSound(gg_snd_NightElfBuildingDeathLarge1)
   call TerrainDeformRipple(X,Y, 1000, -75, 500, 1, 2000/1800, 1/4, 975/1000, false)
   set Dummy = null

   set Caster = null
endfunction

//===========================================================================
function Trig_C3_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A09M' or GetSpellAbilityId() == 'A09W' or GetSpellAbilityId() == 'A09X' or GetSpellAbilityId() == 'A09Y' or GetSpellAbilityId() == 'A09Z'
endfunction
function InitTrig_C3 takes nothing returns nothing
    set gg_trg_C3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_C3 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_C3, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_C3, Condition( function Trig_C3_Conditions ) )
    call TriggerAddAction( gg_trg_C3, function Trig_C3_Actions )
endfunction

*/