scope Dogs
    
    public function onSpell takes nothing returns boolean
        local spell s=GetTriggerSpell()
        set s.dummy=CreateUnit(s.owner,'h008',s.casterX,s.casterY,GetUnitFacing(s.caster))
        call SetUnitPathing(s.dummy,false)
        call FlyTrick(s.dummy)
        call SetUnitFlyHeight( s.dummy,100,0)
        call CreateProjTarget(s.caster,s.dummy,s.target,1000,0,true,false,40,0,0,onHitRemoveFX,0)
        if UnitAbsorbSpell(s.target)==true then
           call IssuePointOrderById(s.caster, 851983,s.casterX,s.casterY )
        endif
        call s.destroy()
        return false
    endfunction
    
    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('A00I',function onSpell)
    endfunction
endscope