library Spells requires ChakraArmor,TimerUtils
{

    boolean AreUnitEnemies(unit u1, unit u2){
        return IsPlayerEnemy(GetOwningPlayer(u1), GetOwningPlayer(u2))
    }

    boolean Spells_Cancel(){
        if (UnitAbsorbSpell(GetSpellTargetUnit())) {
           call IssuePointOrderById(GetTriggerUnit(), 851983, GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
           return true
        }
        return false
    }
    
    boolean LoopNull(){
        set enumUnit = FirstOfGroup(ENUM);
        if enumUnit == null then
            return true
        else
            call GroupRemoveUnit(ENUM,enumUnit)
            return false
        endif
    }
    
//*****************************************
//  Wrappers
//*****************************************
    define MaxHp(u) = GetUnitState(u,UNIT_STATE_MAX_LIFE)
    define MaxHP(u) = GetUnitState(u,UNIT_STATE_MAX_LIFE)
    define maxHp(u) = GetUnitState(u,UNIT_STATE_MAX_LIFE)
    define maxHP(u) = GetUnitState(u,UNIT_STATE_MAX_LIFE)
    
    define GetHp(u) = GetWidgetLife(u)
    define GetHP(u) = GetWidgetLife(u)
    define getHp(u) = GetWidgetLife(u)
    define getHP(u) = GetWidgetLife(u)
    
    define GetMp(u) = GetUnitState(u,UNIT_STATE_MANA)
    define GetMP(u) = GetUnitState(u,UNIT_STATE_MANA)
    define getMp(u) = GetUnitState(u,UNIT_STATE_MANA)
    define getMP(u) = GetUnitState(u,UNIT_STATE_MANA)
    
    define MaxMp(u) = GetUnitState(u,UNIT_STATE_MAX_MANA)
    define MaxMP(u) = GetUnitState(u,UNIT_STATE_MAX_MANA)
    define maxMp(u) = GetUnitState(u,UNIT_STATE_MAX_MANA)
    define maxMP(u) = GetUnitState(u,UNIT_STATE_MAX_MANA)
    
    define addHp(u,v)    = SetWidgetLife(u,GetWidgetLife(u)+v)
    define addHp(u,v)    = SetWidgetLife(u,GetWidgetLife(u)+v)
    define removeHP(u,v) = SetWidgetLife(u,GetWidgetLife(u)-v)
    define removeHP(u,v) = SetWidgetLife(u,GetWidgetLife(u)-v)
    define addMp(u,v)    = SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)+v)
    define addMP(u,v)    = SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)+v)
    define removeMp(u,v) = SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)-v)
    define removeMP(u,v) = SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MANA)-v)


    /**
     * Sometimes you need a delay to add mana
     */

    private void addMpDelayedaCallback(){
        timer t = GetExpiredTimer()
        integer h = GetHandleId(t)
        addMp(GetUnit(h,0),GetReal(h,0))
        ReleaseTimer(t)
    }

    /**
     * Add MP to a Unit with a 0 delay time. It can be used when you have to add mana to trigger unit in a SpellCallback
     * normal adding doesn't seems to work.
     */
    void addMpDelayed(unit u,real mp){
        timer t = NewTimer()
        integer h = GetHandleId(t)
        SetUnit(h,0,u)
        SetReal(h,0,mp)
        TimerStart(t,0,false,function addMpDelayedaCallback)
    }
    
