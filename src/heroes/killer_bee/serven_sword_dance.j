scope KBSSDance

    globals
        private constant integer SPELL_ID   = 'CW00'    // Ability ID of "Killer Bee - Seven Sword Dance"
        private constant integer SPELL_ID2  = 'CW01'    // Ability ID of "Killer Bee - Ink Creation Jutsu" // Needed to deal slow effect
        private constant integer ULT_ID     = 'CW03'    // Ability ID of "Killer Bee - 8-Tail Chakra" // Needed to apply bonus damage in ult form
        private constant integer SLOW_ID    = 'CW04'    // Ability ID of "Killer Bee - Dummy Ink Slow" // Needed to deal slow effect
        private constant integer AURA_ID    = 'CW07'    // Ability ID of "Killer Bee - 8-Tail Chakra Aura" // Movespeed Aura
        private constant integer DUMMY      = 'cw00'    // Unit ID of "FX Killer Bee" // Needed for afterimage dummy SX + dummy caster
        private constant integer DUMMY_ID2  = 'h01K'    // Unit ID of "FX Killer Bee" // Needed for afterimage dummy SX + dummy caster
        private constant integer BUFF_ID    = 'BK01'    // Buff ID of "Ink Creation" // Needed to deal slow effect
        private constant string sfx1 = "war3mapImported\\SevenSwordDance.mdx"   // Normal effect of this ability (SFX credits: Judash)
        private constant string sfx2 = "war3mapImported\\SevenSwordDance2.mdx"   // Ult effect of this ability (SFX credits: Judash)
        private constant hashtable HT = InitHashtable()        
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction

    private function DamageFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false
    endfunction
   
    private function Dash takes nothing returns nothing // Only in Ult Form
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1) // load caster
        local real cycle = LoadReal(HT, id, 2) // For dashing
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local item i
        local real angle = GetUnitFacing(c)
        local real x2 = x+100*Cos(angle*bj_DEGTORAD) // Don't let Bee exit map 
        local real y2 = y+100*Sin(angle*bj_DEGTORAD)
        
        set cycle = cycle + 1 // In ult form - move killer bee forward 
        if cycle <= 4 and RectContainsCoords(GetPlayableMapRect(),x2,y2)then // Don't let Bee exit map
            call SetUnitX(c,x+37.5*Cos(angle*bj_DEGTORAD)) // Move Killer Bee without disturbing order
            call SetUnitY(c,y+37.5*Sin(angle*bj_DEGTORAD)) // 150 distance forward 
        else
            set i = CreateItem('afac', x, y) // Random Item is created to detect nearest pathable area
            set x = GetItemX(i)
            set y = GetItemY(i)
            call RemoveItem(i)
            call SetUnitX(c, x) // Set Killer Bee's position to nearest pathable area without interrupting him
            call SetUnitY(c, y)
            set cycle = 0
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
        
        //call SaveUnitHandle(HT, id, 1, c)
        call SaveReal(HT, id, 2, cycle)
               
        set c = null
        set i = null
        set t = null
    endfunction
    
    private function Actions takes nothing returns nothing // Initial actions
        local group g = CreateGroup()
        local unit u
        local unit d // dummy (afterimage)
        local unit dummy // dummy caster (casts slow)
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local real a = GetUnitFacing(c)
        local real n = 0
        local real dmg
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local integer ult_level = 0
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)

        if GetUnitAbilityLevel(c, AURA_ID) > 0 then
            set ult_level = GetUnitAbilityLevel (c, ULT_ID)
            call SaveUnitHandle(HT, id, 1, c) // save Dummy(replacement Killer B)
            call SaveReal(HT, id, 2, 0) // save cycle as 0
            call TimerStart(t,0.03,true,function Dash) // Dash in ult form
        endif
        
        call TriggerSleepAction (0.10) 
        set x = GetUnitX(c)
        set y = GetUnitY(c)
        set d = CreateUnit(GetOwningPlayer(c),DUMMY,x,y,a) // create Killer B illusion dummy
        call Fade(d) // Fade effect for afterimage dummy
        call SetUnitTimeScale(d, 2.00) // Speed up Dummy animation speed
        call SetUnitVertexColor(c,255,255,255,0) // Make Killer B 100% transparent during this time (for SFX effect)

        if GetUnitAbilityLevel(c, AURA_ID) == 0 then // If in normal form, we play normal SX
            call DestroyEffect(AddSpecialEffect(sfx1,x,y)) // Create Sword SFX and Destroy It
            call SetUnitAnimationByIndex(c , 2 ) // normal attack animation - caster
            call SetUnitAnimationByIndex(d , 2 ) // dummy
        else
            call DestroyEffect(AddSpecialEffect(sfx2,x,y)) // Create Sword SFX and Destroy It    
            call SetUnitAnimationByIndex(c , 10 ) // alternate attack animation - caster
            call SetUnitAnimationByIndex(d , 10 ) // dummy
        endif
    
        call GroupEnumUnitsInRange(g,x,y,325,function DamageFilter) // Enumerate # of enemies to damage in 325 AoE
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u,GetOwningPlayer(c)) then
                set n = n + 1
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupEnumUnitsInRange(g,x,y,325,function DamageFilter)     // Damage in 325 AoE
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u,GetOwningPlayer(c)) then
            
                set dmg = (40+level*20) + (GetHeroAgi(c, true) * 2.0) // 60/80/100/120 + 200% AGI dmg 
                
                if GetUnitAbilityLevel(c, AURA_ID) > 0 and IsUnitIllusion(u) then   // If in ult form, remove 15/20/25% hp off clones
                    call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) - (GetUnitState(u, UNIT_STATE_MAX_LIFE) * (0.10+(0.05*ult_level))))
                endif
                
                if IsUnitType(u,UNIT_TYPE_STRUCTURE) then    // If target is structure, 50% damage
                    set dmg = dmg/2
                endif
                
                set dmg = dmg*(1.25-n*0.25) // 25% less dmg to all enemies per extra target in range
                
                if dmg <= 10+(level*10) + 5*GetUnitAbilityLevel(c, AURA_ID) then // This ability deals a minimum of 20/30/40/50 dmg +5 minimum dmg/lvl in ult form
                    set dmg = (10+(level*10)) + 5*GetUnitAbilityLevel(c, AURA_ID)
                endif
                
                call UnitDamageTarget(c,u,dmg, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS ) // Deals the physical hero damage
            endif

            if GetUnitAbilityLevel(u, BUFF_ID) > 0 then     // Slow enemy if it has ink debuff
                set dummy = CreateUnit(GetOwningPlayer(c), DUMMY_ID2, x, y, 0)
                call UnitApplyTimedLife(dummy,'BTLF',0.3)
                call UnitAddAbility(dummy, SLOW_ID)
                call SetUnitAbilityLevel(dummy, SLOW_ID, (GetUnitAbilityLevel(c, SPELL_ID2) + GetUnitAbilityLevel(c, AURA_ID))) // slow ability has 7 levels (duration boosted by Ult)
                call IssueTargetOrder(dummy, "slow", u)
            endif
            
            call GroupRemoveUnit(g,u)
        endloop
        
        call DestroyGroup(g)
        call TriggerSleepAction (0.20) 
        call SetUnitVertexColor(c,255,255,255,255) // Unfade Killer B
    
        if GetUnitAbilityLevel(c, AURA_ID) == 0 then 
            call SetUnitAnimationByIndex(c , 0 ) // Normal form - stand animation
        else 
            call SetUnitAnimationByIndex(c , 8 ) // Ult form - alternate stand animation
        endif
    
        set u = null
        set c = null
        set d = null
        set g = null
        set dummy = null
        set t = null
    endfunction
    
    //===========================================================================

    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null

        // Preload
        call AbilityPreload(SLOW_ID)
    endfunction

endscope