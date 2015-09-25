scope DeiMineThrow

    globals
        private constant integer SPELL_ID   = 'CW61' 
        private constant integer MINE_ID    = 'cw10'
        private constant real MISSILE_SPEED = 800
        private constant real DIST_APART    = 177   // sqrt(2(177*177)) = actually 250 dist apart
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function Parabola takes real dist, real maxdist returns real
        local real t = (dist*2)/maxdist-1
        return (-t*t+1)*(maxdist/1.5)
    endfunction

    private function TimerActions takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local integer mine
        local unit c = LoadUnitHandle(HT, id, 7)
        local integer level = LoadInteger(HT, id, 26)
        local unit array mine_unit
        local real array distmax
        local real array dist
        local real array angle
        local boolean array local_booleans
        local real x
        local real y
        local unit temp_u
        local real height
        local location L
        local integer n = 0
        local integer n2 = GetPlayerId(GetOwningPlayer(c))
        
        if level == 1 then 
            set mine = 'cw11'
        elseif level == 2 then
            set mine = 'cw12'
        elseif level == 3 then
            set mine = 'cw13'
        elseif level == 4 then
            set mine = 'cw14'
        endif
    
        loop
        exitwhen(n==6)
            set n = n+1
            set mine_unit[n] = LoadUnitHandle(HT, id, n) // 1-6
            set distmax[n] = LoadReal(HT, id, n+7) // 8-13
            set angle[n] = LoadReal(HT, id, n+13) // 14-19
            set local_booleans[n] = LoadBoolean(HT, id, n+19) // 20-25
            set dist[n] = LoadReal(HT, id, n+26) // 27-32
            
            if dist[n] + 50 < distmax[n] and local_booleans[n] == false then
                set dist[n] = dist[n] + MISSILE_SPEED/32 // Parabolic throw speed
            elseif dist[n] < distmax[n] and local_booleans[n] == false then
                set dist[n] = dist[n] + MISSILE_SPEED/128 // Rolling speed after mines land
            endif
            
            set x = GetUnitX(mine_unit[n])
            set y = GetUnitY(mine_unit[n])
            set L = GetUnitLoc(mine_unit[n])
            set height = GetLocationZ(L) 
            
            if height < 0 then
                set height = (0-height)+Parabola(dist[n],distmax[n])
            elseif height > 0 then
                if 0+Parabola(dist[n],distmax[n])<=height then
                    set height = 0
                else
                    set height = Parabola(dist[n],distmax[n])-(height-0)
                endif
            else
                set height = Parabola(dist[n],distmax[n])
            endif
            
            call RemoveLocation(L)            
            call SetUnitFlyHeight(mine_unit[n], height,0) // Parabola
        
            if dist[n] + 50 < distmax[n] and local_booleans[n] == false then
                call SetUnitPosition(mine_unit[n], x+(MISSILE_SPEED/32)*Cos(angle[n]*bj_DEGTORAD), y+(MISSILE_SPEED/32)*Sin(angle[n]*bj_DEGTORAD))
            elseif dist[n] < distmax[n] and local_booleans[n] == false then
                call SetUnitPosition(mine_unit[n], x+(MISSILE_SPEED/128)*Cos(angle[n]*bj_DEGTORAD), y+(MISSILE_SPEED/128)*Sin(angle[n]*bj_DEGTORAD))
            elseif local_booleans[n] == false then
                call RemoveUnit(mine_unit[n])
                set temp_u = CreateUnit(GetOwningPlayer(c),mine,x,y,angle[n])
                call UnitApplyTimedLife(temp_u,'BTLF',3)
                set local_booleans[n] = true
            endif
            
            call SaveBoolean(HT, id, n+19, local_booleans[n]) // 20-25
            call SaveReal(HT, id, n+26, dist[n]) // 27-32
            
        endloop
    
        if local_booleans[1] == true and local_booleans[2] == true and local_booleans[3] == true and local_booleans[4] == true and local_booleans[5] == true and local_booleans[6] == true then
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
        endif
    
        set t = null
        set c = null
        set temp_u = null
        set L = null
        set mine_unit[1] = null
        set mine_unit[2] = null
        set mine_unit[3] = null
        set mine_unit[4] = null
        set mine_unit[5] = null
        set mine_unit[6] = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local unit c = GetTriggerUnit()
        local unit mine1
        local unit mine2
        local unit mine3
        local unit mine4
        local unit mine5
        local unit mine6
        local integer n = GetPlayerId(GetOwningPlayer(c))
        local integer id = GetHandleId(t)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local real x_cast = GetUnitX(c) 
        local real y_cast = GetUnitY(c) 
        local real x = GetSpellTargetX()
        local real y = GetSpellTargetY()
        local real x2 = x+DIST_APART*Cos(18*bj_DEGTORAD)
        local real x3 = x+DIST_APART*Cos(90*bj_DEGTORAD)
        local real x4 = x+DIST_APART*Cos(162*bj_DEGTORAD)
        local real x5 = x+DIST_APART*Cos(234*bj_DEGTORAD)
        local real x6 = x+DIST_APART*Cos(306*bj_DEGTORAD)
        local real y2 = y+DIST_APART*Sin(18*bj_DEGTORAD)
        local real y3 = y+DIST_APART*Sin(90*bj_DEGTORAD)
        local real y4 = y+DIST_APART*Sin(162*bj_DEGTORAD)
        local real y5 = y+DIST_APART*Sin(234*bj_DEGTORAD)
        local real y6 = y+DIST_APART*Sin(306*bj_DEGTORAD)
        local real angle1 = bj_RADTODEG*Atan2(y-y_cast,x-x_cast)
        local real angle2 = bj_RADTODEG*Atan2(y2-y_cast,x2-x_cast)
        local real angle3 = bj_RADTODEG*Atan2(y3-y_cast,x3-x_cast)
        local real angle4 = bj_RADTODEG*Atan2(y4-y_cast,x4-x_cast)
        local real angle5 = bj_RADTODEG*Atan2(y5-y_cast,x5-x_cast)
        local real angle6 = bj_RADTODEG*Atan2(y6-y_cast,x6-x_cast)
        local real dist1 = (SquareRoot((x-x_cast)*(x-x_cast)+(y-y_cast)*(y-y_cast)))
        local real dist2 = (SquareRoot((x2-x_cast)*(x2-x_cast)+(y2-y_cast)*(y2-y_cast)))
        local real dist3 = (SquareRoot((x3-x_cast)*(x3-x_cast)+(y3-y_cast)*(y3-y_cast)))
        local real dist4 = (SquareRoot((x4-x_cast)*(x4-x_cast)+(y4-y_cast)*(y4-y_cast)))
        local real dist5 = (SquareRoot((x5-x_cast)*(x5-x_cast)+(y5-y_cast)*(y5-y_cast)))
        local real dist6 = (SquareRoot((x6-x_cast)*(x6-x_cast)+(y6-y_cast)*(y6-y_cast)))
        
        set mine1 = CreateUnit(GetOwningPlayer(c),MINE_ID,x_cast,y_cast,angle1)
        set mine2 = CreateUnit(GetOwningPlayer(c),MINE_ID,x_cast,y_cast,angle2)
        set mine3 = CreateUnit(GetOwningPlayer(c),MINE_ID,x_cast,y_cast,angle3)
        set mine4 = CreateUnit(GetOwningPlayer(c),MINE_ID,x_cast,y_cast,angle4)
        set mine5 = CreateUnit(GetOwningPlayer(c),MINE_ID,x_cast,y_cast,angle5)
        set mine6 = CreateUnit(GetOwningPlayer(c),MINE_ID,x_cast,y_cast,angle6)
        
        call SetUnitScale(mine1,0.6+0.1*level,0.6+0.1*level,0.6+0.1*level)
        call SetUnitScale(mine2,0.6+0.1*level,0.6+0.1*level,0.6+0.1*level)
        call SetUnitScale(mine3,0.6+0.1*level,0.6+0.1*level,0.6+0.1*level)
        call SetUnitScale(mine4,0.6+0.1*level,0.6+0.1*level,0.6+0.1*level)
        call SetUnitScale(mine5,0.6+0.1*level,0.6+0.1*level,0.6+0.1*level)
        call SetUnitScale(mine6,0.6+0.1*level,0.6+0.1*level,0.6+0.1*level)
        
        call SaveUnitHandle(HT, id, 1, mine1)
        call SaveUnitHandle(HT, id, 2, mine2)
        call SaveUnitHandle(HT, id, 3, mine3)
        call SaveUnitHandle(HT, id, 4, mine4)
        call SaveUnitHandle(HT, id, 5, mine5)
        call SaveUnitHandle(HT, id, 6, mine6)
        call SaveUnitHandle(HT, id, 7, c)
        call SaveReal(HT, id, 8, dist1)
        call SaveReal(HT, id, 9, dist2)
        call SaveReal(HT, id, 10, dist3)
        call SaveReal(HT, id, 11, dist4)
        call SaveReal(HT, id, 12, dist5)
        call SaveReal(HT, id, 13, dist6)
        call SaveReal(HT, id, 14, angle1)
        call SaveReal(HT, id, 15, angle2)
        call SaveReal(HT, id, 16, angle3)
        call SaveReal(HT, id, 17, angle4)
        call SaveReal(HT, id, 18, angle5)
        call SaveReal(HT, id, 19, angle6)
        call SaveInteger(HT, id, 26, level)
        
        call TimerStart(t,0.03125,true,function TimerActions)
                
        set c = null
        set t = null
        set mine1 = null
        set mine2 = null
        set mine3 = null
        set mine4 = null
        set mine5 = null
        set mine6 = null
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