//*****************************************
//  Damage AOE Module
//*****************************************

    function FiltSafe takes nothing returns boolean
        return true
    endfunction

    function UnitDamageTargetByType takes unit u,unit m,real dmg,integer DamageType returns nothing
        if DamageType == DAMAGE_FISICO then
            call Damage_Physical(u,m,dmg)
        elseif DamageType == DAMAGE_SPELL then
            call Damage_Spell(u,m,dmg)
        elseif DamageType == DAMAGE_PURE then
            call Damage_Pure(u,m,dmg)
        endif
    endfunction

    function UnitDamageArea takes unit u,real x,real y,real r,real damage,integer DamageType,string FX returns nothing
        local unit m
        call GroupEnumUnitsInRange(ENUM,x,y,r,null)
        loop
            set m = FirstOfGroup(ENUM)
            exitwhen m==null
            static if DEBUG_MODE then
                if IsUnitType(m, UNIT_TYPE_DEAD)==false and IsUnitType(m,UNIT_TYPE_STRUCTURE)==false then
                    call UnitDamageTargetByType(u,m,damage,DamageType)
                    if StringLength(FX)>0 then
                        call DestroyEffect(AddSpecialEffectTarget(FX,m,"chest"))
                    endif
                endif
            else
                if IsUnitType(m, UNIT_TYPE_DEAD)==false and IsUnitEnemy(m,GetOwningPlayer(u)) and IsUnitType(m,UNIT_TYPE_STRUCTURE)==false then
                    call UnitDamageTargetByType(u,m,damage,DamageType)
                    if StringLength(FX)>0 then
                        call DestroyEffect(AddSpecialEffectTarget(FX,m,"chest"))
                    endif
                endif
            endif
            call GroupRemoveUnit(ENUM,m)
        endloop
        call GroupClear(ENUM)
    endfunction
    
    define {
        DamageArea(u,x,y,r,damage,FX) = UnitDamageArea(u,x,y,r,damage,DAMAGE_SPELL,FX)
        DamageArea(u,x,y,r,damage) = UnitDamageArea(u,x,y,r,damage,DAMAGE_SPELL,null);
    }
    
    function UnitDamageStunArea takes unit u,real x,real y,real r,real damage,integer DamageType,string FX,real time returns nothing
        local unit m
        call GroupEnumUnitsInRange(ENUM,x,y,r,null)
        loop
            set m = FirstOfGroup(ENUM)
            exitwhen m==null
            static if TEST_MODE then
                if IsUnitType(m, UNIT_TYPE_DEAD)==false and IsUnitType(m,UNIT_TYPE_STRUCTURE)==false and IsUnitTypeWard(m)==false and UnitFilter(m) then
                    if StringLength(FX)>0 then
                        call DestroyEffect(AddSpecialEffectTarget(FX,m,"chest"))
                    endif
                    if UnitFilter(m) then
                        call AddStunTimed(m,time)
                    endif
                    call UnitDamageTargetByType(u,m,damage,DamageType)
                endif
            else
                if IsUnitType(m, UNIT_TYPE_DEAD)==false and IsUnitEnemy(m,GetOwningPlayer(u)) and IsUnitType(m,UNIT_TYPE_STRUCTURE)==false and IsUnitTypeWard(m)==false then
                    if StringLength(FX)>0 then
                        call DestroyEffect(AddSpecialEffectTarget(FX,m,"chest"))
                    endif
                    if UnitFilter(m) then
                        call AddStunTimed(m,time)
                    endif
                    call UnitDamageTargetByType(u,m,damage,DamageType)
                endif
            endif
            call GroupRemoveUnit(ENUM,m)
        endloop
        call GroupClear(ENUM)
    endfunction


/*function UnitDamageArea takes unit u, real x, real y, real radius, real damage, attacktype at, damagetype dt, weapontype wt, string FX returns nothing
    local group g  = CreateGroup()
    local unit dum
    local boolexpr b = Condition(function FiltSafe)

    call GroupEnumUnitsInRange(g,x,y,radius,b)

    loop
        set dum = FirstOfGroup(g)
        exitwhen dum == null

        if IsUnitType(dum, UNIT_TYPE_DEAD)==false and IsUnitAlly(dum,GetOwningPlayer(u))==false and IsUnitType(dum,UNIT_TYPE_STRUCTURE)==false then
           if dt==DAMAGE_TYPE_NORMAL then
               call Damage_Physical(u,dum,damage,at,true,false)
           else
               call Damage_Spell(u,dum,damage)
           endif
           if FX!=null then
              call DestroyEffect(AddSpecialEffectTarget(FX, dum,"chest"))
           endif
        endif
        call GroupRemoveUnit(g,dum)
    endloop
    
    call DestroyGroup(g)
    set dum = null
    set g = null
    set b = null
endfunction*/

/*----------------------------------------------------------------------------------------------------
  2. UnitDamageAreaEx
    Powerfull than UnitDamageArea, it is able to cast a @abilId on the filter units. 
----------------------------------------------------------------------------------------------------*/

    /*nothing UnitDamageAreaEx(unit source,real x,real y,real range,real damage,integer DamageType,integer abilId,integer abilLevel,integer order,group g,sfx){
        GroupEnumUnitsInRange(ENUM,x,y,range,null);
        enumUnit = FirstOfGroup(ENUM);
        whilenot(enumUnit == null) {
            call GroupRemoveUnit(ENUM,enumUnit);
        }
    }*/

