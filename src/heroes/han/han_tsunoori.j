scope HanTsunoori

    globals
        private constant integer SPELL_ID           = 'CW48' 
        //private constant integer STUN_ID            = 'CW51' 
        private constant integer KNOCKBACK_COUNT    = 'CW55'
        private constant integer DUMMY_ID1          = 'cw06'  
        private constant integer DUMMY_ID2          = 'h01K'  
        private constant hashtable HT               = InitHashtable()
        private player PlayerCaster
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction

    private function DamageFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE) == false and IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false // We damage alive, non-structures
    endfunction

    private function TreeFilter takes nothing returns boolean
        local integer d = GetDestructableTypeId(GetFilterDestructable()) // Filter all trees for killing
        return d=='LTlt' or d=='VTlt' or d=='ATtr' or d=='ATtc' or d=='BTtw' or d=='BTtc' or d=='ZTtw' or d=='ZTtc' or d=='FTtw'
    endfunction

    private function KillTree takes nothing returns nothing
        call KillDestructable(GetEnumDestructable())
    endfunction
    
    private function RemoveCounter takes nothing returns nothing
        call UnitRemoveAbility(GetEnumUnit(), KNOCKBACK_COUNT)
    endfunction

    private function TimerQuickFade takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local integer alpha = LoadInteger(HT, id, 0)- 40
        local integer n = GetPlayerId(PlayerCaster)
        
        if alpha > 0 then
            call SetUnitVertexColor(LoadUnitHandle(HT, id, 1), 255,255,255, alpha)
            call SaveInteger(HT, GetHandleId(t), 0, alpha)
        else
            call RemoveUnit(LoadUnitHandle(HT, id, 1))
            call FlushChildHashtable(HT, GetHandleId(t))
            call PauseTimer(t)
            call DestroyTimer(t)
        endif
        set t = null
    endfunction

    private function QuickFade takes unit u returns nothing
        local timer t = CreateTimer()
        call SaveInteger(HT, GetHandleId(t), 0, 240)
        call SaveUnitHandle(HT, GetHandleId(t), 1, u)
        call TimerStart (t, 0.0625, true, function TimerQuickFade)
        set t = null
    endfunction
    
    private function DashSkewer takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u
        local rect r
        local boolexpr b
        local unit d // dummy afterimages + caster
        local group g
        local unit c = LoadUnitHandle(HT, id, 1) // load caster
        local real angle = LoadReal(HT, id, 2) // load angle 
        local real distance = LoadReal(HT, id, 3) - 50 // load distance
        local group GG = LoadGroupHandle(HT, id, 4) // Damage group only once
        local integer sfx = LoadInteger(HT, id, 5) // For playing FX every 'n' cycles
        local item i // untrap from unpathable terrain
        local real x = GetUnitX(c) // get caster x
        local real y = GetUnitY(c) // get caster y
        local real x2 // enemy target x 
        local real y2 // enemy target y
        local integer level = GetUnitAbilityLevel(c, SPELL_ID) 
        local integer n = GetPlayerId(GetOwningPlayer(c))
        
        set sfx = sfx + 1
        
        if ModuloInteger(sfx, 2) == 0 then // SFX is created every 2 cycles             
            set d = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, x,y, angle) // afterimages effect
            call SetUnitVertexColor(d, 255,255,255, 255)
            call QuickFade(d)
            if distance >= 150 then
                call SetUnitAnimationByIndex( d , 7 ) // alternate walk
            else
                call SetUnitAnimationByIndex( d , 8 ) // alternate un-morph
            endif
            call ExplodeSFX(x,y)
            call SetUnitTimeScale(d, 1.50) // speed up animation by 1.5x
        endif
        
        call SaveInteger(HT, id, 5, sfx)
        
        // Now we kill trees in range //
        set r = Rect(x-(180),y-(180),x+(180),y+(180)) 
        set b = Filter(function TreeFilter)
        call EnumDestructablesInRect(r,b, function KillTree) 
        call RemoveRect(r)
        call DestroyBoolExpr(b)
        // End tree killing //
            
        if distance > 0 then // This is the forward dash, and it deals damage.
            set g = CreateGroup()
            call SaveReal(HT, id, 3, distance)
            call SetUnitPosition(c, x+50*Cos(angle*bj_DEGTORAD), y+50*Sin(angle*bj_DEGTORAD)) // Move Han
        
            call GroupEnumUnitsInRange(g,x+100*Cos(angle*bj_DEGTORAD),y+100*Sin(angle*bj_DEGTORAD),200,function DamageFilter) // Get enemies in 200 AoE (in front)
            loop
            set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitInGroup(u,GG) == false and IsUnitEnemy(u,GetOwningPlayer(c)) and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false then 
                    call Damage_Spell(c,u,50+(100*level)) 
                    /*set d = CreateUnit(GetOwningPlayer(c), DUMMY_ID2, x, y, 0)
                    call UnitApplyTimedLife(d,'BTLF',0.3)
                    call UnitAddAbility(d, STUN_ID)
                    call SetUnitAbilityLevel(d, STUN_ID, level)
                    call IssueTargetOrder(d, "thunderbolt", u)*/
                    call UnitAddAbility(u, KNOCKBACK_COUNT)
                    call AddStunTimed(u, 1+0.5*level)
                    call GroupRemoveUnit(g,u)
                    call GroupAddUnit(GG,u) // Don't let enemy get damaged again
                    call SaveGroupHandle(HT, id, 4, GG)
                endif
                if IsUnitEnemy(u,GetOwningPlayer(c)) and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false and GetUnitAbilityLevel(u, KNOCKBACK_COUNT) <= 4 and GetUnitAbilityLevel(u, KNOCKBACK_COUNT) != 0 then 
                    set x2 = GetUnitX(u) // get enemy x
                    set y2 = GetUnitY(u) // get enemy y
                    call SetUnitPosition(u, x2+44.3*Cos(angle*bj_DEGTORAD), y2+44.3*Sin(angle*bj_DEGTORAD))
                    if GetUnitAbilityLevel(u, KNOCKBACK_COUNT) != 4 and ModuloInteger(sfx, 3) == 0 then // Each 3 cycles: 133 dist
                        call SetUnitAbilityLevel(u, KNOCKBACK_COUNT, GetUnitAbilityLevel(u, KNOCKBACK_COUNT) + 1) // Drag enemy 400 dist max
                    endif
                    if GetUnitAbilityLevel(u, KNOCKBACK_COUNT) == 4 then
                        call UnitRemoveAbility(u, KNOCKBACK_COUNT)
                    endif
                endif
                call GroupRemoveUnit(g,u)
            endloop
            call DestroyGroup(g)    
        else
            set i = CreateItem('afac', x, y) // Random Item is created to detect nearest pathable area
            set x = GetItemX(i)
            set y = GetItemY(i)
            call RemoveItem(i)
            call SetUnitX(c, x) // Move all to nearest pathable area
            call SetUnitY(c, y) // Move all to nearest pathable area
            
            call ForGroup(GG, function RemoveCounter)
            call DestroyGroup(GG)  
            call SetUnitAnimationByIndex( c , 8 )
            call SetUnitVertexColor(c, 255,255,255,255)
            call SetUnitPathing( c, true )
            call UnitRemoveInmunity(c)
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
            set sfx = 0
        endif
        
        set t = null
        set u = null
        set c = null
        set d = null
        set g = null 
        set r = null
        set i = null
        set GG = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c) 
        local real y = GetUnitY(c) 
        local real x2 = GetSpellTargetX()
        local real y2 = GetSpellTargetY()
        local real angle = bj_RADTODEG*Atan2(y2-y,x2-x)
        local real distance = SquareRoot((x2-x)*(x2-x)+(y2-y)*(y2-y))
        local group GG = CreateGroup()
        local unit d
        
        set PlayerCaster = GetOwningPlayer(c)
        set d = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, x,y, angle) // afterimages effect
        call QuickFade(d)
        call SetUnitAnimationByIndex( d , 6 ) // play normal walk animation in normal form
        
        call SaveUnitHandle(HT, id, 1, c) // save Han
        call SaveReal(HT, id, 2, angle) // save angle
        call SaveReal(HT, id, 3, distance + 40) // save distance
        call SaveGroupHandle(HT, id , 4, GG)
        
        call SetUnitPathing( c, false )
        call SetUnitVertexColor(c,255,255,255,0)
        
        call TriggerSleepAction(0.1)
        call UnitAddInmunity(c)
        call TimerStart(t,0.03125,true,function DashSkewer) // Start the dash
        
        set GG = null
        set t = null
        set c = null
        set d = null
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
