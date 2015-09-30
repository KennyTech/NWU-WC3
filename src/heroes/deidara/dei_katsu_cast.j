scope DeiKatsuCast

    globals
        private constant integer SPELL_ID   = 'CW62'
        private constant integer BUFF_ID    = 'BK14'
        private constant integer STUN_ID    = 'CW69'
        private constant integer DUMMY_ID1  = 'cw99'
        private constant string SFX         = "Abilities\\Weapons\\SteamTank\\SteamTankImpact.mdl" 
        //private constant string SFX       = "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl" // Alternate SFX
        //private constant string SFX       = "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl" // Alternate SFX
    endglobals
    
    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction
    
    private function Actions takes nothing returns nothing
        local unit c = GetTriggerUnit()
        local unit u
        local group g = CreateGroup()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local player p = GetOwningPlayer(c)
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local unit dummy
        
        call GroupEnumUnitsInRange(g,x,y,2000,null)
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            // Explode enemy affected with Clay Counter 
            if IsUnitEnemy(u,p) and IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) == false and IsUnitType(u,UNIT_TYPE_DEAD)==false and GetUnitAbilityLevel(u, BUFF_ID) > 0 then                
                call UnitDamageTarget(c,u,(30*level), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call UnitRemoveAbility(u, BUFF_ID)
                call DestroyEffect(AddSpecialEffect(SFX,GetUnitX(u),GetUnitY(u)))
                
                set dummy = CreateUnit(GetOwningPlayer(c), DUMMY_ID1, GetUnitX(u), GetUnitY(u), 0)
                call UnitApplyTimedLife(dummy,'BTLF',0.5)
                call UnitAddAbility(dummy, STUN_ID)
                call SetUnitAbilityLevel(dummy, STUN_ID, level)
                call IssueTargetOrder(dummy, "creepthunderbolt", u)
            endif
            
            // Force detonate mines
            if GetUnitTypeId(u) == 'cw11' or GetUnitTypeId(u) == 'cw12' or GetUnitTypeId(u) == 'cw13' or GetUnitTypeId(u) == 'cw14' and GetOwningPlayer(u) == p then 
                call KillUnit(u)
            endif
            
            call GroupRemoveUnit(g, u)
        endloop
        
        set p = null
        set u = null
        set g = null
        set c = null
        set dummy = null
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
