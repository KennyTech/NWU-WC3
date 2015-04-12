/**
 * Este es el pedazo de codigo legado que mas odio xD
 */

//--------------------------------------- TIMED FOG ---------------------------------------

function CreateFogTimedExpire takes nothing returns nothing
    local timer t=GetExpiredTimer()
    local fogmodifier fog=LoadFogModifierHandle(HT,GetHandleId(t),0)
	call FogModifierStop(fog)
	call DestroyFogModifier(fog)
    call ReleaseTimer(t)
    set t=null
    set fog=null
endfunction

function CreateFogTimed takes fogmodifier fog,real time returns nothing
    local timer t = NewTimer()
    call FogModifierStart(fog)
    call SaveFogModifierHandle(HT,GetHandleId(t),0,fog)
    call TimerStart(t,time,false,function CreateFogTimedExpire)
    set t=null
endfunction


function AbortOrder takes unit u returns nothing
    call PauseUnit(u,true)
    call IssueImmediateOrder(u,"stop")
    call PauseUnit(u,false)
endfunction
function Mod takes integer i,integer j returns boolean
    return ModuloInteger(i,j)==0
endfunction
/*function DEBUG takes string s returns nothing
    if udg_SingleMode then
        call BJDebugMsg(s)
    endif
endfunction*/    
function Mensaje takes string m returns nothing
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,12.3,m)
endfunction
function GetGameTime takes nothing returns real
    return TimerGetElapsed(udg_Game_Timer)
endfunction

function GetItemUnit takes unit u returns integer
    local integer index = 0
    local integer utype = GetUnitTypeId(u)
    loop
        exitwhen index>udg_ARTISAN
        if udg_ITEMUNIT[index]==utype then
            return udg_UNITITEM[index]
        endif
        set index = index + 1
    endloop
    return -1
endfunction


function EsItemParcial takes item Item returns boolean
    local integer index = 0
    local integer id = GetItemTypeId(Item)
    set Item = null
    loop
        exitwhen index>udg_PARCIAL
        if udg_Parcial[index]==id then
            return true
        endif
        set index = index + 1
    endloop
    return false
endfunction

function IsUnitInRect takes unit u, rect r returns boolean
    local region reg = CreateRegion()
    local boolean b
    call RegionAddRect( reg, r )
    set b = IsUnitInRegion( reg, u )
    call RemoveRegion( reg )
    set reg = null
    return b
endfunction

