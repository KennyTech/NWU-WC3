scope InoMindUlt

    globals
        private constant integer SPELL_ID       = 'CW78' 
        private constant integer BLOODLUST_ID   = 'CW75'
        private constant integer DUMMY_ID1      = 'cw99'
        private constant integer CREEP_PLAYER_1 = 0 // Red = 0
        private constant integer CREEP_PLAYER_2 = 6 // Green = 6
        private constant hashtable HT = InitHashtable()
        private group INO_ULT_GROUP = CreateGroup()
        private unit CurrentPick
        private real CenterX = 0
        private real CenterY = 0
        private real CurrentDistance = 0 
        private group AnyGroup = CreateGroup()
        private group ResultingGroup = CreateGroup()
        private player PlayerCaster
        private unit InoCaster
        private player OriginalPlayer
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID 
    endfunction
    
    private function Kill takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        call SetUnitOwner(GetEnumUnit(),OriginalPlayer,true)
        call Damage_Spell(InoCaster,GetEnumUnit(),3000)
        call GroupRemoveUnit(INO_ULT_GROUP, GetEnumUnit())
        set t = null
    endfunction
    
    // Hero priority
    private function HeroPriorityFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(),PlayerCaster) == true and IsUnitVisible(GetFilterUnit(),PlayerCaster) == true and IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) == false and IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) == true 
    endfunction
    
    // No heroes in range - unit priority
    private function NormalFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(),PlayerCaster) == true and IsUnitVisible(GetFilterUnit(),PlayerCaster) == true
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
            set n = n - 1
        endloop
        return ResultingGroup
    endfunction

    private function AttackClosestEnemy takes nothing returns nothing
        local real x = GetUnitX(GetEnumUnit())
        local real y = GetUnitY(GetEnumUnit())
        local boolexpr b1
        local boolexpr b2
        
        set b1 = Filter(function HeroPriorityFilter)
        set b2 = Filter(function NormalFilter)
        call GetClosestUnitsInRange(x,y,1200,1,b1)
        if CurrentPick == null then
            call GetClosestUnitsInRange(x,y,1500,1,b2)
        endif
        call IssueTargetOrder(GetEnumUnit(), "attack", CurrentPick)
    
    endfunction
    
    private function Loop takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit c = LoadUnitHandle(HT, id, 1) 
        local integer ticks = LoadInteger(HT, id, 2) + 1

        call SaveInteger(HT, id, 2, ticks)
        
        call ForGroup(INO_ULT_GROUP, function AttackClosestEnemy)
        
        if ticks == 80 then // 10 seconds
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
            call ForGroup(INO_ULT_GROUP, function Kill)
        endif
        
        set t = null
        set c = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c) 
        local real y = GetUnitY(c) 
        local player p = GetOwningPlayer(c)
        local unit dummy
        local unit u
        local group g = CreateGroup()
        local boolexpr b1
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local integer n = GetPlayerId(p)
        local integer damage
        
        // Create Range Checker Visual
        set dummy = CreateUnit(p, 'cw19', x-27.5, y-122.5, 0)
        call SetUnitVertexColor(dummy,255,100,200,25) 
        call SetUnitTimeScale(dummy, 0.5)
        call UnitApplyTimedLife(dummy,'BTLF',0.8)
        
        call TriggerSleepAction(0.25)
        
        set b1 = Filter(function NormalFilter)
        set PlayerCaster = p
        set InoCaster = c
        set InoUltCaster[n] = c
        
        call TimerStart(t,0.125,true,function Loop) 
        
        // Grab enemy creeps to take control of
        call GroupEnumUnitsInRange(g,x,y,925,null)
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_DEAD)==false and IsUnitVisible(u,p) == true and IsUnitType(u, UNIT_TYPE_STRUCTURE) == false and IsUnitType(u, UNIT_TYPE_HERO) == false and GetPlayerId(GetOwningPlayer(u)) == CREEP_PLAYER_1 or GetPlayerId(GetOwningPlayer(u)) == CREEP_PLAYER_2 then            
                
                set damage = R2I(GetUnitDamage(c, 0, udg_HeroMainStat[GetUnitPointValue(c)])*0.04*level)
                call DamageBonus(u, damage) 
            
                if level == 2 then
                    call UnitAddAbility(u, 'AIlf') // Add 150 hp
                elseif level == 3 then
                    call UnitAddAbility(u, 'AIl2') // Add 300 hp
                endif
                
                // Change ownership, keep old player color
                set OriginalPlayer = GetOwningPlayer(u)
                call SetUnitOwner(u, p, false)
                call SetUnitUserData(u, n*10 +10)
                
                // Add Bloodlust
                set dummy = CreateUnit(p, DUMMY_ID1, x, y, 0)
                call UnitApplyTimedLife(dummy,'BTLF',0.5)
                call UnitAddAbility(dummy, BLOODLUST_ID)
                call SetUnitAbilityLevel(dummy, BLOODLUST_ID, level)
                call IssueTargetOrder(dummy, "bloodlust", u)
                
                // Attack closest enemy
                call GroupAddUnit(INO_ULT_GROUP, u)
                call GetClosestUnitsInRange(x,y,1500,1, b1)
                call IssueTargetOrder(u, "attack", CurrentPick)
            endif
            call GroupRemoveUnit(g, u)
        endloop
        
        call SaveUnitHandle(HT, id, 1, c)
        
        set t = null
        set c = null
        set g = null
        set u = null
        set dummy = null
        set p = null
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
