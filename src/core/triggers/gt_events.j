library Events initializer init requires RegisterPlayerUnitEvent

    define
        EVENT_SPELL = 0
        EVENT_LEARN = 1
    enddefine

    globals 
        private hashtable ht = InitHashtable()
    endglobals
    
    private function onCast takes nothing returns boolean
        call TriggerEvaluate(LoadTriggerHandle(ht, EVENT_SPELL, GetSpellAbilityId()))
        return false
    endfunction
    
    private function onLearn takes nothing returns boolean
        call TriggerEvaluate(LoadTriggerHandle(ht, EVENT_LEARN, GetLearnedSkill()))
        return false
    endfunction
    
    private nothing registerEvent(integer Event,integer Abil,code Code){
        if (HaveSavedHandle(ht, Event, Abil) == false){
            SaveTriggerHandle(ht, Event, Abil, CreateTrigger());
        }
        TriggerAddCondition(LoadTriggerHandle(ht,Event,Abil),Filter(Code));
    }
    
    private function init takes nothing returns nothing
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_SPELL_EFFECT, function onCast)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_HERO_SKILL, function onLearn)
    endfunction
    
    //*********************************************************************************************
    //  API
    //*********************************************************************************************
 
    function GT_RegisterSpellEffectEvent takes integer abil, code cast returns nothing
        call registerEvent(EVENT_SPELL,abil,cast)
    endfunction
    
    function GT_LearnEvent takes integer abil, code learn returns nothing
         call registerEvent(EVENT_LEARN,abil,learn)
    endfunction
    
    //*********************************************************************************************
    //  WRAPPERS
    //*********************************************************************************************
    
    define{
        SpellCast(id) = GT_RegisterSpellEffectEvent(id,function onCast)
        SpellCast(id,cod) = GT_RegisterSpellEffectEvent(id,cod)
        SpellReg(id) = GT_RegisterSpellEffectEvent(id,function onCast)
        SpellReg(id,cod) = GT_RegisterSpellEffectEvent(id,cod)
    }
    
endlibrary