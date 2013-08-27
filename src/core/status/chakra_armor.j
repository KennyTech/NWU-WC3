library ChakraArmor initializer init requires TimerUtils,Effect 

    globals
        private constant string COOLDOWN="CA|Cooldown"
    endglobals

    private function AddBuff takes unit whichUnit returns nothing
        call SetUnitAbilityLevel(whichUnit,'A0IF',1) 
        call UnitMakeAbilityPermanent(whichUnit,true,'A0JH')
    endfunction
    
    private function RemoveBuff takes unit whichUnit returns nothing
        call UnitMakeAbilityPermanent(whichUnit,false,'A0JH')
        call SetUnitAbilityLevel(whichUnit,'A0IF',2)
        call UnitRemoveAbility(whichUnit,'B01Z')
    endfunction
    
    private function onItemAdd takes unit whichUnit returns nothing
        if GetUnitAbilityLevel(whichUnit,'A0IF')==0 then
            call UnitAddAbility(whichUnit,'A0IF')
            call UnitMakeAbilityPermanent(whichUnit,true,'A0IF')
            call UnitMakeAbilityPermanent(whichUnit,true,'A0JH')
            if GetHandleBoolean(GetHandleId(whichUnit),COOLDOWN) then
                call RemoveBuff(whichUnit)
            endif
        endif
    endfunction
    
    private function onItemRemove takes unit whichUnit returns nothing
        if CountItemsOfTypeById(whichUnit,'I03N') <= 1 then
            call UnitMakeAbilityPermanent(whichUnit,false,'A0IF')
            call UnitMakeAbilityPermanent(whichUnit,false,'A0JH')
            call UnitRemoveAbility(whichUnit,'A0IF')
            call UnitRemoveAbility(whichUnit,'B01Z')
        endif
    endfunction
    
    private function Refresh takes nothing returns nothing
        local unit u=GetTimerUnit()
        local integer id=GetHandleId(u)
        if GetUnitTypeId(u)=='n01J' then
            call SaveBoolean(HT,id,200,true)
        else
            if CountItemsOfTypeById(u,'I03N')>=1 then
                call AddBuff(u)
            endif
            call SetHandleBoolean(id,COOLDOWN,false)
        endif
        call ReleaseTimerEx()
        set u=null
    endfunction

    function UnitAbsorbSpell takes unit whichUnit returns boolean
        local integer id
        if IsUnitIllusion(whichUnit)==false and GetUnitAbilityLevel(whichUnit,'B01Z')>0 then
            call RemoveBuff(whichUnit)
            call AddSpecialEffectTimed(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCasterOverhead.mdl",whichUnit, "overhead"),3)
            call SetHandleBoolean(GetHandleId(whichUnit),COOLDOWN,true)
            call TimerStart(NewTimerUnit(whichUnit),20,false,function Refresh)
            return true
        endif
        if GetUnitTypeId(whichUnit)=='n01J' then// Kyuubi
            set id=GetHandleId(whichUnit)
            if HaveSavedBoolean(HT,id,200)==false then
                call SaveBoolean(HT,id,200,true)
            endif
            if LoadBoolean(HT,id,200)==true then
                call SaveBoolean(HT,id,200,false)
                call TimerStart(NewTimerUnit(whichUnit),15,false,function Refresh) 
            endif
        endif
        return false
    endfunction
    
    private function onPick takes nothing returns boolean
        if GetItemTypeId(GetManipulatedItem()) == 'I03N' then
            call onItemAdd(GetTriggerUnit())
		endif
		return false
    endfunction
    
    private function onDrop takes nothing returns boolean
        if GetItemTypeId(GetManipulatedItem()) == 'I03N' then
            call onItemRemove(GetTriggerUnit())
		endif
		return false
    endfunction

    private function init takes nothing returns nothing
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_PICKUP_ITEM,function onPick)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DROP_ITEM,function onDrop)
    endfunction

endlibrary