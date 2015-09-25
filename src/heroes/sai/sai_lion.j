scope SaiLion

    globals
        private constant integer SPELL_ID   = 'CW38'
        private constant integer SLOW_ID    = 'CW39' 
        private constant integer DUST_ID    = 'CW40'
        private constant integer REVEAL_ID  = 'CW41'
        private constant integer DUMMY_ID1  = 'cw04' 
        private constant integer DUMMY_ID2  = 'h01K'
        private constant string SFX         = "Objects\\Spawnmodels\\Undead\\UndeadBlood\\UndeadBloodGargoyle.mdl"
        private constant hashtable HT       = InitHashtable()
        private unit LionCaster
        private unit CurrentPick
        private real CenterX = 0
        private real CenterY = 0
        private real CurrentDistance = 0 
        private unit array Order
        private group AnyGroup = CreateGroup()
        private group ResultingGroup = CreateGroup()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function HeroFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(LionCaster)) == true and IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) == true and IsUnitVisible(GetFilterUnit(),GetOwningPlayer(LionCaster)) and IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE) == false
    endfunction

    private function Enum takes nothing returns nothing
        local unit u = GetEnumUnit()
        local real dx = GetUnitX(u) - CenterX
        local real dy = GetUnitY(u) - CenterY
        local real d = (dx*dx + dy*dy) / 10000.
        if d < CurrentDistance then
            set CurrentDistance = d
            set CurrentPick = u
        endif
        set u = null
    endfunction
    
    private function GetClosestUnitsInRange takes real x, real y, real radius, integer n, boolexpr filter returns group
        call GroupEnumUnitsInRange(AnyGroup, x, y, radius, filter)
        set ResultingGroup = CreateGroup()
        set CenterX = x
        set CenterY = y
        loop
            exitwhen n == 0
            set CurrentPick = null
            set CurrentDistance = 100000
            call ForGroup(AnyGroup, function Enum)
            exitwhen CurrentPick == null
            call GroupRemoveUnit(AnyGroup, CurrentPick)
            call GroupAddUnit(ResultingGroup, CurrentPick)
            set Order[n] = CurrentPick
            set n = n - 1
        endloop
        return ResultingGroup
    endfunction

    private function PursueLoop takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit dummy
        local unit lion1 = LoadUnitHandle(HT, id, 1) 
        local unit lion2 = LoadUnitHandle(HT, id, 2) 
        local unit target1 = LoadUnitHandle(HT, id, 3) 
        local unit target2 = LoadUnitHandle(HT, id, 4)
        local unit c = LoadUnitHandle(HT, id, 5)
        local real sfx1 = LoadReal(HT, id, 6)
        local real sfx2 = LoadReal(HT, id, 7)
        local integer impacts = LoadInteger(HT, id, 8)
        local real x1 = GetUnitX(lion1) 
        local real y1 = GetUnitY(lion1)
        local real x2 = GetUnitX(lion2)
        local real y2 = GetUnitY(lion2)
        local real x3 = GetUnitX(target1)
        local real y3 = GetUnitY(target1)
        local real x4 = GetUnitX(target2)
        local real y4 = GetUnitY(target2)
        local real angle1 = bj_RADTODEG*Atan2(y3-y1,x3-x1)
        local real angle2 = bj_RADTODEG*Atan2(y4-y2,x4-x2)
        local real dist1 = SquareRoot((x3-x1)*(x3-x1)+(y3-y1)*(y3-y1))
        local real dist2 = SquareRoot((x4-x2)*(x4-x2)+(y4-y2)*(y4-y2))
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local integer sfx3
        
        //call DisplayTextToForce( GetPlayersAll(), "loop ran")
        call SetUnitFacing(lion1, angle1)
        call SetUnitFacing(lion2, angle2)

        set sfx2 = sfx2 + 1

        if sfx1 < 12 then // Grow lion for 12 loops
            set sfx1 = sfx1 + 1
            call SetUnitScale(lion1, 0.16 + sfx1 * 0.04, 0.16 + sfx1 * 0.04, 0.16 + sfx1 * 0.04)
        endif
        
        if target1 != target2 then
            set sfx3 = 12
        else
            set sfx3 = 14
        endif
        
        if sfx2 < 24 and sfx2 > sfx3 then // Grow lion for 12 loops
            call SetUnitScale(lion2, 0.07 + (sfx2-sfx3) * 0.04, 0.07 + (sfx2-sfx3) * 0.04, 0.07 + (sfx2-sfx3) * 0.04)
        endif
        
        call SaveReal(HT, id, 6, sfx1)
        call SaveReal(HT, id, 7, sfx2)
        
        if dist1 >= 80 then // Pursue
            call SetUnitX(lion1, x1+19.5*Cos(angle1*bj_DEGTORAD)) // Speed of 620
            call SetUnitY(lion1, y1+19.5*Sin(angle1*bj_DEGTORAD))
        else
            call DestroyEffect(AddSpecialEffect(SFX,x3,y3))
            call RemoveUnit(lion1)
            call Damage_Spell(c,target1,50 * level) // Deals 50/100/150/200 spell dmg
            set dummy = CreateUnit(GetOwningPlayer(c), DUMMY_ID2, x3, y3, 0)
            call UnitApplyTimedLife(dummy,'BTLF',0.2)
            call UnitAddAbility(dummy, SLOW_ID)
            call SetUnitAbilityLevel(dummy, SLOW_ID, level)
            call UnitAddAbility(dummy, DUST_ID)
            call UnitAddAbility(dummy, REVEAL_ID)
            call IssueImmediateOrder(dummy, "thunderclap")
            call IssueImmediateOrderById(dummy, 852625) // Dust Ability Order ID
            call IssueTargetOrder(dummy, "faeriefire", target1)
            set dummy = null
            set impacts = impacts + 1
        endif

        if dist2 >= 80 and sfx2 >= 10 then // Pursue
            call SetUnitX(lion2, x2+19.5*Cos(angle2*bj_DEGTORAD)) // Speed of 620
            call SetUnitY(lion2, y2+19.5*Sin(angle2*bj_DEGTORAD))
        elseif dist2 < 80 then 
            call DestroyEffect(AddSpecialEffect(SFX,x4,y4))
            call RemoveUnit(lion2)
            if target1 != target2 then
                call Damage_Spell(c,target2,50*level)
            else
                call Damage_Spell(c,target2,0.5*(50*level))
            endif
            set dummy = CreateUnit(GetOwningPlayer(c), DUMMY_ID2, x4, y4, 0)
            call UnitApplyTimedLife(dummy,'BTLF',0.2)
            call UnitAddAbility(dummy, SLOW_ID)
            call SetUnitAbilityLevel(dummy, SLOW_ID, level)
            call UnitAddAbility(dummy, DUST_ID)
            call UnitAddAbility(dummy, REVEAL_ID)
            call IssueImmediateOrder(dummy, "thunderclap")
            call IssueImmediateOrderById(dummy, 852625) // Dust Ability Order ID
            call IssueTargetOrder(dummy, "faeriefire", target2)
            set dummy = null
            set impacts = impacts + 1
        endif
        
        call SaveInteger(HT, id, 8, impacts)
        
        if impacts == 2 then // End loop once both lions impacted
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
            set impacts = 0
            set Order[2] = null
            set Order[1] = null
        endif
        
        set c = null
        set t = null
        set target1 = null
        set target2 = null
        set lion1 = null
        set lion2 = null
        set dummy = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit c = GetTriggerUnit()
        local unit target1 = null
        local unit target2 = null
        local unit lion1 = null
        local unit lion2 = null
        local real x = GetUnitX(c) 
        local real y = GetUnitY(c) 
        local real x3  
        local real y3  
        local real x4  
        local real y4 
        local real angle1 
        local real angle2 
        local boolexpr b1
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local integer n = GetPlayerId(GetOwningPlayer(c))
        
        set b1 = Filter(function HeroFilter)
        
        set LionCaster = c // For below filter
        call GetClosestUnitsInRange(x,y,1000,2, b1) // Get 2 closest enemy heroes in 1000
        set target1 = Order[2] // closest enemy
        set target2 = Order[1] // 2nd closest enemy
        
        if target1 != null then
        
            if target2 == null then
                set target2 = target1 // If there is only 1 close enemy, both lions target it
            endif
            
            set x3 = GetUnitX(target1)
            set y3 = GetUnitY(target1)
            set x4 = GetUnitX(target2)
            set y4 = GetUnitY(target2)
            set angle1 = bj_RADTODEG*Atan2(y3-y,x3-x)
            set angle2 = bj_RADTODEG*Atan2(y4-y,x4-x)
            set lion1 = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, x, y, angle1)
            set lion2 = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, x, y, angle2)
            call SetUnitVertexColor(lion1, 255,255,255, 255)
            call SetUnitVertexColor(lion2, 255,255,255, 255)
            call SetUnitAnimationByIndex(lion1 , 3 )
            call SetUnitAnimationByIndex(lion2 , 3 )
            call SetUnitTimeScale(lion1, 3) // Speed up animation
            call SetUnitTimeScale(lion2, 3) // Speed up animation
            call SetUnitPathing( lion1, false )
            call SetUnitPathing( lion2, false )
            
            call SaveUnitHandle(HT, id, 1, lion1)
            call SaveUnitHandle(HT, id, 2, lion2)
            call SaveUnitHandle(HT, id, 3, target1)
            call SaveUnitHandle(HT, id, 4, target2)
            call SaveUnitHandle(HT, id, 5, c)
            
            call TimerStart(t,0.03125,true,function PursueLoop)
        endif 
        
        set c = null
        set t = null
        set target1 = null
        set target2 = null
        set lion1 = null
        set lion2 = null
        set b1 = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        set t = null

        call AbilityPreload(SLOW_ID)
        call AbilityPreload(DUST_ID)
        call AbilityPreload(REVEAL_ID)
        call UnitPreload(DUMMY_ID1)

    endfunction

endscope