//****** UNIT FUNCTIONS *******
function GetUnitDamage takes unit u, real damage, integer MainStat returns real
    local real Percent = 1
    local integer index
    local item    indexItem

    //******* Agregar damage de stats ******
    if MainStat==1 then
       set damage =damage + GetHeroStr(u, true)
    elseif MainStat==2 then
       set damage = damage + GetHeroAgi(u, true)
    elseif MainStat==3 then
       set damage = damage + GetHeroInt(u, true)
    endif
    //******* Agregar damage de buffs ******
    if GetUnitAbilityLevel(u,'B038') > 0 then //Double Damage Rune
       set Percent = 2
    endif
    if GetUnitAbilityLevel(u,'B023') > 0 then //Tobi Mask
       set Percent = Percent + 0.15
    endif
    // Sumar otros Buffs como el Nibi Claw, sello de jirobo, daño de lee y demas
    set damage = damage * Percent

    set index = 0
    loop
        set indexItem = UnitItemInSlot(u, index)
        if GetItemTypeId(indexItem)=='I02F' then // Akatsuki ring
           set damage = damage + 6
        endif
        if GetItemTypeId(indexItem)=='I01N' then // Silver Watch
           set damage = damage + 10
        endif
        if GetItemTypeId(indexItem)=='I032' then // Gale Blade
           set damage = damage + 35
        endif
        if GetItemTypeId(indexItem)=='I04B' then // Good Guys Suit
           set damage = damage + 30
        endif
        if GetItemTypeId(indexItem)=='I030' then // Iron Crow
           set damage = damage + 30
        endif
        if GetItemTypeId(indexItem)=='I03M' then // Kusanagi
           set damage = damage + 60
        endif
        if GetItemTypeId(indexItem)=='I04I' then // Poison Gauntlets
           set damage = damage + 18
        endif
        if GetItemTypeId(indexItem)=='I03X' then // Ragnorok
           set damage = damage + 70
        endif
        if GetItemTypeId(indexItem)=='I01U' then // Raijin
           set damage = damage + 24
        endif
        if GetItemTypeId(indexItem)=='I06F' then // Sarutobi's Helm
           set damage = damage + 20
        endif
        if GetItemTypeId(indexItem)=='I01S' then // Silver Hands
           set damage = damage + 60
        endif
        if GetItemTypeId(indexItem)=='I046' then // Solar Blade
           set damage = damage + 60
        endif
        if GetItemTypeId(indexItem)=='I034' then // Tri-Blade
           set damage = damage + 10
        endif
        if GetItemTypeId(indexItem)=='I03P' then // Twin-Fang of Abyss
           set damage = damage + 12
        endif
        if GetItemTypeId(indexItem)=='I04X' then // Amenonuhoko
           set damage = damage + 250
        endif
        if GetItemTypeId(indexItem)=='I04U' then // Assassin's Cloak
           set damage = damage + 38
        endif
        if GetItemTypeId(indexItem)=='I02D' then // Conch Shell Mace Active
           set damage = damage + 80
        endif
        if GetItemTypeId(indexItem)=='I036' then // Conch Shell Mace Inactive
           set damage = damage + 80
        endif
        if GetItemTypeId(indexItem)=='I01M' then // Gelel Stone
           set damage = damage + 24
        endif
        if GetItemTypeId(indexItem)=='I03O' then // Hexagonal Crystal
           set damage = damage + 40
        endif
        if GetItemTypeId(indexItem)=='I02G' then // Idate's Sandal
           set damage = damage + 24
        endif
        if GetItemTypeId(indexItem)=='I061' then // Ikazuchi
           set damage = damage + 24
        endif
        if GetItemTypeId(indexItem)=='I057' then // Jashin's Amulet
           set damage = damage + 20
        endif
        if GetItemTypeId(indexItem)=='I03R' then // Kaguya Armor
           set damage = damage + 22
        endif
        if GetItemTypeId(indexItem)=='I04A' then // Karites Touch 1
           set damage = damage + 9
        endif
        if GetItemTypeId(indexItem)=='I005' then // Karites Touch 2
           set damage = damage + 9
        endif
        if GetItemTypeId(indexItem)=='I006' then // Karites Touch 3
           set damage = damage + 9
        endif
        if GetItemTypeId(indexItem)=='I007' then // Karites Touch 4
           set damage = damage + 9
        endif
        if GetItemTypeId(indexItem)=='I05F' then // The Totsuka
           set damage =damage + 45
        endif
        if GetItemTypeId(indexItem)=='I00J' then // Broadsword
           set damage =damage + 18
        endif
        if GetItemTypeId(indexItem)=='I01E' then // Essence of Tranquility
           set damage = damage + 46
        endif
        if GetItemTypeId(indexItem)=='I06N' then // Javelin
           set damage = damage + 21
        endif
        if GetItemTypeId(indexItem)=='I00F' then // Metal Gauntles
           set damage = damage + 10
        endif
        if GetItemTypeId(indexItem)=='I008' then // Mithril Hammer
           set damage = damage + 24
        endif
        if GetItemTypeId(indexItem)=='I01F' then // Red Sun
           set damage = damage + 60
        endif
        if GetItemTypeId(indexItem)=='I00L' then // Chinobi Claws
           set damage = damage + 9
        endif
        if GetItemTypeId(indexItem)=='I00B' then // Tenten's Spear
           set damage = damage + 21
        endif
        set index = index + 1
        exitwhen index >= bj_MAX_INVENTORY
    endloop
    return damage
