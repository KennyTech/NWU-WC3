scope InoFlowerBomb

    globals
        private constant integer SPELL_ID   = 'CH00' 
        private constant integer ACID_ID    = 'CW77'
        private constant integer BOMB_ID    = 'cw22'
        private constant integer BOMB_ID2   = 'cw23'
        private constant integer TARG_ID    = 'cw25' // To throw Acid Bomb at (enemy)
        private constant real MISSILE_SPEED = 700
        private constant real KNOCKBACK_SPEED = 600
        private constant real BOOM_AOE      = 350
        private constant real STUN_AOE      = 128
        private constant string SFX         = "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl"
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function Parabola takes real dist, real maxdist returns real
        local real t = (dist*2)/maxdist-1
        return (-t*t+1)*(maxdist/0.9)
    endfunction
    
    private function InoKnockbackTimer takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u = LoadUnitHandle(HT, id, 1)
        local real dist = LoadReal(HT, id, 2)
        local real angle = LoadReal(HT, id, 3)
        local real distmax = 240
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local unit temp_u
        local real height
        local location L
        local item i
            
        if UnitAddAbility(u, 'Arav') then 
            call UnitRemoveAbility(u, 'Arav') // crow form
        endif
        
        if dist + 50 < distmax then
            set dist = dist + KNOCKBACK_SPEED/32 
        elseif dist < distmax then
            set dist = dist + KNOCKBACK_SPEED/64
        endif
        
        set L = GetUnitLoc(u)
        set height = GetLocationZ(L) 
        
        if height < 0 then
            set height = (0-height)+Parabola(dist,distmax)
        elseif height > 0 then
            if 0+Parabola(dist,distmax)<=height then
                set height = 0
            else
                set height = Parabola(dist,distmax)-(height-0)
            endif
        else
            set height = Parabola(dist,distmax)
        endif
        
        call RemoveLocation(L)            
        call SetUnitFlyHeight(u, height,0) // Parabola
    
        if dist + 50 < distmax then
            call SetUnitX(u, x+(KNOCKBACK_SPEED/32)*Cos(angle*bj_DEGTORAD))
            call SetUnitY(u, y+(KNOCKBACK_SPEED/32)*Sin(angle*bj_DEGTORAD))
        elseif dist < distmax then
            call SetUnitX(u, x+(KNOCKBACK_SPEED/64)*Cos(angle*bj_DEGTORAD))
            call SetUnitY(u, y+(KNOCKBACK_SPEED/64)*Sin(angle*bj_DEGTORAD))
        else
            // Unstuck
            set i = CreateItem('afac', x, y) // Random Item is created to detect nearest pathable area
            set x = GetItemX(i)
            set y = GetItemY(i)
            call RemoveItem(i)
            call SetUnitX(u, x) // Move all to nearest pathable area
            call SetUnitY(u, y) // Move all to nearest pathable area
            
            call FlushChildHashtable(HT, id)
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
        
        call SaveReal(HT, id, 2, dist)
        
        set t = null
        set u = null
        set temp_u = null
        set L = null
        set i = null
    endfunction
    
    private function InoKnockback takes unit u, real angle returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        call FlushChildHashtable(HT, id)
        call SaveUnitHandle(HT, id, 1, u)
        call SaveReal(HT, id, 2, 0)
        call SaveReal(HT, id, 3, angle)
        call TimerStart(t, 0.03125, true, function InoKnockbackTimer)
        set t = null
    endfunction
    
    private function Explode takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit bomb = LoadUnitHandle(HT, id, 1)
        local integer level = LoadInteger(HT, id, 2)  
        local unit c = LoadUnitHandle(HT, id, 3)
        local real x = GetUnitX(bomb)
        local real y = GetUnitY(bomb)
        local real x2 
        local real y2
        local unit dummy
        local player p = GetOwningPlayer(bomb)
        local group g = CreateGroup()
        local unit u
        local real angle
        
        if IsUnitType(bomb, UNIT_TYPE_DEAD) == false then
            call RemoveUnit(bomb)
            
            //call KillUnit(bomb)
            call DestroyEffect(AddSpecialEffect(SFX,x,y))
            call DestroyEffect(AddSpecialEffect(SFX,x+150,y+150))
            call DestroyEffect(AddSpecialEffect(SFX,x+150,y-150))
            call DestroyEffect(AddSpecialEffect(SFX,x-150,y+150))
            call DestroyEffect(AddSpecialEffect(SFX,x-150,y-150))
            
            // Boom Damage and Knockback
            call GroupEnumUnitsInRange(g,x,y,BOOM_AOE,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                set x2 = GetUnitX(u)
                set y2 = GetUnitY(u)
                set angle = bj_RADTODEG*Atan2(y-y2,x-x2) + 180
                if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false then                
                    call UnitDamageTarget(c,u,(40+40*level), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                    call InoKnockback(u, angle)
                    //call DisplayTextToForce(GetPlayersAll(), "kb enemy")
                endif
                if IsUnitAlly(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false then             
                    call InoKnockback(u, angle)
                    //call DisplayTextToForce(GetPlayersAll(), "kb ally")
                endif
                call GroupRemoveUnit(g,u)
            endloop
            
            set u = CreateUnit(Player(12),TARG_ID,x,y,0) // neutral-hostile Target for Acid Bomb
            set dummy = CreateUnit(p,'cw99',x,y,0) // Acid bomb caster
            call UnitApplyTimedLife(u,'BTLF',0.2)
            call UnitAddAbility(dummy, ACID_ID)
            call SetUnitAbilityLevel(dummy, ACID_ID, level)
            call IssueTargetOrder(dummy, "acidbomb", u)
            call RemoveUnit(u)
            
        endif
     
        call FlushChildHashtable(HT, id)
        call PauseTimer(t)
        call DestroyTimer(t)
        
        set p = null
        set u = null
        set g = null
        set dummy = null
        set bomb = null
        set c = null
        set t = null
    endfunction

    private function TimerActions takes nothing returns nothing
        local timer explode_timer = CreateTimer()
        local integer explode_id = GetHandleId(explode_timer)
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit bomb = LoadUnitHandle(HT, id, 1)
        local unit c = LoadUnitHandle(HT, id, 2)
        local real distmax = LoadReal(HT, id, 3)
        local real angle = LoadReal(HT, id, 4)
        local integer level = LoadInteger(HT, id, 5)
        local real dist = LoadReal(HT, id, 6)
        local real x = GetUnitX(bomb)
        local real y = GetUnitY(bomb)
        local unit temp_u
        local real height
        local location L
        local group g = CreateGroup()
        local unit u
    
        if dist + 50 < distmax then
            set dist = dist + MISSILE_SPEED/32 
        elseif dist < distmax then
            set dist = dist + MISSILE_SPEED/128 
        endif
        
        set L = GetUnitLoc(bomb)
        set height = GetLocationZ(L) 
        
        if height < 0 then
            set height = (0-height)+Parabola(dist,distmax)
        elseif height > 0 then
            if 0+Parabola(dist,distmax)<=height then
                set height = 0
            else
                set height = Parabola(dist,distmax)-(height-0)
            endif
        else
            set height = Parabola(dist,distmax)
        endif
        
        call RemoveLocation(L)            
        call SetUnitFlyHeight(bomb, height,0) // Parabola
    
        if dist + 50 < distmax then
            call SetUnitPosition(bomb, x+(MISSILE_SPEED/32)*Cos(angle*bj_DEGTORAD), y+(MISSILE_SPEED/32)*Sin(angle*bj_DEGTORAD))
        elseif dist < distmax then
            call SetUnitPosition(bomb, x+(MISSILE_SPEED/128)*Cos(angle*bj_DEGTORAD), y+(MISSILE_SPEED/128)*Sin(angle*bj_DEGTORAD))
        else
            //set temp_u = CreateUnit(GetOwningPlayer(c), BAR_ID, x, y, 0)
            //call UnitApplyTimedLife(temp_u,'BTLF',1.6)
            //call SetUnitTimeScale(temp_u, .75)
            
            call GroupEnumUnitsInRange(g,x,y,STUN_AOE,null)
            loop
                set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,GetOwningPlayer(c)) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false then                
                    call AddStunTimed(u, 2.0)
                endif
                call GroupRemoveUnit(g,u)
            endloop
            
            set temp_u = CreateUnit(GetOwningPlayer(c),BOMB_ID2,x,y,angle)
            call UnitApplyTimedLife(temp_u,'BTLF',1.3)
            call SetUnitScale(temp_u,1.3+0.3*level,1.3+0.3*level,1.3+0.3*level)
            call SetUnitState(temp_u, UNIT_STATE_LIFE, 1)
            
            call SaveUnitHandle(HT, explode_id, 1, temp_u)
            call SaveInteger(HT, explode_id, 2, level)
            call SaveUnitHandle(HT, explode_id, 3, c)
            
            call TimerStart(explode_timer,1.2,false,function Explode)
            
            call RemoveUnit(bomb)
            
            // Start Timer Here
            
            call FlushChildHashtable(HT, id)
            call PauseTimer(t)
            call DestroyTimer(t)
            //
        endif
        
        call SaveReal(HT, id, 6, dist) 
    
        set u = null
        set g = null
        set t = null
        set c = null
        set temp_u = null
        set L = null
        set bomb = null
        set explode_timer = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local unit c = GetTriggerUnit()
        local unit bomb
        local integer n = GetPlayerId(GetOwningPlayer(c))
        local integer id = GetHandleId(t)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local real x_cast = GetUnitX(c) 
        local real y_cast = GetUnitY(c) 
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local real angle = bj_RADTODEG*Atan2(y-y_cast,x-x_cast)
        local real dist = (SquareRoot((x-x_cast)*(x-x_cast)+(y-y_cast)*(y-y_cast)))
        
        //call DisplayTextToForce(GetPlayersAll(), "id: " + I2S(id))
        
        set bomb = CreateUnit(GetOwningPlayer(c),BOMB_ID,x_cast,y_cast,angle)
        
        call SetUnitScale(bomb,1.3+0.3*level,1.3+0.3*level,1.3+0.3*level)
        
        call FlushChildHashtable(HT, id) // for precaution
        call SaveUnitHandle(HT, id, 1, bomb)
        call SaveUnitHandle(HT, id, 2, c)
        call SaveReal(HT, id, 3, dist)
        call SaveReal(HT, id, 4, angle)
        call SaveInteger(HT, id, 5, level)
        call SaveReal(HT, id, 6, 0)
        call TimerStart(t,0.03125,true,function TimerActions)
                
        set c = null
        set t = null
        set bomb = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        debug call Test_Success(SCOPE_PREFIX + " initialized")
        set t = null
    endfunction

endscope
