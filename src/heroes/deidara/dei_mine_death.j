scope DeiMineDeath

    globals
        private constant integer DUMMY_ID1  = 'cw99'
        private constant integer SLOW_ID    = 'CW65'
        private constant integer BUFF_ID    = 'BK13'
        private constant integer BOOM_AOE   = 250 // Boom activation is 200 in Object Editor 'cw64'
        private constant string SFX         = "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl"
        private constant hashtable HT       = InitHashtable()
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetUnitTypeId(GetDyingUnit()) == 'cw11' or GetUnitTypeId(GetDyingUnit()) == 'cw12' or GetUnitTypeId(GetDyingUnit()) == 'cw13' or GetUnitTypeId(GetDyingUnit()) == 'cw14'
    endfunction
    
    private function TreeFilter takes nothing returns boolean
        local integer d = GetDestructableTypeId(GetFilterDestructable()) // Filter all trees for killing
        return d=='LTlt' or d=='VTlt' or d=='ATtr' or d=='ATtc' or d=='BTtw' or d=='BTtc' or d=='ZTtw' or d=='ZTtc' or d=='FTtw'
    endfunction

    private function KillTree takes nothing returns nothing
        call KillDestructable(GetEnumDestructable())
    endfunction

    private function Actions takes nothing returns nothing
        local unit d = GetDyingUnit()
        local real x = GetUnitX(d)
        local real y = GetUnitY(d)
        local unit u
        local group g = CreateGroup()
        local unit dummy 
        local player p = GetOwningPlayer(d)
        local integer level 
        local rect r
        local boolexpr local_boolean
        
        if GetUnitTypeId(GetDyingUnit()) == 'cw11' then
            set level = 1
        elseif GetUnitTypeId(GetDyingUnit()) == 'cw12' then
            set level = 2
        elseif GetUnitTypeId(GetDyingUnit()) == 'cw13' then
            set level = 3
        elseif GetUnitTypeId(GetDyingUnit()) == 'cw14' then
            set level = 4
        endif
        
        // SFX
        call DestroyEffect(AddSpecialEffect(SFX,x,y))
        call ExplodeSFX(x,y)
        
        // Boom Damage + Slow
        call GroupEnumUnitsInRange(g,x,y,BOOM_AOE,null)
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false and IsUnitType(u,UNIT_TYPE_DEAD)==false then                
                if GetUnitAbilityLevel(u, BUFF_ID) == 0 then
                    call Damage_Spell(d,u,(30*level))
                else
                    call Damage_Spell(d,u,(15*level))
                endif
            //elseif IsUnitEnemy(u,p) and IsUnitType(u,UNIT_TYPE_STRUCTURE)==true and IsUnitType(u,UNIT_TYPE_DEAD)==false then
            //    call Damage_Spell(d,u,(7.5*level))
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        set dummy = CreateUnit(p, DUMMY_ID1, x, y, 0)
        call UnitApplyTimedLife(dummy,'BTLF',0.5)
        call UnitAddAbility(dummy, SLOW_ID)
        call SetUnitAbilityLevel(dummy, SLOW_ID, level)
        call IssueImmediateOrder(dummy, "thunderclap")

        // Now we kill trees in range //
        set r = Rect(x-(BOOM_AOE-50),y-(BOOM_AOE-50),x+(BOOM_AOE-50),y+(BOOM_AOE-50)) 
        set local_boolean = Filter(function TreeFilter)
        call EnumDestructablesInRect(r,local_boolean, function KillTree) 
        call RemoveRect(r)
        call DestroyBoolExpr(local_boolean)
    
    set d = null
    set u = null
    set g = null
    set dummy = null
    set p = null
    set r = null
    endfunction
    
    //=== Event ========================================================================
    public function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddCondition(t,Condition(function Conditions))
        call TriggerAddAction(t,function Actions)
        set t = null
    endfunction

endscope
