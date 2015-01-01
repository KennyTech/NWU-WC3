scope Sanshouuo

    define
        private PUPPET_ID = 'o00M'
        private AOE       = 900
        private BUFF_ID   = 'B033'
    enddefine
    
    public function DmgBlockDestroy takes unit u returns nothing
        call RemoveSavedBoolean(HT,GetHandleId(u),KEY_KANKURO_ULTI)
        call RemoveAbility(u,'A0KG')
        call UnitRemoveAbility(u,'B033')
    endfunction

    private function HasProtection takes unit u returns boolean
        return GetUnitAbilityLevel(u, BUFF_ID) > 0
    endfunction
    
    private function DmgBlockDestroyAll takes nothing returns nothing
        call DmgBlockDestroy(GetEnumUnit())
    endfunction
    
    public function Loop takes nothing returns nothing
        local timer t=GetExpiredTimer()
        local integer id=GetHandleId(t)
        local integer time=LoadInteger(HT,id,0)-1
        local unit puppet=LoadUnitHandle(HT,id,0)
        local group old=LoadGroupHandle(HT,id,1)
        local group new=LoadGroupHandle(HT,id,2)
        if time<= 0 or GetWidgetLife(puppet)<0.405 then
            // Fin del spell
            call ForGroup(old,function DmgBlockDestroyAll)
            call ReleaseGroup(old)
            call ReleaseGroup(new)
            call ReleaseTimer(t)
            call ShowUnit(puppet,false)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl",GetUnitX(puppet),GetUnitY(puppet)))
        else
            call GroupEnumUnitsInRange(ENUM,GetUnitX(puppet),GetUnitY(puppet),AOE,null)
            // Nuevos
            loop
                set enumUnit=FirstOfGroup(ENUM)
                exitwhen enumUnit==null
                call GroupRemoveUnit(ENUM,enumUnit)
                if GetWidgetLife(enumUnit)>0.405 and GetUnitTypeId(enumUnit)!=PUPPET_ID and GetUnitPointValue(enumUnit)!=201 and IsUnitAlly(enumUnit,GetOwningPlayer(puppet)) and IsUnitType(enumUnit,UNIT_TYPE_STRUCTURE)==false then
                    call AddAbility(enumUnit,'A0KG')
                    if HaveSavedBoolean(HT,GetHandleId(enumUnit),KEY_KANKURO_ULTI)==false then
                        call SaveBoolean(HT,GetHandleId(enumUnit),KEY_KANKURO_ULTI,true)
                    endif
                    call GroupAddUnit(new,enumUnit)
                endif
            endloop
            // Antiguos
            loop
                set enumUnit=FirstOfGroup(old)
                exitwhen enumUnit==null
                call GroupRemoveUnit(old,enumUnit)
                if IsUnitInGroup(enumUnit,new)==false then
                    call DmgBlockDestroy(enumUnit)
                endif
            endloop
            // Actualizacion
            call GroupClear(old)
            call SaveGroupHandle(HT,id,1,new)
            call SaveGroupHandle(HT,id,2,old)
        endif
        set t=null
        set new=null
        set old=null
        set puppet=null
    endfunction

    public function onSpell takes nothing returns boolean
        local unit u=GetTriggerUnit()
        local unit puppet=CreateUnit(GetTriggerPlayer(),PUPPET_ID,GetSpellTargetX(),GetSpellTargetY(),GetUnitFacing(u))
        local integer lvl=GetUnitAbilityLevel(u,'A082')
        local timer t=NewTimer()
        local integer id=GetHandleId(t)
        // Valores del Puppet
        call UnitApplyTimedLife(puppet,'BTLF',3+2*lvl)
        call SetUnitAnimation(puppet,"spell TWO")
        call SetUnitMaxState(puppet, UNIT_STATE_MAX_LIFE, R2I(GetUnitState(puppet,UNIT_STATE_MAX_LIFE))+(400*lvl)+(150*GetUnitAbilityLevel(u, 'A07K')))
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl",GetUnitX(puppet),GetUnitY(puppet)))
        // Guardamos valores
        call SaveInteger(HT,id,0,30+20*lvl)
        call SaveAgentHandle(HT,id,0,puppet)
        call SaveAgentHandle(HT,id,1,CreateGroup())
        call SaveAgentHandle(HT,id,2,CreateGroup())
        call TimerStart(t,0.1,true,function Loop)
        set u=null
        set t=null
        set puppet=null
        return false
    endfunction
    
    private void onDamage(unit target,unit source,real damage){
        if(HasProtection(target)){

            Damage_BlockAll()

            // Search puppet and damage it

            GroupEnumUnitsInRange(ENUM, GetUnitX(target), GetUnitY(target), AOE, null)

            loop
                unit puppet = FirstOfGroup(ENUM)
                exitwhen puppet == null
                GroupRemoveUnit(ENUM, puppet)
                if(GetUnitTypeId(puppet) == PUPPET_ID && isUnitAlive(puppet) && !IsUnitHidden(puppet)){
                    Damage_Pure(source, puppet, RAbsBJ(damage))
                    exitwhen true
                }
            endloop

            puppet = null
        }
    }

    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('A082',function onSpell)
        call AbilityPreload('A0KG')
        call Damage_Register(onDamage)
    endfunction

endscope