endfunction



function RemoveBonusDamage takes unit u returns nothing
    call UnitRemoveAbility(u,'A0DF' )
    call UnitRemoveAbility(u,'A0DZ' )
endfunction

function SetBonusDamage takes unit u, integer damage returns nothing
    local integer D = damage

    call UnitRemoveAbility(u,'A0DF')
    call UnitRemoveAbility(u,'A0DZ')

    if damage > 0 then
       set damage = damage / 10
       if damage > 0 then
          call UnitAddAbility(u,'A0DF')
          call SetUnitAbilityLevel(u, 'A0DF', damage)
       endif
       set D = D - (damage*10)
       if D > 0 then
          call UnitAddAbility(u,'A0DZ')
          call SetUnitAbilityLevel(u, 'A0DZ', D)
       endif
    endif
endfunction

//****** UNIT CHANGE HP/MANA *******
constant function MaxStateModifierId takes unitstate u returns integer
    if u == UNIT_STATE_MAX_LIFE then
       return 'A000' // Rawcode of the Max Life Modifier ability.
    elseif u == UNIT_STATE_MAX_MANA then
       return 'A001' // Rawcode of the Max Mana Modifier ability.
    endif
    return 0
endfunction
function SetUnitMaxState takes unit whichUnit, unitstate whichUnitState, integer newVal returns boolean
    local integer c = newVal-R2I(GetUnitState(whichUnit, whichUnitState))
    local integer i //= MaxStateModifierId(whichUnitState)

    if whichUnitState == UNIT_STATE_MAX_LIFE then
       set i = 'A062'
    elseif whichUnitState == UNIT_STATE_MAX_MANA then
       set i = 'A06C'
    else
       return false
    endif

//    if i == 0 then
//       return false
//    endif
    if c > 0 then
       loop
           exitwhen c == 0
           call UnitAddAbility(whichUnit, i)
           if c >= 100 then
              set c = c - 100
              call SetUnitAbilityLevel(whichUnit, i, 4)
           elseif c >= 10 then
              set c = c - 10
              call SetUnitAbilityLevel(whichUnit, i, 3)
           else
              set c = c - 1
              call SetUnitAbilityLevel(whichUnit, i, 2)
           endif
           call UnitRemoveAbility(whichUnit, i)
       endloop
    elseif c < 0 then
       set c = -c
       loop
           exitwhen c == 0
           call UnitAddAbility(whichUnit, i)
           if c >= 100 then
              set c = c - 100
              call SetUnitAbilityLevel(whichUnit, i, 7)
           elseif c >= 10 then
              set c = c - 10
              call SetUnitAbilityLevel(whichUnit, i, 6)
           else
              set c = c - 1
              call SetUnitAbilityLevel(whichUnit, i, 5)
           endif
           call UnitRemoveAbility(whichUnit, i)
       endloop
    endif
    return true
endfunction


//****** UNIT SIZE *******
function SetUnitScaleTimedMain takes nothing returns nothing
   local timer t = GetExpiredTimer()
   local integer i = GetHandleId( t )
   local unit Target = LoadUnitHandle( udg_TimerHashtable, i, 0 )
   local real Scale = LoadReal( udg_TimerHashtable, i, 1 )
   local real Size1 = LoadReal( udg_TimerHashtable, i, 2 ) + Scale
   local real Size2 = LoadReal( udg_TimerHashtable, i, 3 )

   call SaveReal( udg_TimerHashtable, i, 2, Size1 )
   call SetUnitScale( Target, Size1, Size1, Size1 )

   if (Size1==Size2) then
      call FlushChildHashtable( udg_TimerHashtable, i )
      call PauseTimer( t )
      call DestroyTimer( t )
   endif
   set Target = null