function UnitDamageAreaSfx takes unit source,real x,real y,real range,real damage,integer DamageType,integer abilId,integer abilLevel,integer order,group g,string sfx returns nothing
    if g==ENUM then
        debug call BJDebugMsg("g==ENUM")
    endif
    call GroupEnumUnitsInRange(ENUM,x,y,range,null)
    loop
        set enumUnit=FirstOfGroup(ENUM)
        exitwhen enumUnit==null
        call GroupRemoveUnit(ENUM,enumUnit)
        static if DEBUG_MODE then
            if (g==null or IsUnitInGroup(enumUnit,g)==false) then
                if abilId>0 and UnitFilter(enumUnit) then
                    call CasterCast(enumUnit,abilId,order,abilLevel)
                endif
                if sfx!=null and sfx!="" then
                    call DestroyEffect(AddSpecialEffectTarget(sfx,enumUnit,"chest"))
                endif
                if g!=null then
                    call GroupAddUnit(g,enumUnit)
                endif
                call UnitDamageTargetByType(source,enumUnit,damage,DamageType)
            endif
        else
            if IsUnitAlly(enumUnit,GetOwningPlayer(source))==false and UnitFilter(enumUnit)==true and (g==null or IsUnitInGroup(enumUnit,g)==false) then
                if abilId>0 and UnitFilter(enumUnit) then
                    call CasterCast(enumUnit,abilId,order,abilLevel)
                endif
                if sfx!=null and sfx!="" then
                    call DestroyEffect(AddSpecialEffectTarget(sfx,enumUnit,"chest"))
                endif
                if g!=null then
                    call GroupAddUnit(g,enumUnit)
                endif
                call UnitDamageTargetByType(source,enumUnit,damage,DamageType)
            endif
        endif
    endloop
    call GroupClear(ENUM)
endfunction

    define{
        DamageAreaEx(u,x,y,r,damage,damage_type,abil_id,abil_level,abil_order,g,sfx) = UnitDamageAreaSfx(u,x,y,r,damage,damage_type,abil_id,abil_level,abil_order,g,sfx)
        DamageAreaEx(u,x,y,r,damage,abil_id,abil_order) = UnitDamageAreaSfx(u,x,y,r,damage,DAMAGE_SPELL,abil_id,1,abil_order,null,null)
        DamageAreaEx(u,x,y,r,damage,abil_id,abil_level,abil_order) = UnitDamageAreaSfx(u,x,y,r,damage,DAMAGE_SPELL,abil_id,abil_level,abil_order,null,null)
        DamageAreaEx(u,x,y,r,damage,abil_id,abil_level,abil_order,g) = UnitDamageAreaSfx(u,x,y,r,damage,DAMAGE_SPELL,abil_id,abil_level,abil_order,g,null)
        DamageAreaEx(u,x,y,r,damage,abil_id,abil_level,abil_order,sfx,g) = UnitDamageAreaSfx(u,x,y,r,damage,DAMAGE_SPELL,abil_id,abil_level,abil_order,g,sfx)
    }

