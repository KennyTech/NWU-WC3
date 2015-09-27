scope KarinLFC

    globals
        private constant integer SPELL_ID = 'CW14'    // Ability ID of "Karin - Life Force" 
        private constant string EFFECT    = "Objects\\Spawnmodels\\Human\\HumanBlood\\HeroBloodElfBlood.mdl"
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function DamageFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false
    endfunction
    
    private function TimerActions takes nothing returns nothing // Periodic healing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local group g = CreateGroup()
        local unit u
        local real x
        local real y
        local real manaPercent
        local real lifePercent
        local integer i = LoadInteger(HT, id, 1)
        local integer level = LoadInteger(HT, id, 2)
        local integer n = 0
        
        set LF_Karin_Timer[i] = GetExpiredTimer()
        set x = GetUnitX(LF_Karin[i])
        set y = GetUnitY(LF_Karin[i])
        set manaPercent = ( GetUnitState(LF_Karin[i], UNIT_STATE_MANA) / GetUnitState(LF_Karin[i], UNIT_STATE_MAX_MANA) ) * 100
        set lifePercent = ( GetUnitState(LF_Karin[i], UNIT_STATE_LIFE) / GetUnitState(LF_Karin[i], UNIT_STATE_MAX_LIFE) ) * 100
        
        call GroupEnumUnitsInRange(g,x,y,25+125*level,function DamageFilter) // Enumerate # of allies to heal in 150/275/400 AoE
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitAlly(u,GetOwningPlayer(LF_Karin[i])) and IsUnitType(u, UNIT_TYPE_HERO) == true then
                if GetUnitState(u, UNIT_STATE_LIFE) < GetUnitState(u, UNIT_STATE_MAX_LIFE) and IsUnit(u, LF_Karin[i]) == false then
                set n = n + 1
                endif
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        // call DisplayTextToForce( GetPlayersAll(), "n = " + R2S(n) )
        
        if n == 0 and manaPercent > 5 then // If no allied heroes in range and over 5% mana, heal self at the cost of mana
            call SetUnitState(LF_Karin[i], UNIT_STATE_LIFE, GetUnitState(LF_Karin[i], UNIT_STATE_LIFE) + 10*level + GetUnitState(LF_Karin[i], UNIT_STATE_MAX_LIFE) * 0.005+0.005*level ) // Heal Karin for 10/20/30 + 1/1.5/2% per 0.5s tick
            call SetUnitState(LF_Karin[i], UNIT_STATE_MANA, GetUnitState(LF_Karin[i], UNIT_STATE_MANA) - GetUnitState(LF_Karin[i], UNIT_STATE_MAX_MANA) * 0.025 ) // Deplete her mana by 2.5% per 0.5s tick

        elseif n > 0 and lifePercent > 3 + (2*n) then // If allied heroes in range, heal them at cost of Karin's life            
            call SetUnitState(LF_Karin[i], UNIT_STATE_LIFE, GetUnitState(LF_Karin[i], UNIT_STATE_LIFE) - GetUnitState(LF_Karin[i], UNIT_STATE_MAX_LIFE) * (0.01+0.01*n) ) // Decrease Karin's health by 2% per tick (+1% per extra hero)
            call DestroyEffect(AddSpecialEffect (EFFECT, x, y))
            
            call GroupEnumUnitsInRange(g,x,y,25+125*level,function DamageFilter) // Enumerate allies to heal in 150/275/400 AoE
            loop
            set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitAlly(u, GetOwningPlayer(LF_Karin[i])) and IsUnit(u, LF_Karin[i]) == false and IsUnitType(u, UNIT_TYPE_HERO) == true then // Heal allied heroes 
                    call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) + 10*level + GetUnitState(u, UNIT_STATE_MAX_LIFE) * 0.005+0.005*level ) // 10/20/30 hp + 1/1.5/2% max hp per 0.5s tick heal
                endif                
                call GroupRemoveUnit(g,u)
            endloop
        else 
            call IssueImmediateOrder(LF_Karin[i], "stop")
            call PauseTimer(LF_Karin_Timer[i])
            call DestroyTimer(LF_Karin_Timer[i])
            call FlushChildHashtable(HT, id)
            set n = 0
        endif
    
        set n = 0
        set g = null
        set u = null
        set t = null
    endfunction
    
    private function Actions takes nothing returns nothing // Actions upon start of channeling 
        local integer i = GetPlayerId(GetTriggerPlayer())
        local integer id
        
        set LF_Karin[i] = GetTriggerUnit()
        set LF_Karin_Timer[i] = CreateTimer()
        
        set id = GetHandleId(LF_Karin_Timer[i])
        
        call SaveInteger(HT, id, 1, i) // saving player number
        call SaveInteger(HT, id, 2, GetUnitAbilityLevel(LF_Karin[i], SPELL_ID)) // saving ability level
        
        call TimerStart(LF_Karin_Timer[i], 0.5, true, function TimerActions)
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope