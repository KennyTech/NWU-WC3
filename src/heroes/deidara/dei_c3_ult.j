scope DeiC3Ult

    globals
        private constant integer SPELL_ID   = 'CW63' // Deidara - C3 Ult
        private constant integer FIRE_ID    = 'cw09' // FX C3 Fireground
        private constant integer DUMMY_ID1  = 'cw16' // FX Bird Drop C3 Ult 
        private constant integer BOOM_ID    = 'cw21' // FX Explosion 
        private constant integer AOE        = 400    // Boom AoE Size
        private constant integer DUMMY_ID2  = 'cw99' // For placing Clay Counter
        private constant integer SLOW_ID    = 'CW68' // For placing Clay Counter
        private constant string SFX         = "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl" // indicator
        private constant string SFX2        = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireTarget.mdl"
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function TreeFilter takes nothing returns boolean
        local integer d = GetDestructableTypeId(GetFilterDestructable()) // Filter all trees for killing
        return d=='LTlt' or d=='VTlt' or d=='ATtr' or d=='ATtc' or d=='BTtw' or d=='BTtc' or d=='ZTtw' or d=='ZTtc' or d=='FTtw'
    endfunction

    private function KillTree takes nothing returns nothing
        call KillDestructable(GetEnumDestructable())
    endfunction

    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit d = LoadUnitHandle(HT, id, 1) 
        local unit c = LoadUnitHandle(HT, id, 2)
        local effect fx = LoadEffectHandle(HT, id, 3)
        local real ticks = LoadReal(HT, id, 4) + 1
        local unit b
        local unit f
        local real x = GetUnitX(d) 
        local real y = GetUnitY(d)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local player p = GetOwningPlayer(c)
        local group g = CreateGroup()
        local unit u
        local rect r
        local boolexpr local_boolean
        local unit dummy
        
        call SaveReal(HT,id,4,ticks)
        
        if ticks == 3 then // remove indicator after .75 seconds
            call DestroyEffect(fx)
        endif
        
        if ticks == 8 then // boom after 2 seconds
        
            // Boom Visual
            set b = CreateUnit(GetOwningPlayer(c),BOOM_ID,x,y,0)
            call SetUnitAnimation(b,"death")
            call SetUnitTimeScale(b,0.15)
            call UnitApplyTimedLife(b,'BTLF',8)
            
            call ExplodeSFX(x,y)
            call TerrainDeformRipple(x,y,600,-75,500,1,2000/1800,1/4,975/1000,false)
            
            // Now we kill trees in range //
            set r = Rect(x-(AOE),y-(AOE),x+(AOE),y+(AOE)) 
            set local_boolean = Filter(function TreeFilter)
            call EnumDestructablesInRect(r,local_boolean, function KillTree) 
            call RemoveRect(r)
            call DestroyBoolExpr(local_boolean)
    
            // Damage
            call GroupEnumUnitsInRange(g,x,y,AOE,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                    call Damage_Spell(c,u,(150+100*level))
                    call DestroyEffect(AddSpecialEffect(SFX2,GetUnitX(u),GetUnitY(u))) 
                    
                    // Add Clay Counter
                    set dummy = CreateUnit(p, DUMMY_ID2, x, y, 0)
                    call UnitApplyTimedLife(dummy,'BTLF',0.5)
                    call UnitAddAbility(dummy, SLOW_ID)
                    call IssueTargetOrder(dummy, "slow", u)
                        
                elseif IsUnitType(u,UNIT_TYPE_STRUCTURE)==true and IsUnitType(u,UNIT_TYPE_DEAD)==false then
                    call Damage_Spell(c,u,(125+87.5*level))
                endif
                call GroupRemoveUnit(g, u)
            endloop
            
            set f = CreateUnit(GetOwningPlayer(c),FIRE_ID,x,y,0) // Visual
            call UnitApplyTimedLife(f,'BTLF',2.75)
        endif
        
        // DoT damage
        if ticks == 12 or ticks == 16 or ticks == 20 then 
            call GroupEnumUnitsInRange(g,x,y,AOE,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                    call Damage_Spell(c,u,(35+15*level))
                elseif IsUnitType(u,UNIT_TYPE_STRUCTURE)==true and IsUnitType(u,UNIT_TYPE_DEAD)==false then
                    call Damage_Spell(c,u,(30+12.5*level))
                endif
                call GroupRemoveUnit(g, u)
            endloop
        endif
        
        if ticks == 20 then
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
        endif
        
        set dummy = null
        set u = null
        set t = null
        set d = null
        set c = null
        set p = null
        set f = null
        set fx = null
        set b = null
        set g = null
        set r = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local unit c = GetTriggerUnit()
        local unit d
        local integer id = GetHandleId(t)
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local effect fx = AddSpecialEffect(SFX,x,y)
        
        set d = CreateUnit(GetOwningPlayer(c),DUMMY_ID1,x,y,0)
        call IssuePointOrderById(d,851984,x,y)
        call UnitApplyTimedLife(d,'BTLF',8)
        
        call SaveUnitHandle(HT, id, 1, d)
        call SaveUnitHandle(HT, id, 2, c)
        call SaveEffectHandle(HT, id, 3, fx)
        call SaveReal(HT, id, 4, 0)
        
        call TimerStart(t,.25,true,function TimerActions)
                
        set c = null
        set t = null
        set d = null
        set fx = null
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
