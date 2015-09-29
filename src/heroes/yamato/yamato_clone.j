scope YamatoClone
    private function onCast takes nothing returns boolean
       local unit Caster = GetTriggerUnit()
       local integer SpellLVL = GetUnitAbilityLevel(Caster,'A0H4')
       local unit Dummy = CreateUnit(GetOwningPlayer(Caster),'h012',GetUnitX(Caster),GetUnitY(Caster),0)
       call UnitApplyTimedLife( Dummy, 'BTLF', 1 )
       call UnitAddAbility(Dummy,'A01H')
       call SetUnitAbilityLevel(Dummy,'A01H',GetUnitAbilityLevel(Caster,'A0AC'))
       call IssueTargetOrderById(Dummy,852274,Caster)
       set Dummy = null
       set Caster = null
       return false
    endfunction
    
    public function Init takes nothing returns nothing
        call SpellReg('A0AC')
        call AbilityPreload('A01H')
    endfunction
endscope