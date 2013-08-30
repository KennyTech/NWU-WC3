scope LightningcloneCast initializer Init
  private function Trig_LightningClone_Cast_Actions takes nothing returns nothing
      local unit Caster = GetTriggerUnit()
      local unit Summon

      if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_CAST and GetSpellAbilityId()=='A0GF' then
         call SetItemVisible( UnitAddItemById( Caster, 'I063' ), false )
      elseif GetTriggerEventId()==EVENT_PLAYER_UNIT_SUMMON and GetUnitAbilityLevel(GetSummonedUnit(),'B00V') > 0 then
         set Caster = GetSummoningUnit()
         set Summon = GetSummonedUnit()

         //Add Frog Kata ability if Kakashi has it
         call SetUnitAbilityLevel( Summon, 'A09T', GetUnitAbilityLevel(Caster,'A09T') )
         call SetUnitMaxState(Summon, UNIT_STATE_MAX_LIFE, R2I(GetUnitState(Caster, UNIT_STATE_MAX_LIFE)) )

         call SetUnitPathing( Summon, false )
         if GetUnitOldOrderType(Caster,1) == 1 then //TARGET
            if GetUnitOldOrderTarget(Caster,1)!=null then
               call IssueTargetOrderById(Summon, GetUnitOldOrderID(Caster,1), GetUnitOldOrderTarget(Caster,1) )
            endif
         elseif GetUnitOldOrderType(Caster,1) == 2 then //POINT
            call IssuePointOrderById(Summon, GetUnitOldOrderID(Caster,1), GetUnitOldOrderX(Caster,1), GetUnitOldOrderY(Caster,1) )
         endif
         call SetUnitX(Summon,GetUnitX(Caster))
         call SetUnitY(Summon,GetUnitY(Caster))
         call SetUnitPathing( Summon, true )
      endif

      set Caster = null
      set Summon = null
  endfunction

  private function Init takes nothing returns nothing
      local integer index = 0
      set gg_trg_LightningClone_Cast = CreateTrigger()
      call DisableTrigger( gg_trg_LightningClone_Cast )
      loop
          call TriggerRegisterPlayerUnitEvent(gg_trg_LightningClone_Cast, Player(index), EVENT_PLAYER_UNIT_SPELL_CAST, null)
          call TriggerRegisterPlayerUnitEvent(gg_trg_LightningClone_Cast, Player(index), EVENT_PLAYER_UNIT_SUMMON, null)
          set index = index + 1
          exitwhen index == bj_MAX_PLAYER_SLOTS
      endloop
      call TriggerAddAction( gg_trg_LightningClone_Cast, function Trig_LightningClone_Cast_Actions )
  endfunction
endscope