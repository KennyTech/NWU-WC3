scope KBLariat

    globals
        private constant integer SPELL_ID   = 'A0LI' // ID of ability: "Killer B - Lariat v2"
        private constant integer ULT_ID     = 'CW03' // ID of ability: "Killer B - 8-Tail Chakra"
        private constant integer AURA_ID    = 'CW07' // ID of ability: "Killer B - 8-Tail Chakra Aura"
        private constant integer STUN_ID    = 'CW99' // ID of ability: "Killer B - Lariat Stun"
        private constant integer DUMMY_ID1  = 'cw00' // ID of unit: "SX KillerB" (dummy unit - afterimage)
        private constant string EFFECT      = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl" // Lightning effect
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

    // =======================================
    // ======= BACKSTAB + STUN PORTION =======
    // =======================================
    private function GetAngleDifference takes real a1, real a2 returns real
        local real x
        set a1=ModuloReal(a1,360) // co-terminal angle
        set a2=ModuloReal(a2,360)
        if a1>a2 then
            set x=a1
            set a1=a2
            set a2=x
        endif
        set x=a2-360
        if a2-a1 > a1-x then
            set a2=x
        endif
        set x=a1-a2
        if (x<0) then
            return -x
        endif
        return x
    endfunction
    // =======================================
    
    private function LariatDash takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local unit u
        local rect r
        local boolexpr b
        local unit d // dummy afterimages
        local unit dc
        local group g = CreateGroup()
        local unit c = LoadUnitHandle(HT, id, 1) // load caster
        local real angle = LoadReal(HT, id, 2)
        local real distance = LoadReal(HT, id, 3) - 43.75
        local unit dm = LoadUnitHandle(HT, id, 4) // load dummy
        local group GG = LoadGroupHandle(HT, id, 5) // To make sure targets are damaged only once
        local real sfx = LoadReal(HT, id, 6) // For playing SX per 3 cycles of timer 
        local real dist = LoadReal(HT, id, 7) // For reverse lariat
        local boolean KB_dash = LoadBoolean(HT, id, 8) // For distance
        
        local real x = GetUnitX(c) // get caster x
        local real y = GetUnitY(c) // get caster y
        local real x2 // enemy target x (used to create SX on them)
        local real y2 // enemy target y
        local real x3 // move enemies to nearest pathable area
        local real y3 // move enemies to nearest pathable area
        local item i // move enemies to item position (nearest pathable area)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID) 
        local integer ult_level = GetUnitAbilityLevel(c, AURA_ID) 
        local real rad = 0 // Radius bonus of this ability (increased by ultimate form)
        local real impact_angle = 0
        local real enemy_facing = 0
            
        set rad = 25*ult_level // Increase effect radius of Lariat in ultimate form.
        
        if sfx > 1 then // SFX is created every 3 cycles (150 distance) 
            
            // Create and fade after-image dummy
            set d = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, x,y, angle) // afterimages effect
            call Fade (d) // fade images
            
            // Play walk animation on after-image dummy
            if GetUnitAbilityLevel(c, AURA_ID) == 0 then
                call SetUnitAnimationByIndex( d , 4 ) // play normal walk animation in normal form
            else
                call SetUnitAnimationByIndex( d , 9 ) // play alternate walk animation in ult form
            endif
            
            call DestroyEffect(AddSpecialEffect(EFFECT,GetUnitX(d),GetUnitY(d))) // create lightning SX
            call SetUnitTimeScale(d, 3.00) // speed up animation by 3x
            set sfx = 0
        else
            set sfx = sfx + 1
        endif
        
        call SaveReal(HT, id, 6, sfx)
        
        // Now we kill trees in range //
        set r = Rect(x-(100+rad),y-(100+rad),x+(100+rad),y+(100+rad)) // Ult also increase radius a bit
        set b = Filter(function TreeFilter)
        call EnumDestructablesInRect(r,b, function KillTree) 
        call RemoveRect(r)
        call DestroyBoolExpr(b)
        
        // Forward dashing and damage and stun
        if distance >= 0 and IsUnitType(c, UNIT_TYPE_DEAD) == false then 
            
            call SaveReal(HT, id, 3, distance)
            call SetUnitPosition(c, x+43.75*Cos(angle*bj_DEGTORAD), y+43.75*Sin(angle*bj_DEGTORAD)) // Move Killer Bee
            call SetUnitPosition(dm, GetUnitX(c), GetUnitY(c)) // Move Dummy (Killer B is transparent now, what you see is the dummy Killer Bee)
            
            call GroupEnumUnitsInRange(g,x,y,150+rad,function DamageFilter) // Find enemies to damage
            loop
            set u = FirstOfGroup(g)
            exitwhen u == null
                if IsUnitEnemy(u,GetOwningPlayer(c)) and IsUnitInGroup(u,GG) == false then 
                    set x2 = GetUnitX(u) // get enemy x
                    set y2 = GetUnitY(u) // get enemy y
                    
                    // =======================================
                    // ======= BACKSTAB + STUN PORTION =======
                    // =======================================
                    set impact_angle = GetUnitFacing(c)
                    set enemy_facing = GetUnitFacing(u)
            
                    if GetAngleDifference(impact_angle, enemy_facing) <= 80 and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false then // allow 80 degrees backstab stun
                        set dc = CreateUnit(GetOwningPlayer(c), 'h01K', x, y, 0) // spawn dummy caster
                        call UnitApplyTimedLife(dc,'BTLF',1.0)
                        call UnitAddAbility(dc, STUN_ID)
                        call IssueTargetOrder(dc, "firebolt", u)
                    endif
                    // =======================================
                    
                    call DestroyEffect(AddSpecialEffect (EFFECT, x2, y2)) // special effect
                    call Damage_Spell(c,u,30+(60*level)+(10*ult_level)) // deals physical damage (+bonus in ult form)
                    call GroupAddUnit(GG,u) // Don't let enemy get damaged again
                    set KB_dash = true
                    call SaveGroupHandle(HT, id, 5, GG)
                    call SaveBoolean(HT, id, 8, KB_dash)
                endif
                call GroupRemoveUnit(g,u)
            endloop
            call DestroyGroup(g)    
        else 
            call DestroyGroup(GG)     
            
            // Move Bee to nearest pathable area
            set x2 = GetUnitX(c) // get x
            set y2 = GetUnitY(c) // get y
            set i = CreateItem('afac', x2, y2) // Random Item is created to detect nearest pathable area
            set x3 = GetItemX(i)
            set y3 = GetItemY(i)
            call RemoveItem(i)
            call SetUnitX(c, x3) // Move all to nearest pathable area
            call SetUnitY(c, y3) // Move all to nearest pathable area
            // ================================
            
            call SetUnitVertexColor(c,255,255,255,255) // Make Killer Bee non-transparent again.
            call SetUnitPathing( c, true )
            
            if GetUnitAbilityLevel(c, AURA_ID) > 0 then
                call SetUnitAnimationByIndex( c , 9 ) // Play walk alternate animation at the end
            else
                call SetUnitAnimationByIndex( c , 4 ) // Normal animation if not in ult form
            endif
            
            call RemoveUnit(dm) // remove KB dummy
            call PauseTimer(t)
            call DestroyTimer(t)
            call FlushChildHashtable(HT, id)
            call DestroyGroup(GG)
            set KB_dash = false
            set sfx = 0
        endif
        
        set t = null
        set u = null
        set c = null
        set d = null
        set dm = null
        set g = null 
        set r = null
        set i = null
        set GG = null
    endfunction

    private function Actions takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local unit c = GetTriggerUnit()
        local unit dm // dummy main unit (This is replacement Killer B (real KB is transparent) - this is to play "walk" animation.
        local real x = GetUnitX(c) 
        local real y = GetUnitY(c) 
        local real x2 = GetSpellTargetX()
        local real y2 = GetSpellTargetY()
        local real angle = bj_RADTODEG*Atan2(y2-y,x2-x)
        local real distance
        local group GG = CreateGroup() // To make sure targets are damaged only once
        local real sfx = 0 // For playing SX per 3 cycles of timer 
        local real dist = 0 // For reverse lariat (didn't want to load another hashtable value)
        local boolean KB_dash = false
        
        set dm = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, x, y, GetUnitFacing(c)) // afterimages effect
        call SetUnitAnimationByIndex( dm , 4 ) // let Killer B (dummy) show "walk" animation.
        call SetUnitTimeScale(dm, 3.00) // Speed up animation by 3x.
        call SetUnitPathing( c, false )
        call SetUnitVertexColor(dm,255,255,255,150) // Semi Fade Dummy
        call SetUnitVertexColor(c,255,255,255,0) // Fade Killer B out
        call TimerStart(t,0.03125,true,function LariatDash) // Start the dash
        
        
        if RectContainsCoords(GetPlayableMapRect(),x+1050*Cos(angle*bj_DEGTORAD),y+1050*Sin(angle*bj_DEGTORAD)) then // Don't let Bee exit
            set distance = (SquareRoot((x-x2)*(x-x2)+(y-y2)*(y-y2))) + 50
        else
            set distance = (SquareRoot((x-x2)*(x-x2)+(y-y2)*(y-y2))) - 75
        endif
        
        set dist = (distance - distance*2) + 50 // save dist (negative value of distance for reverse)
        
        call SaveUnitHandle(HT, id, 1, c) // save Killer B
        call SaveReal(HT, id, 2, angle) // save angle
        call SaveReal(HT, id, 3, distance) // save distance
        call SaveUnitHandle(HT, id, 4, dm) // save Dummy(replacement Killer B)
        call SaveGroupHandle(HT, id, 5 , GG) // damaged group (damage only dealt once)
        call SaveReal(HT, id, 6, sfx) // counter for playing SFX
        call SaveReal(HT, id, 7, dist) // distance
        call SaveBoolean(HT, id, 8, KB_dash) // determines if Killer B reverses his dash to original position
        
        set t = null
        set c = null
        set dm = null
        set GG = null
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