scope SharinganCastCopied

  define private ID = 'O009';

  private function onCast takes nothing returns boolean
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
      return false
  endfunction

  public void Init(){
    SpellCast(ID)
  }
endscope