endfunction
function SetUnitScaleTimed takes unit Target, real Size1, real Size2, real Time returns nothing
    local timer t
    local integer i

    set t = CreateTimer()
    set i = GetHandleId( t )
    call SaveUnitHandle( udg_TimerHashtable, i, 0, Target )
    call SaveReal      ( udg_TimerHashtable, i, 1, (Size2-Size1)/(Time/0.02) ) //Scale
    call SaveReal      ( udg_TimerHashtable, i, 2, Size1 )
    call SaveReal      ( udg_TimerHashtable, i, 3, Size2 )
    call TimerStart( t,.02,true,function SetUnitScaleTimedMain)

    set t = null
    set Target = null
endfunction



//****** MISSILES *******
/*
function HommingMissileMain takes nothing returns nothing
   local timer t = GetExpiredTimer()
   local integer i = GetHandleId( t )
   local unit Target = LoadUnitHandle( udg_TimerHashtable, i, 0 )
   local unit Missile = LoadUnitHandle( udg_TimerHashtable, i, 1 )
   local real Speed = LoadReal( udg_TimerHashtable, i, 2 )
   local real dx = GetUnitX(Target) - GetUnitX(Missile)
   local real dy = GetUnitY(Target) - GetUnitY(Missile)
   local real DistanceToTarget = SquareRoot(dx * dx + dy * dy)
   local real Angle = bj_RADTODEG * Atan2(dy, dx)

   call PauseUnit(Missile,true)
   call SetUnitPosition(Missile, GetUnitX(Missile)+Speed*Cos(Angle*bj_DEGTORAD), GetUnitY(Missile)+Speed*Sin(Angle*bj_DEGTORAD))

   if (DistanceToTarget<=Speed) then
      call PauseUnit(Missile,false)
      call RemoveUnit( Missile )
      call FlushChildHashtable( udg_TimerHashtable, i )
      call PauseTimer( t )
      call DestroyTimer( t )
   endif
   set Target = null
   set Missile = null
endfunction
function HommingMissile takes unit Target, unit Missile, real Speed returns nothing
    local timer t
    local integer i

    set t = CreateTimer()
    set i = GetHandleId( t )
    call PauseUnit(Missile,true)
    call SetUnitPathing( Missile, false )
    call SaveUnitHandle( udg_TimerHashtable, i, 0, Target )
    call SaveUnitHandle( udg_TimerHashtable, i, 1, Missile )
    call SaveReal      ( udg_TimerHashtable, i, 2, Speed )
    call TimerStart( t,.02,true,function HommingMissileMain)

    set t = null
    set Target = null
    set Missile = null
endfunction

function MissileSYSMain takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer i = GetHandleId( t )
    local unit Missile = LoadUnitHandle( udg_TimerHashtable, i, 0 )
    local real Speed = LoadReal( udg_TimerHashtable, i, 1 )
    local real Distance = LoadReal( udg_TimerHashtable, i, 2 ) - Speed

    call SaveReal( udg_TimerHashtable, i, 2, Distance )

    call PauseUnit(Missile,true)
    call SetUnitPosition(Missile, GetUnitX(Missile)+Speed*Cos(GetUnitFacing(Missile)*bj_DEGTORAD), GetUnitY(Missile) + Speed * Sin(GetUnitFacing(Missile) * bj_DEGTORAD))

    if (Distance<=Speed) then
       call PauseUnit(Missile,false)
       call RemoveUnit( Missile )
       call FlushChildHashtable( udg_TimerHashtable, i )
       call PauseTimer( t )
       call DestroyTimer( t )
    endif
    set Missile = null
endfunction
function MissileSYS takes unit Missile, real Speed, real Distance returns nothing
    local timer t
    local integer i

    set t = CreateTimer()
    set i = GetHandleId( t )
    call PauseUnit(Missile,true)
    call SetUnitPathing( Missile, false )
    call SaveUnitHandle( udg_TimerHashtable, i, 0, Missile )
    call SaveReal      ( udg_TimerHashtable, i, 1, Speed )
    call SaveReal      ( udg_TimerHashtable, i, 2, Distance )
    call TimerStart( t,.02,true,function MissileSYSMain)

    set t = null
    set Missile = null
endfunction
*/

