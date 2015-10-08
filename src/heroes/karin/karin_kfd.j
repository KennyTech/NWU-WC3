scope KarinKFD

    globals
        private constant integer BUFF_ID    = 'BK03'    // Buff ID of "Kongou Fuusa (chains)" 
        private constant integer BUFF_ID2   = 'BK05'    // Buff ID of "Kongou Fuusa (aoe sfx)" 
        private constant string EFFECT      = "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl" 
    endglobals

    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetTriggerUnit(), BUFF_ID) > 0 or GetUnitAbilityLevel(GetTriggerUnit(), BUFF_ID2) > 0
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local texttag tt = CreateTextTag()
        
        call DestroyEffect(AddSpecialEffect (EFFECT, x, y))
        call SetUnitState(c, UNIT_STATE_MANA, GetUnitState(c, UNIT_STATE_MANA) - 50*KF_Level)
        
        call ManaBurnEx(c,50*KF_Level,false)
        
        call Damage_Spell(HeroKarin,c,25*KF_Level)
        
        if (IsVisibleToPlayer(x, y, GetLocalPlayer()) == true) then
            call SetTextTagVisibility(tt, true)
        endif
        
        
        set tt = null
        set c = null
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_CAST)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope
