scope DeiClaySpider

    globals
        private constant integer SPELL_ID   = 'CW60' 
        private constant integer DUMMY_ID1  = 'cw08' // FX Dei Clay Spider
        private constant integer DUMMY_ID2  = 'cw99'
        private constant integer ILL_ID     = 'cw17' // Illusion ID (to simulate Dei moving while casting)
        private constant integer SLOW_ID    = 'CW68'
        private constant string SFX         = "Abilities\\Weapons\\FragDriller\\FragDriller.mdl"
        private constant real MISSILE_SPEED = 1000
        private constant real DISTANCE      = 650
        private constant real DMG_AOE       = 175
        private constant real DETECT_AOE    = 120 // Should be lower than DMG_AOE
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction

    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit missile = LoadUnitHandle(HT, id, 1) 
        local unit c = LoadUnitHandle(HT, id, 2)
        local real distance = LoadReal(HT, id, 3) - (MISSILE_SPEED/32)
        local real angle = LoadReal(HT, id, 4)
        local real explode_ready = LoadReal(HT, id , 5)
        local unit illusion = LoadUnitHandle(HT, id, 6)
        local real x = GetUnitX(missile) 
        local real y = GetUnitY(missile)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local unit u
        local group g = CreateGroup()
        local real n = 0
        local player p = GetOwningPlayer(c)
        local unit dummy 
        
        call SaveReal(HT, id, 3, distance)
        
        // Move illusion SFX
        if illusion != null then
            call SetUnitX(illusion, GetUnitX(c))
            call SetUnitY(illusion, GetUnitY(c))
        endif
        
        if distance > 0 then
            call SetUnitX(missile, x+(MISSILE_SPEED/32)*Cos(angle*bj_DEGTORAD))
            call SetUnitY(missile, y+(MISSILE_SPEED/32)*Sin(angle*bj_DEGTORAD))
            
            call GroupEnumUnitsInRange(g,x,y,DETECT_AOE,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,p) and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                    set n = n + 1
                endif
                call GroupRemoveUnit(g, u)
            endloop
            
            if n > 0 then
                call SaveReal(HT, id, 5, explode_ready + 1) // Delay the explosion by 4 ticks after discovering an enemy so it can get closer
            endif
            
            if n > 0 and explode_ready >= 4 then
                call DestroyEffect(AddSpecialEffect(SFX,x,y))
                call RemoveUnit(missile)
                
                call GroupEnumUnitsInRange(g,x,y,DMG_AOE,null)
                loop
                    set u = FirstOfGroup(g)
                exitwhen u == null
                    if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_DEAD)==false and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false then  
                        call Damage_Spell(c,u,(30+40*level))
                    
                        // Add Clay Counter
                        set dummy = CreateUnit(p, DUMMY_ID2, x, y, 0)
                        call UnitApplyTimedLife(dummy,'BTLF',0.5)
                        call UnitAddAbility(dummy, SLOW_ID)
                        call IssueTargetOrder(dummy, "slow", u)
                        
                    //elseif IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==true and IsUnitType(u,UNIT_TYPE_DEAD)==false then
                    //    call Damage_Spell(c,u,(15+15*level))
                                    
                    endif
                    call GroupRemoveUnit(g, u)
                endloop
                
                call PauseTimer(t)
                call DestroyTimer(t)
                call FlushChildHashtable(HT, id)
                
            endif
        else
            call DestroyEffect(AddSpecialEffect(SFX,x,y))
            call RemoveUnit(missile)
            
            call GroupEnumUnitsInRange(g,x,y,DMG_AOE,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                    call Damage_Spell(c,u,(30+40*level))
                
                    // Add Clay Counter
                    set dummy = CreateUnit(p, DUMMY_ID2, x, y, 0)
                    call UnitApplyTimedLife(dummy,'BTLF',0.5)
                    call UnitAddAbility(dummy, SLOW_ID)
                    call IssueTargetOrder(dummy, "slow", u)
            
                endif
                call GroupRemoveUnit(g, u)
            endloop
            
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
        endif
        
        set u = null
        set g = null
        set c = null
        set missile = null
        set t = null
        set p = null
        set dummy = null
        set illusion = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local unit c = GetTriggerUnit()
        local unit missile
        local integer id = GetHandleId(t)
        local real x = GetUnitX(c) 
        local real y = GetUnitY(c) 
        local real x2 = GetSpellTargetX()
        local real y2 = GetSpellTargetY()
        local real angle = bj_RADTODEG*Atan2(y2-y,x2-x)
        local unit illusion
        
        set missile = CreateUnit(GetOwningPlayer(c),DUMMY_ID1,x,y,angle)
        set illusion = CreateUnit(GetOwningPlayer(c), ILL_ID, x, y, angle) // spawn illusion Dei
        call SetUnitTimeScale(illusion, 2.5)
        call SetUnitAnimation(illusion, "attack")
        
        call SaveUnitHandle(HT, id, 1, missile)
        call SaveUnitHandle(HT, id, 2, c)
        call SaveReal(HT, id, 3, DISTANCE)
        call SaveReal(HT, id, 4, angle)
        call SaveUnitHandle(HT, id, 6, illusion)
        
        call TimerStart(t,0.03125,true,function TimerActions)
        
        call SetUnitVertexColor(c,255,255,255,0)
        call TriggerSleepAction(0.2)
        call SetUnitVertexColor(c,255,255,255,255)
        call RemoveUnit(illusion)
                
        set c = null
        set t = null
        set missile = null
        set illusion = null
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
