function CopiedPoisonCloud_Main takes nothing returns nothing
   local timer t = GetExpiredTimer()
   local integer i = GetHandleId( t )
   local integer j
   local unit Caster = LoadUnitHandle( udg_TimerHashtable, i, 0 )
   local unit Dummy = LoadUnitHandle( udg_TimerHashtable, i, 1 )

   call UnitDamageArea(Caster, GetUnitX(Dummy),GetUnitY(Dummy),500,LoadReal(udg_TimerHashtable,i,2),DAMAGE_SPELL, null)

   if IsUnitType(Dummy, UNIT_TYPE_DEAD) == true then
      call FlushChildHashtable( udg_TimerHashtable, i )
      call PauseTimer( t )
      call DestroyTimer( t )
   endif
   set t = null
   set Caster = null
   set Dummy = null
endfunction


function Copied_Poison_Cloud_Actions takes nothing returns nothing
    local timer t = CreateTimer()
    local integer i = GetHandleId( t )
    local unit Caster = GetTriggerUnit()
    local unit Dummy
    local real X = GetSpellTargetX()
    local real Y = GetSpellTargetY()

    set Dummy = CreateUnit( GetOwningPlayer(Caster),'h02A', X,Y, 0 )
    call UnitApplyTimedLife( Dummy, 'BTLF', 14 )
    set Dummy = null

    set Dummy = CreateUnit( GetOwningPlayer(Caster),'h02A', X,Y, 0 )
    call UnitApplyTimedLife( Dummy, 'BTLF', 14 )
    call SaveUnitHandle  ( udg_TimerHashtable, i, 0, Caster )
    call SaveUnitHandle  ( udg_TimerHashtable, i, 1, Dummy )
    call SaveReal        ( udg_TimerHashtable, i, 2, 8*GetUnitAbilityLevel(Caster,'A00E') )
    call TimerStart(t,1,true,function CopiedPoisonCloud_Main)
    set t = null
    set Dummy = null
endfunction

//===========================================================================
function Copied_Poison_Cloud_Conditions takes nothing returns boolean
   return GetSpellAbilityId() == 'A00E'
endfunction
function InitTrig_Copied_Poison_Cloud takes nothing returns nothing
    local integer index = 0
    set gg_trg_Copied_Poison_Cloud = CreateTrigger(  )
    call DisableTrigger( gg_trg_Copied_Poison_Cloud )
    loop
        call TriggerRegisterPlayerUnitEvent(gg_trg_Copied_Poison_Cloud, Player(index), EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
        set index = index + 1
        exitwhen index == bj_MAX_PLAYER_SLOTS
    endloop
    call TriggerAddCondition( gg_trg_Copied_Poison_Cloud, Condition( function Copied_Poison_Cloud_Conditions ) )
    call TriggerAddAction( gg_trg_Copied_Poison_Cloud, function Copied_Poison_Cloud_Actions )
endfunction