//**************************

    function IsItemOwnedBy takes item Item,player which returns boolean
       if GetPlayerSlotState(Player(GetItemUserData(Item)))!=PLAYER_SLOT_STATE_PLAYING then
           return true
       endif
       return Player(GetItemUserData(Item))==which
    endfunction

    function EsItemTransferible takes item Item returns boolean
        local integer id = GetItemTypeId(Item)
        local integer index = 0
        if Item == null then
            return false
        endif
        if not IsItemPowerup(Item) then
            loop
                if id == udg_SeSalvan[index] then
                    return true
                endif
                set index = index + 1
                exitwhen index > udg_NIS_NUMBER
            endloop
        endif
        set Item = null
        return false
    endfunction
    




//##########################################################################

function TT_GoldBounty takes unit whichUnit, integer bounty, player killer returns nothing
    local texttag tt = CreateTextTag()
    local string text = "+" + I2S(bounty)
    call SetTextTagText(tt, text, 0.024)
    call SetTextTagPos(tt, GetUnitX(whichUnit)-16.0, GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 255, 220, 0, 255)
    call SetTextTagVelocity(tt, 0.0, 0.03)
    call SetTextTagVisibility(tt, GetLocalPlayer()==killer)
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 3.0)
    call SetTextTagPermanent(tt, false)
    set text = null
    set tt = null
endfunction


//##########################################################################





        


//##########################################################################
function CreateWalkabilityBlocker takes real x, real y, boolean walkable returns nothing
    call SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, walkable)
endfunction
function CreateFlyabilityBlocker takes real x, real y, boolean flyable returns nothing
    call SetTerrainPathable(x, y, PATHING_TYPE_FLYABILITY, flyable)
endfunction
function CreateMoveabilityBlocker takes real x, real y, boolean moveable returns nothing
    call CreateWalkabilityBlocker(x, y, moveable)
    call CreateFlyabilityBlocker(x, y, moveable)
endfunction
function CreateLargeWalkabilityBlocker takes real x, real y, boolean walkable returns nothing
    call CreateWalkabilityBlocker(x + 16, y + 16, walkable)
    call CreateWalkabilityBlocker(x - 16, y - 16, walkable)
    call CreateWalkabilityBlocker(x + 16, y - 16, walkable)
    call CreateWalkabilityBlocker(x - 16, y + 16, walkable)
endfunction
function CreateLargeFlyabilityBlocker takes real x, real y, boolean flyable returns nothing
    call CreateFlyabilityBlocker(x + 16, y + 16, flyable)
    call CreateFlyabilityBlocker(x - 16, y - 16, flyable)
    call CreateFlyabilityBlocker(x + 16, y - 16, flyable)
    call CreateFlyabilityBlocker(x - 16, y + 16, flyable)
endfunction
function CreateLargeMoveabilityBlocker takes real x, real y, boolean moveable returns nothing
    call CreateWalkabilityBlocker(x + 16, y + 16, moveable)
    call CreateWalkabilityBlocker(x - 16, y - 16, moveable)
    call CreateWalkabilityBlocker(x + 16, y - 16, moveable)
    call CreateWalkabilityBlocker(x - 16, y + 16, moveable)
    call CreateFlyabilityBlocker(x + 16, y + 16, moveable)
    call CreateFlyabilityBlocker(x - 16, y - 16, moveable)
    call CreateFlyabilityBlocker(x + 16, y - 16, moveable)
    call CreateFlyabilityBlocker(x - 16, y + 16, moveable)
endfunction
