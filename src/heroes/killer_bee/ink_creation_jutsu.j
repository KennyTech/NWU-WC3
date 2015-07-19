scope KBInkCreation initializer Init

    globals
        private constant integer SPELL_ID   = 'CW01' // ID of ability: "Killer Bee - Ink Creation Jutsu"
        private constant integer SFX_ID     = 'CW05' // ID of ability: Cluster Rockets (Ink Creation)
        private constant integer DUST_ID    = 'CW06' // ID of ability: "Killer Bee - Dust" (Ink)
        private constant integer ULT_ID     = 'CW07' 
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == SPELL_ID
    endfunction

    private function EnemyFilter takes nothing returns boolean
        return IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE) == false and IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE) == false
    endfunction
   
    private function Actions takes nothing returns nothing // Visuals, ability effect already hardcoded (howl of terror)
        local unit c = GetTriggerUnit()
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local location loc = GetUnitLoc(c)
        local unit d // dummy
        local group g = CreateGroup()
        local unit u 
        local integer n = 0
        local integer level = GetUnitAbilityLevel(c, SPELL_ID)
        local integer ult_level = GetUnitAbilityLevel(c, ULT_ID)
        local texttag tt = CreateTextTag()
        local real heal_amt = 0
        
        set d = CreateUnit(GetOwningPlayer(c), NORMAL_DUMMY_ID, x, y, 0)
        call SetUnitVertexColor(d,255,255,255,0)
        call UnitApplyTimedLife(d,'BTLF',1.0)
        call UnitAddAbility(d, SFX_ID)
        call UnitAddAbility(d, DUST_ID)
        call IssueImmediateOrderById(d, 852625) // Dust Ability Order ID
        call IssuePointOrder(d, "clusterrockets", x, y) // SX - no damage (ink balls visual)
        
        call GroupEnumUnitsInRange(g,x,y,400,function EnemyFilter)
        loop
            set u = FirstOfGroup(g)
        exitwhen u == null
            if IsUnitEnemy(u,GetOwningPlayer(c)) then
                set n = n + 1
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        set heal_amt = GetUnitState(c, UNIT_STATE_MAX_LIFE) * 0.005 * (level + ult_level) * n
        call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) + heal_amt)
        
        call SetTextTagText(tt,"+" + I2S(R2I(heal_amt)),.020)
        call SetTextTagPos(tt,x-16.,y+20,.0)
        call SetTextTagColor(tt,50,255,25,255)
        call SetTextTagVelocity(tt,.0,.04)

        call SetTextTagVisibility(tt,false)
    
        if (IsVisibleToPlayer(x, y, GetLocalPlayer()) == true) then
            call SetTextTagVisibility(tt, true)
        endif
        
        call SetTextTagFadepoint(tt,1.)
        call SetTextTagLifespan(tt,2.)
        call SetTextTagPermanent(tt,false) 
        
        set tt = null
        set g = null
        set u = null
        set c = null
        set d = null
    endfunction
    
    //===========================================================================
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t, Condition(function Conditions))
        call TriggerAddAction(t, function Actions)
        set t = null
    endfunction

endscope



