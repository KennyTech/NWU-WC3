scope KarinIdentify // REVAMP WORK IN PROGRESS -non-functional atm!

    globals
        private constant integer SPELL_ID2    = 'CW17'    // Ability ID of "Karin - Identify Aura" 
        private constant integer SPELL_ID3    = 'CW16'    // Ability ID of "Identify Armor Reduce (Karin)"  
    endglobals

    private function EnemyFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE) == false
    endfunction

    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u
        
        loop
            set u = FirstOfGroup(KarinIDGroup)
        exitwhen u == null
            call GroupRemoveUnit(KarinIDGroup, u)
            call DisplayTextToForce( GetPlayersAll(), GetUnitName(u) + " <-- flushing this unit")
            call UnitRemoveAbility(u, SPELL_ID2)
            call UnitRemoveAbility(u, SPELL_ID3)
        endloop
        
        call ReleaseTimer(t)
        
        set t = null
        set u = null
    endfunction
    
    private function OnSpell takes nothing returns nothing 
        local group g = CreateGroup()
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local unit c = GetTriggerUnit()
        local unit u
        local timer t = NewTimer()
        local integer id = GetHandleId(t)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local group idGroup = CreateGroup()
        
        set HeroKarin = c
        
        call GroupEnumUnitsInRange(ENUM,x,y,250+level*25,function EnemyFilter) // Enumerate enemies to identify
        loop
            set u = FirstOfGroup(ENUM)
        exitwhen u == null
            if IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitIllusion(u) == false and GetUnitDefaultMoveSpeed(u) >= 150 then // Enemy, not clone, not ward
                call GroupAddUnit(KarinIDGroup, u) // For Bounty Death later
                call DisplayTextToForce( GetPlayersAll(), GetUnitName(u) + " <-- added unit to bounty creep")
                call UnitAddAbility(u, SPELL_ID2)
                call UnitAddAbility(u, SPELL_ID3)
            endif
            call GroupRemoveUnit(ENUM,u)
        endloop
        
        call TimerStart(t, 10, false, function TimerActions)
        
        set c = null
        set u = null
        set t = null
    endfunction
    
    private function OnDeath takes nothing returns nothing 
        local unit u = GetDyingUnit()
        local integer gold 
        local texttag tt = CreateTextTag()
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local player p = GetOwningPlayer(GetKillingUnit())
        
        if IsUnitInGroup(GetDyingUnit(), KarinIDGroup) then
            
            set gold = GetHeroLevel(HeroKarin) // Gold based on Karin's level
                
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
                
            call GroupRemoveUnit(KarinIDGroup, u)
           
            // If Karin or her ally kills, give gold
            if IsPlayerAlly(p, GetOwningPlayer(HeroKarin)) then 
                call AdjustPlayerStateBJ(gold, p, PLAYER_STATE_RESOURCE_GOLD )
                call SetTextTagVisibility(tt,GetLocalPlayer()==p)
            endif 
            
            // If killer isn't Karin and creep was not denied, give gold to Karin
            if p != GetOwningPlayer(HeroKarin) and IsPlayerAlly(p, GetOwningPlayer(HeroKarin)) then 
                call AdjustPlayerStateBJ(gold, GetOwningPlayer(HeroKarin), PLAYER_STATE_RESOURCE_GOLD )
                call SetTextTagVisibility(tt,GetLocalPlayer()==GetOwningPlayer(HeroKarin)
            endif
        
    endfunction

//===========================================================================

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('CW09',function onSpell)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DEATH, function onDeath)
    endfunction

endscope
