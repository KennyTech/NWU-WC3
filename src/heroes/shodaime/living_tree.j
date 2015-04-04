scope LivingTree

  define
    private ABIL_ID = 'A0EQ'
  enddefine

    private function LivingTreeTimedRemove takes nothing returns nothing
        call RemoveUnit(GetHandleUnit(GetHandleId(GetExpiredTimer()),"LivingTree"))
        call ReleaseTimerEx()
    endfunction

    private function onTreeDead takes nothing returns boolean
        local trigger Trigger = GetTriggeringTrigger()
        local integer id=GetHandleId(Trigger)
        if GetWidgetLife(GetHandleUnit(id,"LivingTree")) > 0.405 then
            call KillUnit(GetHandleUnit(id,"LivingTree"))
        endif
        if GetHandleEffect(id,"Effect") != null then
            call DestroyEffect(GetHandleEffect(id,"Effect") )
        endif
        call Clear(Trigger)
        call DisableTrigger(Trigger)
        call DestroyTrigger(Trigger)
        set Trigger = null
        return false
    endfunction
    
    private function onUnitDead takes nothing returns boolean
        local trigger Trigger = GetTriggeringTrigger()
        local timer Timer = NewTimer()
        call SetHandleHandle(GetHandleId(Timer),"LivingTree",GetTriggerUnit())
        call TimerStart(Timer,5,false,function LivingTreeTimedRemove)
        call PauseUnit(GetTriggerUnit(),true)
        if GetHandleEffect(GetHandleId(Trigger),"Effect") != null then
            call DestroyEffect(GetHandleEffect(GetHandleId(Trigger),"Effect") )
        endif
        call Clear(Trigger)
        call TriggerClearConditions(Trigger)
        call DisableTrigger(Trigger)
        call DestroyTrigger(Trigger)
        set Trigger = null
        return false
    endfunction

    private function LivingTreeFunc takes nothing returns nothing
       local trigger Trigger
       local destructable Tree = GetEnumDestructable()
       local unit LivingTree
       local unit Caster
       local real X
       local real Y
       local effect Effect
       local integer id
       
       if GetDestructableLife(Tree) > 0 and IsDestructableTree(Tree) then
          set Caster = GetTriggerUnit()
          set X = GetDestructableX(Tree)
          set Y = GetDestructableY(Tree)
          set Effect = AddSpecialEffect("Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl",X,Y)

          set LivingTree = CreateUnit(GetOwningPlayer(Caster),'n010',X,Y,bj_UNIT_FACING )
          call UnitApplyTimedLife( LivingTree, 'BTLF',7 )
          call SetUnitPathing( LivingTree, false )
          call SetUnitX( LivingTree, X )
          call SetUnitY( LivingTree, Y )
          call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl",X,Y))
          
          // para la muerte de la unidad
          set Trigger = CreateTrigger()
          set id=GetHandleId(Trigger)
          call TriggerRegisterUnitEvent( Trigger, LivingTree, EVENT_UNIT_DEATH )
          call TriggerAddCondition( Trigger,Condition(function onUnitDead))
          call SetHandleHandle(id,"Effect",Effect)
          
          // para la muerte del arbol
          set Trigger = CreateTrigger()
          set id=GetHandleId(Trigger)
          call TriggerRegisterDeathEvent( Trigger, Tree )
          call TriggerAddCondition( Trigger,Condition(function onTreeDead))
          call SetHandleHandle(id,"LivingTree",LivingTree)
          call SetHandleHandle(id,"Effect",Effect)
          
          set Trigger = null
          set Caster = null
          set LivingTree = null
       endif
    endfunction

    private function onCast takes nothing returns boolean
        call EnumDestructablesInCircle(220+70*GetUnitAbilityLevel(GetTriggerUnit(),GetSpellAbilityId()), GetSpellTargetX(),GetSpellTargetY(),function LivingTreeFunc)
        return false
    endfunction
    
    public function Init takes nothing returns nothing
      call SpellCast(ABIL_ID)
    endfunction
endscope