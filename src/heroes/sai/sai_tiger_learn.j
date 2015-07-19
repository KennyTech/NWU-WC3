scope SaiTigerLearn

    define
        private ABIL_REAL  = 'CW42'
        private ABIL_DUMMY = 'A0LL'
    enddefine

    private function onLearn takes nothing returns boolean
        local unit u
        if GetLearnedSkill() == ABIL_DUMMY then
            set u = GetTriggerUnit()
            call UnitAddAbility(u, ABIL_REAL )
            call SetUnitAbilityLevel(u, ABIL_REAL, GetUnitAbilityLevel(u,ABIL_DUMMY) )
            call UnitMakeAbilityPermanent(u, true, ABIL_REAL)
            set u = null
        endif
        return false
    endfunction

    public function Init takes nothing returns nothing
        call GT_LearnEvent(ABIL_DUMMY, function onLearn)
    endfunction

endscope