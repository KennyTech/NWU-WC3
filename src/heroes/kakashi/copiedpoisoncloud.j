scope CopiadPoisonCloud

  define private ID = 'A00E';

  private function CopiedPoisonCloud_Main takes nothing returns nothing
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


  private function onCast takes nothing returns boolean
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

      return false
  endfunction

  public void Init(){
    SpellCast(ID)
  }
endscope