scope HanSteamWallOn

    globals
        private constant integer SPELL_ID   = 'CW46' 
        private constant integer ID_CANCEL  = 'CW47'
        private constant integer DUMMY      = 'cw07' // ID of unit: FX Han Dash
        private constant integer BLOCKER_ID = 'CWd1'
        private constant string SFX1        = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireTarget.mdl"
        private constant string SFX2        = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
        private constant string SOUND       = "Abilities\\Spells\\Orc\\Shockwave\\Shockwave.wav"
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function Removal takes nothing returns nothing
        if GetDestructableTypeId(GetEnumDestructable()) == BLOCKER_ID then // CWd1 = Han's Steam Pathing Blocker
            call RemoveDestructable(GetEnumDestructable())
        endif
    endfunction
    
    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1) // load caster
        local integer level = LoadInteger(HT, id, 2) 
        local integer n = LoadInteger(HT, id, 3) - 1 // remaining # of loops (duration)
        local real x2 = LoadReal(HT, id, 4)
        local real y2 = LoadReal(HT, id, 5)
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local real total_ticks = 2+level*2
        local player p = GetOwningPlayer(c)
        local unit u 
        local group g = CreateGroup()
        local rect r = Rect(x2+500,y2+500,x2-500,y2-500)
        
        call SaveInteger(HT, id, 3, n)
        
        if n > 0 then
            call GroupEnumUnitsInRange(g,x2,y2,350,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                    call Damage_Spell(c,u,(30+30*level)/total_ticks)
                    call DestroyEffect(AddSpecialEffect(SFX1,GetUnitX(u),GetUnitY(u))) 
                endif
                call GroupRemoveUnit(g, u)
            endloop
        else
            call EnumDestructablesInRect(r, null, function Removal)
            call SetPlayerAbilityAvailable(p,SPELL_ID, true)
            call UnitRemoveInmunity(c)
            call UnitRemoveAbility(c, ID_CANCEL)
            call FlushChildHashtable(HT,id)
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
    
        set t = null
        set c = null
        set g = null
        set u = null
        set g = null
        set r = null
    endfunction
    
    private function DashKick takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local timer t2 = CreateTimer()
        local integer id = GetHandleId(t)
        local integer id2 = GetHandleId(t2)
        local integer loops = 0 // loop create steam blockers in circle
        local unit c = LoadUnitHandle(HT, id, 1) // load caster
        local item i // To move Han to nearest pathable area later
        local real cast_angle = LoadReal(HT, id, 2) 
        local real distance = LoadReal(HT, id, 3)
        local real ticks = LoadReal(HT, id, 4) + 1 // count cycles for jump effect
        local integer level = LoadInteger(HT, id, 5) 
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local real angle = 0
        local unit dummy
        local unit sfx_dummy
        
        local player p = GetOwningPlayer(c)
        local unit u 
        local group g = CreateGroup()
        
        call SaveReal(HT, id, 4, ticks)
    
        if ticks == 4 then
            call UnitAddInmunity(c)
        endif
        
        if ticks == 9 then // play Han Dash effect (delayed effect - syncs with 16 ticks)
            set dummy = CreateUnit(GetOwningPlayer(c), DUMMY, x, y, cast_angle)
            call UnitApplyTimedLife(dummy,'BTLF',1.0)
        endif
        
        if ticks == 16 then // start height change & kick at 0.5 seconds
            call SetUnitFlyHeight(c, 0, 1650/(1+distance*0.002))
        endif
        
        if distance >= 0 then 
            if ticks > 16 then
                call SaveReal(HT, id, 3, distance - 40) // Move Han Forward after 0.5 sec
                call SetUnitPosition(c, x+40*Cos(cast_angle*bj_DEGTORAD), y+40*Sin(cast_angle*bj_DEGTORAD))
            else
                call SaveReal(HT, id, 3, distance + 4) // Move Han Backward for first 0.5 sec
                call SetUnitPosition(c, x+4*Cos((180+cast_angle)*bj_DEGTORAD), y+4*Sin((180+cast_angle)*bj_DEGTORAD))
            endif
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),SPELL_ID, false)
            call UnitAddAbility(c, ID_CANCEL)
        
            // Create pathing blockers
            loop 
            exitwhen(loops==20)
                call CreateDestructable(BLOCKER_ID,x+(330)*Cos(angle),y+(330)*Sin(angle),0,1,0)
                set angle=angle+((360/20)*bj_DEGTORAD)
                set loops=loops+1
            endloop
            
            // Random Item is created to detect nearest pathable area and move Han to it
            set i = CreateItem('afac', x, y) 
            set x = GetItemX(i)
            set y = GetItemY(i)
            call RemoveItem(i)
            call SetUnitX(c, x)
            call SetUnitY(c, y)
            
            // Deal 1/4 the damage instantly first, other 3/4 in damage over time later
            call GroupEnumUnitsInRange(g,x,y,350,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                    call Damage_Spell(c,u,(10+10*level))
                    call DestroyEffect(AddSpecialEffect(SFX1,GetUnitX(u),GetUnitY(u))) 
                endif
                call GroupRemoveUnit(g, u)
            endloop
            
            call ExplodeSFX(x,y)
            call DestroyEffect(AddSpecialEffect(SFX2,x,y)) 
            
            // Create steam effect in middle of circle on impact
            set sfx_dummy = CreateUnit(p, 'cw05', x, y, GetRandomReal(0,360))
            call UnitApplyTimedLife(sfx_dummy,'BTLF',level)
            call SetUnitScale(sfx_dummy, 2.5,2.5,2.5)
            set SteamWallX[GetPlayerId(GetTriggerPlayer())] = x
            set SteamWallY[GetPlayerId(GetTriggerPlayer())] = y
            
            // Save to Hashtable for Timer 2 (0.5s damage loop)
            call SaveUnitHandle(HT, id2, 1, c) // for damage source later
            call SaveInteger(HT, id2, 2, level) // for damage later
            call SaveInteger(HT, id2, 3, 3+level*2) // 2/3/4/5 seconds duration
            call SaveReal(HT, id2, 4, x)
            call SaveReal(HT, id2, 5, y)
        
            // Start 0.5s damage loop and trap duration
            call TimerStart(t2,.5,true,function TimerActions) // Start the damage over time and ticks
            call SetUnitPathing(c, true )
            call FlushChildHashtable(HT,id)
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
        
        // Cancel if Han dies mid-air
        if IsUnitType(c, UNIT_TYPE_DEAD) == true then
            call SetUnitPathing(c, true )
            call UnitRemoveInmunity(c)
            call FlushChildHashtable(HT,id)
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
        
        set i = null
        set t = null
        set t2 = null
        set c = null
        set dummy = null
        set sfx_dummy = null
        set g = null
        set u = null
        set p = null
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local real x2 = GetUnitX(c)
        local real y2 = GetUnitY(c)
        local real cast_angle = bj_RADTODEG*Atan2(y-y2,x-x2)
        local real distance = 0
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local integer level = GetUnitAbilityLevel(c,SPELL_ID)
        local integer loops = 0
        
        // Preparation + Begin of Spell
        if UnitAddAbility(c, 'Arav') then 
            call UnitRemoveAbility(c, 'Arav') // crow form
        endif
        call SetUnitFlyHeight(c, 300, 1200)
        call SetUnitPathing( c, false )
        set distance = (SquareRoot((x2-x)*(x2-x)+(y2-y)*(y2-y)))
        
        // Save to Hashtable for Timer (Han leap loop)
        call SaveUnitHandle(HT, id, 1, c) // save Han
        call SaveReal(HT, id, 2, cast_angle) // save cast angle
        call SaveReal(HT, id, 3, distance) // save distance
        call SaveInteger(HT, id, 5, level) // save level
        
        call TimerStart(t,0.03125,true,function DashKick) // Start Han's Jump

        set c = null
        set t = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        set t = null
    endfunction

endscope
