library Sharingan initializer Init requires TextTag,TimerUtils

    globals
        public boolean array on [15]
    endglobals
    
    public function CD takes nothing returns nothing
        local integer tick = GetTimerDataEx()+1
        local unit Caster  = GetTimerUnit()
        
        call SetTimerData(GetExpiredTimer(),tick)
        if on[GetPlayerId(GetOwningPlayer(Caster))] then
            call TextTag_UnitOnly(Caster,GetPlayerStringColored(GetOwningPlayer(Caster),I2S(120-tick)),"")
        endif
        if tick>=120 then
            call UnitMakeAbilityPermanent(Caster,false,LoadInteger(udg_UnitHashtable, GetHandleId(Caster), 13))
            call UnitMakeAbilityPermanent(Caster,false,'A02D')
            call UnitMakeAbilityPermanent(Caster,false,'A024')
            call UnitMakeAbilityPermanent(Caster,false,'A00Q')
            
            call UnitMakeAbilityPermanent(Caster,false,MR_ANKO_SPELLBOOK)
            call UnitMakeAbilityPermanent(Caster,false,MR_ANKO)
            call UnitRemoveAbility( Caster, LoadInteger(udg_UnitHashtable, GetHandleId(Caster), 13) )
            call UnitRemoveAbility( Caster, 'A02D' ) // Guy Fervor
            call UnitRemoveAbility( Caster, 'A024' ) // Kiba Spellbook
            call UnitRemoveAbility( Caster, 'A00Q' ) // Kiba Shukaku AS
            call UnitRemoveAbility( Caster, 'A0AA' ) // Anko Snake Protection Snake
            call UnitRemoveAbility( Caster, MR_ANKO ) // Anko Snake Protection MResist
            call UnitRemoveAbility( Caster, MR_ANKO_SPELLBOOK)
            if GetUnitAbilityLevel(Caster,'A06A') > 0 then
                call UnitMakeAbilityPermanent(Caster,false,'A06A' )
                call UnitRemoveAbility( Caster, 'A06A' )
                call UnitAddAbility( Caster, 'A03G' )
                call SetUnitAbilityLevel( Caster, 'A03G', GetUnitAbilityLevel(Caster,'A04Z') )
                call UnitMakeAbilityPermanent( Caster, true, 'A03G')
            endif
            call PauseTimer(GetExpiredTimer())
        endif
    endfunction
    
    private function onCommand takes nothing returns nothing
        if GetUnitTypeId(GetPlayerHero(GetTriggerPlayer()))=='O009' then
            set on[GetPlayerId(GetTriggerPlayer())] = not on[GetPlayerId(GetTriggerPlayer())]
        endif
    endfunction 
    
    
    private function Init takes nothing returns nothing
        local trigger t=CreateTrigger()
        local integer i=0
        loop
            call TriggerRegisterPlayerChatEvent(t,udg_team1[i],"-sharingan",false)
            call TriggerRegisterPlayerChatEvent(t,udg_team2[i],"-sharingan",false)
            set i=i+1
            exitwhen i>5
        endloop
        call TriggerAddAction(t,function onCommand)
        set t=null
    endfunction
    
endlibrary