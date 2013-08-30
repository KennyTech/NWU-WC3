scope SharinganCopy

  define{
    ID = 'A03G'
  }

  private function onCast takes nothing returns boolean
      local integer Ability
      local unit Caster = GetTriggerUnit()
      local unit Target = GetSpellTargetUnit()
      local integer SpellLVL = GetUnitAbilityLevel(Caster,'A03G')
      local integer i = GetHandleId(Caster)
      local integer CD
      
      local integer utype = GetUnitTypeId(Target)
      local timer t
      

      call UnitMakeAbilityPermanent(Caster,false,LoadInteger(udg_UnitHashtable, i, 13))
      call UnitMakeAbilityPermanent(Caster,false,MR_ANKO_SPELLBOOK)
      call UnitMakeAbilityPermanent(Caster,false,MR_ANKO)
      call UnitMakeAbilityPermanent(Caster,false,'A02D')
      call UnitMakeAbilityPermanent(Caster,false,'A024')
      call UnitMakeAbilityPermanent(Caster,false,'A00Q')
      call UnitRemoveAbility( Caster, LoadInteger(udg_UnitHashtable, i, 13) )
      call UnitRemoveAbility( Caster, 'A02D' ) // Guy Fervor
      call UnitRemoveAbility( Caster, 'A024' ) // Kiba Spellbook
      call UnitRemoveAbility( Caster, 'A00Q' ) // Kiba Shukaku AS
      call UnitRemoveAbility( Caster, 'A0AA' ) // Anko Snake Protection Snake
      call UnitRemoveAbility( Caster, MR_ANKO ) // Anko Snake Protection MResist
      call UnitRemoveAbility( Caster, MR_ANKO_SPELLBOOK)

      if utype  ==  'E004' then//ANKO
          set Ability = 'A0AW'
          set CD = 0
          call UnitAddAbility(Caster, 'A0AA' )
          //call UnitAddAbility(Caster, 'A0AN' )
          call SetUnitAbilityLevel(Caster, 'A0AA', SpellLVL )
          //call SetUnitAbilityLevel(Caster, 'A0AN', SpellLVL )
          call UnitMakeAbilityPermanent(Caster,true,'A0AA')
          //call UnitMakeAbilityPermanent(Caster,true,'A0AN')
          
          call UnitAddAbility(Caster,MR_ANKO_SPELLBOOK)
          call UnitAddAbility(Caster, MR_ANKO)
          
          call UnitMakeAbilityPermanent(Caster,true,MR_ANKO_SPELLBOOK)
          call UnitMakeAbilityPermanent(Caster,true,MR_ANKO)
          
          call SetUnitAbilityLevel(Caster,MR_ANKO,SpellLVL)
          
          call TimerStart(NewTimerUnit(Caster),0.1,true,function SnakeProtection_Loop)
      elseif utype  ==  'O000' then//ASUMA
         set Ability = 'A005'
         set CD = 0
      elseif utype=='N00U' then//CHOUYI
         set Ability = 'A0CV'
         set CD = 16
      elseif utype=='O00C' then//DANZO
         set Ability = 'A0IX'
         set CD = 16
      elseif utype=='E00H' or utype=='E00J' then//DEIDARA
         set Ability = 'A091'
         set CD = 36-6*SpellLVL
      elseif utype=='E00D' then//GAARA
         set Ability = 'A05B'
         set CD = 10
      elseif utype=='N00Z' then//GUY
         set Ability = 'A01Z'
         set CD = 0
         call UnitAddAbility( Caster, 'A02D' )
         call UnitMakeAbilityPermanent(Caster,true,'A02D')
      elseif utype=='H000' then//HAKU
         set Ability = 'A01I'
         set CD = 7
      elseif utype=='E00E' then//HINATA***
         set Ability = 'A058'
         set CD = 0
      elseif utype=='H017' then//INO
         set Ability = 'A09G'
         set CD = 20
      elseif utype=='E000' then//ITACHI
         set Ability = 'A0EK'
         set CD = 15
      elseif utype=='H00H' then//JIRAYA
         set Ability = 'A030'
         set CD = 15
      elseif utype=='N00T' then//JIROBO
         set Ability = 'A011'
         set CD = 15
      elseif utype=='N005' then//JUUGO
         set Ability = 'A0FC'
         set CD = 18
      elseif utype=='U006' then//KABUTO
         set Ability = 'A06G'
         set CD = 12
      elseif utype=='H00X' or utype=='H01U' then//KAKUZU
         set Ability = 'A0G4'
         set CD = 10
      elseif utype=='H011' then//KANKURO
         set Ability = 'A00E'
         set CD = 20
      elseif utype=='E00F' or utype=='E00G' then//KIBA
         set Ability = 'A07B' // Shikaku damage
         set CD = 0
         call UnitAddAbility(Caster, 'A024' )
         call SetUnitAbilityLevel(Caster, 'A00Q', SpellLVL )
         call UnitMakeAbilityPermanent(Caster,true,'A024')
         call UnitMakeAbilityPermanent(Caster,true,'A00Q')
      elseif utype=='H00Z' or utype=='H002' then//KIDOUMARU
         set Ability = 'A095'
         set CD = 9
      elseif utype=='E001' or utype=='E002' then//KIMI
         set Ability = 'A031'
         set CD = 0
      elseif utype=='O004' then//KISAME
         set Ability = 'A00N'
         set CD = 0
      elseif utype=='H00V' then//NARUTO
         set Ability = 'A09S'
         set CD = 10
      elseif utype=='N00Y' then//LEE
         set Ability = 'A02J'
         set CD = 12
      elseif utype=='H01X' then//Madara
          set Ability='A0K9'
          set CD=15
      elseif utype=='H016' then // MIZUKAGE
          set Ability = 'A10J'
          set CD = 15
      elseif utype=='O00A' then//NEJI
         set Ability = 'A03D'
         set CD = 25-5*SpellLVL
      elseif utype=='E007' then//NIDAIME
         set Ability = 'A01Y'
         set CD = 14
      elseif utype==OBITO then
          set Ability = 'A0L6'
          set CD = 25
      elseif utype=='H01J' then // ONOKI
          set Ability = 'A107' 
          set CD = 0
      elseif utype=='O008' then//OROCHIMARU
         set Ability = 'A06L'
         set CD = 8
      elseif utype=='H01N' then//PEIN
          set Ability='A0K6'
          set CD=15
      elseif utype=='H01G' then //RAIKAGE
          set Ability = 'A10O'
          set CD = 0
          call RaikagePasive_Add(Caster)
      elseif utype=='N00V' then//SAKON
         set Ability = 'A0GZ'
         set CD = 15
      elseif utype=='E006' then//SAKURA
         set Ability = 'A093'
         set CD = 35-5*SpellLVL
      elseif utype=='E00I' then//SARUTOBI
         set Ability = 'A0AK'
         set CD = 12
      elseif utype=='E008' then//SASUKE
         set Ability = 'A068'
         set CD = 10
      elseif utype=='O005' then//SHIKAMARU
         set Ability = 'A07M'
         set CD = 7
      elseif utype=='E003' then//SHODAIME
         set Ability = 'A01J'
         set CD = 17  //16-2*SpellLVL
      elseif utype=='H00Y' then//SHINO
         set Ability = 'A03S'
         set CD = 0
      elseif utype=='O003' then //SUIGETSU
         set Ability = 'A0HQ'
         set CD = 0
      elseif utype=='E00A' then//TAYUYA***
         set Ability = 'A05I'
         set CD = 65
      elseif utype=='H009' then//TEMARI
         set Ability = 'A02H'
         set CD = 10
      elseif utype=='H010' or utype=='H01O' then//TENTEN
         set Ability = 'A08Y'
         set CD = 8
      elseif utype=='E005' then//TSUNADE
         set Ability = 'A0I8'
         set CD = 10
      elseif utype=='O00T' then//YAMATO
         set Ability = 'A0AC'
         set CD = 16
      elseif utype=='E00B' then//YONDAIME
         set Ability = 'A0BE'
  //       set Ability = 'A00F'
         set CD = 10
      elseif utype=='E00P' or utype=='E00Q' then//YUGITO
         set Ability = 'A071'
         set CD = 12
      elseif utype=='O001' then//ZABUSA
         set Ability = 'A0A5'
         set CD = 15
      endif

      call UnitAddAbility( Caster, Ability )
      call SetUnitAbilityLevel( Caster, Ability, SpellLVL )
      call UnitMakeAbilityPermanent(Caster,true,Ability)
      call SaveInteger(udg_UnitHashtable, i, 13, Ability)
      call SaveInteger(udg_UnitHashtable, i, 14, CD)

      set t = GetHandleTimer(GetHandleId(Caster),"Sharingan|timer")
      if t == null then
          set t = NewTimerUnit(Caster)
          call SetHandleHandle(GetHandleId(Caster),"Sharingan|timer",t)
      else
          call PauseTimer(t)
      endif
      call SetTimerData(t,0)
      call TimerStart(t,1,true,function Sharingan_CD)
      
      set Caster = null
      set Target = null
      set t      = null
      return false
  endfunction

  public void Init(){
    SpellCast(ID)
  }
endscope