function UnitDamageAndEffectArea takes unit u, real x, real y, real radius, real damage, attacktype at, damagetype dt, integer Spell, integer SpellLVL, integer SpellId, group g2, string FX ,boolean UseChakra returns nothing
    local group g  = CreateGroup()
    local unit dum
    local unit Dummy
    local boolexpr b = Condition(function FiltSafe)

    call GroupEnumUnitsInRange(ENUM,x,y,radius,b)

    loop
        set dum = FirstOfGroup(ENUM)
        exitwhen dum == null
        static if DEBUG_MODE then
            if UnitFilter(dum) and IsUnitType(dum, UNIT_TYPE_DEAD)==false and IsUnitType(dum,UNIT_TYPE_STRUCTURE)==false and (g2==null or IsUnitInGroup(dum,g2)==false) then
               //if UseChakra==false or UnitAbsorbSpell(dum)==false then
                  if Spell != null then
                     set Dummy = CreateUnit(GetOwningPlayer(u),'h012', GetUnitX(dum),GetUnitY(dum), 0)
                     call UnitAddAbility( Dummy, Spell )
                     call SetUnitAbilityLevel( Dummy, Spell, SpellLVL )
                     call IssueTargetOrderById( Dummy, SpellId, dum )
                     call UnitApplyTimedLife( Dummy, 'BTLF', 10 )
                     call ShowUnit( Dummy, false )
                     set Dummy = null
                  endif
                  if damage!=0 then
                       if dt==DAMAGE_TYPE_NORMAL then
                           call Damage_Physical(u,dum,damage)
                       else
                            call Damage_Spell(u,dum,damage)
                       endif
                  endif

                  if FX!=null then
                     call DestroyEffect(AddSpecialEffectTarget(FX, dum,"chest"))
                  endif
              // endif
               call GroupAddUnit( g2,dum )
            endif
        else
            if UnitFilter(dum) and IsUnitType(dum, UNIT_TYPE_DEAD)==false and IsUnitAlly(dum,GetOwningPlayer(u))==false and IsUnitType(dum,UNIT_TYPE_STRUCTURE)==false and (g2==null or IsUnitInGroup(dum,g2)==false) then
               //if UseChakra==false or UnitAbsorbSpell(dum)==false then
                  if Spell != null then
                     set Dummy = CreateUnit(GetOwningPlayer(u),'h012', GetUnitX(dum),GetUnitY(dum), 0)
                     call UnitAddAbility( Dummy, Spell )
                     call SetUnitAbilityLevel( Dummy, Spell, SpellLVL )
                     call IssueTargetOrderById( Dummy, SpellId, dum )
                     call UnitApplyTimedLife( Dummy, 'BTLF', 10 )
                     call ShowUnit( Dummy, false )
                     set Dummy = null
                  endif
                  if damage!=0 then
                       if dt==DAMAGE_TYPE_NORMAL then
                           call Damage_Physical(u,dum,damage)
                       else
                            call Damage_Spell(u,dum,damage)
                       endif
                  endif

                  if FX!=null then
                     call DestroyEffect(AddSpecialEffectTarget(FX, dum,"chest"))
                  endif
              // endif
               call GroupAddUnit( g2,dum )
            endif
        endif
        call GroupRemoveUnit(ENUM,dum)
    endloop
    set dum = null
    set b = null
endfunction


//*****************************************
//  Abilitites Module
//*****************************************

  private function UnitAddAbilityTimedEnd takes nothing returns nothing
        local unit u=GetTimerUnit()
        local integer abil=GetTimerDataEx()
        if u==null then
            static if TEST_MODE then
                call BJDebugMsg("UnitAddAbilityTimedEnd - Null Unit")
            endif
        else
            call UnitMakeAbilityPermanent(u,false,abil)
            call UnitRemoveAbility(u,abil)
        endif
        call ReleaseTimerEx()
        set u=null
    endfunction
    
    function UnitAddAbilityTimed takes unit u,integer abil,real time returns nothing
        local timer t=NewTimerUnit(u)
        call SetTimerData(t,abil)
        call UnitAddAbility(u,abil)
        call UnitMakeAbilityPermanent(u,true,abil)
        call TimerStart(t,time,false,function UnitAddAbilityTimedEnd)
        //call BJDebugMsg("TIEMPO")
        //call BJDebugMsg(R2S(time))
        set t=null
        set u=null
    endfunction
    
    function RemoveAbility takes unit u,integer i returns nothing
        call UnitMakeAbilityPermanent(u,false,i)
        call UnitRemoveAbility(u,i)
    endfunction
    
    function AddAbility takes unit u,integer i returns nothing
        if GetUnitAbilityLevel(u,i)==0 then
            call UnitAddAbility(u,i)
            call UnitMakeAbilityPermanent(u,true,i)
        endif
    endfunction
    
    function RemoveNegativeBuffs takes unit u returns nothing
        //-----------------------
        // Remover Onoki's
        call UnitMakeAbilityPermanent(u,false,'A10T')
        call UnitRemoveAbility(u,'A10T')
        call UnitRemoveAbility(u,'B10B')
        //-----------------------
        // Mizukage's Cloud
        call RemoveAbility(u,MR_MIZUKAGE_SPELLBOOK)
        //-----------------------
        // Itachi's Ulti
        //call UnitMakeAbilityPermanent(u,false,'A021')
        //call UnitRemoveAbility( u,'A021' )
        //-----------------------
        // Kabuto's heal
        if GetUnitAbilityLevel(u,'A059')>0 then
            call UnitRemoveAbility(u,'B00Z')
        endif
    endfunction
    
    define addAbilityTimed(u,a,t) = UnitAddAbilityTimed(u,a,t)
    define AddAbilityTimed(u,a,t) = UnitAddAbilityTimed(u,a,t)

}