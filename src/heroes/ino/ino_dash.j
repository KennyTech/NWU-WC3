scope InoDash
    
    private function onHit takes proj this returns nothing
        call SetUnitVertexColor( this.caster, 255, 255, 255, 255 )
        call SetUnitPathing( this.caster, true )
        call UnitRemoveInmunity( this.caster )
    endfunction
    
    private function onLoopEnum takes proj this,unit m returns nothing
        static if DEBUG_MODE then
            if (IsUnitInGroup(m,this.damaged) == false) and (UnitFilter(m)) then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", m, "chest"))
                call Damage_Spell(this.caster,m,this.damage)
                call GroupAddUnit(this.damaged,m) 
            endif
        else
            if (IsUnitEnemy(m,this.owner)) and (IsUnitInGroup(m,this.damaged) == false) and (UnitFilter(m)) then
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", m, "chest"))
                call Damage_Spell(this.caster,m,this.damage)
                call GroupAddUnit(this.damaged,m) 
            endif
        endif
    endfunction
    
    private function onLoop takes proj this returns nothing
        call DestroyEffect(AddSpecialEffect("war3mapImported\\Ino_Petals.mdx",this.x,this.y))
        if GetWidgetLife(this.caster) < 0.405 then
            call UnitRemoveInmunity(this.caster)
            call this.Stop()
        endif
    endfunction
    
    private function onSpell takes nothing returns boolean
        local proj this
        local real x=GetSpellTargetX()
        local real y=GetSpellTargetY()
        local unit u=GetTriggerUnit()
        local integer id=GetSpellAbilityId()
        
            if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_CAST then
               if (IsTerrainPathable(x,y,PATHING_TYPE_WALKABILITY) == true) then
                  call PauseUnit(u,true)
                  call IssueImmediateOrder(u, "stop")
                  call PauseUnit(u,false)
               endif
            else
               if GetSpellTargetUnit()!=null then
                   set x = GetUnitX(GetSpellTargetUnit())
                   set y = GetUnitY(GetSpellTargetUnit())
               endif
               call SetUnitVertexColor( u, 255, 255, 255, 0 )
               call SetUnitPathing( u, false )
               set this=CreateProj(u,u,x,y,0,1750,0,true,onLoop,onLoopEnum,onHit,0)
               set this.damage = 50*(GetUnitAbilityLevel(u,id))
            endif
       
        call UnitAddInmunity(u)
       
        // Recharge Kunai
        if GetUnitAbilityLevel(u, 'CW74')>0 then
        call UnitRemoveAbility(u, 'CW70')
        call UnitRemoveAbility(u, 'CW71')
        call UnitRemoveAbility(u, 'CW73')
        call UnitRemoveAbility(u, 'CW72')
        call UnitRemoveAbility(u, 'A0LP')
        call UnitAddAbility(u, 'A0LQ')
        call SetUnitAbilityLevel(u, 'A0LQ', GetUnitAbilityLevel(u,'CW74'))
        endif
        
        set u=null
        return false
    endfunction
    
    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('A0LO',function onSpell)
    endfunction
    
endscope
