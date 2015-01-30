scope CloneGemFix initializer onInit

    define private TRUE_SIGH = 'Agyv'

    /*private function onEnter takes nothing returns boolean
        local unit u = GetTriggerUnit()
        if IsUnitIllusion(u) and GetUnitAbilityLevel(u, TRUE_SIGH) > 0 then
            static if TEST_MODE then
                call Test_SuccessMsg("REMOVING TRUE_SIGH FROM CLONE")
            endif
            call UnitRemoveAbility(u, TRUE_SIGH)
        endif
        set u = null
        return false
    endfunction

    private function onInit takes nothing returns nothing
        call GT_RegisterUnitEnter(function onEnter)
    endfunction*/

    private function onEnter takes nothing returns boolean
        local unit u = GetSummonedUnit()
        if IsUnitIllusion(u) and GetUnitAbilityLevel(u, TRUE_SIGH) > 0 then
            static if TEST_MODE then
                call Test_SuccessMsg("REMOVING TRUE_SIGH FROM CLONE")
            endif
            call UnitRemoveAbility(u, TRUE_SIGH)
        endif
        set u = null
        return false
    endfunction

    private function onInit takes nothing returns nothing
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_SUMMON, function onEnter)
    endfunction

endscope