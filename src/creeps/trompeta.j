scope Trompeta initializer Init

    define private COOLDOWN = 80

    static if TEST_MODE then
        private function Test takes unit u returns nothing
            if GetUnitName(u) != null then
                BJDebugMsg("[PASSING] h00L unit not null")
            else
                BJDebugMsg("[FAILING] h00L unit shouldn't be null")
            endif
        endfunction
    endif

    private function Trig_Trompeta_Actions takes nothing returns nothing
        static if TEST_MODE then
            BJDebugMsg("== MEGA CREEP BUILDING TESTS ==")
            Test(gg_unit_h00L_0035)
            Test(gg_unit_h00L_0044)
            Test(gg_unit_h00L_0047)
            Test(gg_unit_h00L_0111)
            Test(gg_unit_h00L_0090)
            Test(gg_unit_h00L_0096)
        endif
        set udg_Creep_Academias[1] = gg_unit_h00L_0035
        set udg_Creep_Academias[2] = gg_unit_h00L_0044
        set udg_Creep_Academias[3] = gg_unit_h00L_0047
        set udg_Creep_Academias[4] = gg_unit_h00L_0111
        set udg_Creep_Academias[5] = gg_unit_h00L_0090
        set udg_Creep_Academias[6] = gg_unit_h00L_0096
        call StartSound(gg_snd_TheHornOfCenarius)
        call ShowTextToForce(bj_FORCE_ALL_PLAYERS, 5.00,GetObjectName('e01I'))
        call DestroyTimer(GetExpiredTimer())
    endfunction

    private void Init() {
        call TimerStart(CreateTimer(),COOLDOWN,false,function Trig_Trompeta_Actions)
        call StartSound(gg_snd_TheHornOfCenarius)
    }

endscope