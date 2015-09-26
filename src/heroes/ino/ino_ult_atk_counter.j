scope InoUltAtkCounter

    globals
        private constant integer BUFF_ID        = 'BK15'   
        private constant integer CREEP_PLAYER_1 = 0 // Red = 0
        private constant integer CREEP_PLAYER_2 = 6 // Green = 6
    endglobals

    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetAttacker(), BUFF_ID) > 0 and IsUnitEnemy(GetAttacker(), GetOwningPlayer(GetTriggerUnit()))
    endfunction

    private function Actions takes nothing returns nothing
        local unit u = GetAttacker()
        local integer n = GetUnitUserData(u)
        local string s = I2S(n)
        
        call SetUnitUserData(u, n+1)
        if SubString(s, 1, 2) == "4" or SubString(s, 2, 3) == "4" then
            if IsUnitEnemy(u,Player(1)) then
                call SetUnitOwner(u,Player(CREEP_PLAYER_1),true)
            else
                call SetUnitOwner(u,Player(CREEP_PLAYER_2),true)
            endif
            call UnitDamageTarget(InoUltCaster[(n/10)-1],u,3000, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        
        set u = null
    endfunction

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ATTACKED)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope