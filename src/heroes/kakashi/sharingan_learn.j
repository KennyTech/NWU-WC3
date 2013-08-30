 scope SharinganLearn initializer Init
  function Trig_Sharingan_Learn_Actions takes nothing returns nothing
      local unit Caster = GetTriggerUnit()
      local integer SpellLVL = GetUnitAbilityLevel(Caster,'A04Z')
      local integer i = GetHandleId(Caster)
      local integer CopiedAbility = LoadInteger(udg_UnitHashtable, i, 13)

      if SpellLVL==1 then
        call UnitAddAbility( Caster, 'A03G' ) // Sharingan Cast
        call UnitMakeAbilityPermanent( Caster, true, 'A03G')
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,8,"You can type |cff99b4d1-sharingan |rif you wanna show or hide time left of copied spells.")
      endif
      if GetUnitAbilityLevel(Caster,CopiedAbility) > 0 then
         //Adjuts copied ability LVL
         call SetUnitAbilityLevel( Caster, CopiedAbility, SpellLVL )

         //Adjuts copied ability CD
         if CopiedAbility == 'A09M' then //Deidara ability
            call SaveInteger(udg_UnitHashtable, i, 14, 60-10*SpellLVL)
         elseif CopiedAbility == 'A03D' then //Neji ability
            call SaveInteger(udg_UnitHashtable, i, 14, 25-5*SpellLVL)
         elseif CopiedAbility == 'A093' then //Sakura ability
            call SaveInteger(udg_UnitHashtable, i, 14, 35-5*SpellLVL)
         elseif CopiedAbility == 'A01J' then //Shodaime ability
            call SaveInteger(udg_UnitHashtable, i, 14, 16-2*SpellLVL)
         elseif CopiedAbility == 'A10J' then //Mizukage ability
            call SaveInteger(udg_UnitHashtable, i, 14, 16-SpellLVL)
         elseif CopiedAbility == 'A0IX' then //Danzo ability
            call SaveInteger(udg_UnitHashtable, i, 14, 18-2*SpellLVL)
         endif
         //Adjuts related abilities LVL
         if CopiedAbility == 'A07B' then// Shikaku damage
            call SetUnitAbilityLevel(Caster, 'A00Q', SpellLVL ) //Shikaku speed
         endif
         if CopiedAbility == 'A0AW' then// Shikaku damage
            call SetUnitAbilityLevel(Caster, 'A0AA', SpellLVL ) //Anko Snake Protection Snake
            call SetUnitAbilityLevel(Caster, 'A0AN', SpellLVL ) //Anko Snake Protection MResist
         endif
      endif

      call SetUnitAbilityLevel( Caster, 'A03G', SpellLVL )
      call SetUnitAbilityLevel( Caster, 'A06A', SpellLVL )

      set Caster = null
  endfunction

  //===========================================================================
  function Trig_Sharingan_Learn_Conditions takes nothing returns boolean
      return GetLearnedSkill() == 'A04Z' and IsUnitIllusion(GetTriggerUnit()) == false
  endfunction
  private function Init takes nothing returns nothing
      trigger t = CreateTrigger()
      call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_HERO_SKILL )
      call TriggerAddCondition( t, Condition( function Trig_Sharingan_Learn_Conditions ) )
      call TriggerAddAction( t, function Trig_Sharingan_Learn_Actions )
  endfunction
endscope