scope KarinIdBounty

    private function Conditions takes nothing returns boolean
        local integer i = 0
        loop
            exitwhen i > 12
            if IsUnitInGroup(GetDyingUnit(), KarinIDGroup[i]) then
                return true
            endif
            set i = i + 1
        endloop
        return false
    endfunction
    
    private function Actions takes nothing returns nothing // Actions upon death (bounty)
        local unit u = GetDyingUnit()
        local integer gold 
        local texttag tt = CreateTextTag()
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local player p = GetOwningPlayer(GetKillingUnit())
        local integer i = 0
        
        loop
            exitwhen i > 12
    
            if IsUnitInGroup(u, KarinIDGroup[i]) then
            
                set gold = GetHeroLevel(Karin[i]) // Gold based on Karin's level
                
                if IsUnitType(u, UNIT_TYPE_HERO) == true then
                    set gold = gold*6
                endif
                
                call SetTextTagText(tt,"+" + I2S(gold),.024)
                call SetTextTagPos(tt,x-16.,y+20,.0)
                call SetTextTagColor(tt,255,220,0,255)
                call SetTextTagVelocity(tt,.0,.03)
                call SetTextTagFadepoint(tt,2.)
                call SetTextTagLifespan(tt,3.)
                call SetTextTagPermanent(tt,false)
                    
                call GroupRemoveUnit(KarinIDGroup[i], u)
               
                // If Karin or her ally kills, give gold
                if IsPlayerAlly(p, GetOwningPlayer(Karin[i])) then 
                    call AdjustPlayerStateBJ(gold, p, PLAYER_STATE_RESOURCE_GOLD )
                    call SetTextTagVisibility(tt,GetLocalPlayer()==p)
                endif 
                
                // If killer isn't Karin and creep was not denied, give gold to Karin
                if p != GetOwningPlayer(Karin[i]) and IsPlayerAlly(p, GetOwningPlayer(Karin[i])) then 
                    call AdjustPlayerStateBJ(gold, GetOwningPlayer(Karin[i]), PLAYER_STATE_RESOURCE_GOLD )
                    call SetTextTagVisibility(tt,GetLocalPlayer()==GetOwningPlayer(Karin[i]))
                endif
                
            endif
            
            set i = i + 1
        endloop
        
        set u = null
        set tt = null
        set p = null
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
        debug Test_Success(SCOPE_PREFIX + " loaded")
    endfunction

endscope
