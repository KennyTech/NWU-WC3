scope YamatoBox{
    
    define{
        private SPELL_ID        = 'A0AI'
        private DAMAGE(lvl)     = 40+50*lvl
        private DURATION(lvl)   = 1.5 + lvl
        private DESTRUCTABLE_ID = 'B008'
    }

    private bool doDamage(){
        unit u = GetTriggerUnit()
        unit m = GetFilterUnit()
        real dmg = DAMAGE(GetUnitAbilityLevel(u,'A0AI'))
        if (IsUnitEnemy(m,GetTriggerPlayer())) and (IsUnitType(m,UNIT_TYPE_DEAD)==false) and (IsUnitType(m,UNIT_TYPE_STRUCTURE)==false) and GetUnitAbilityLevel(m,'Aloc')==0 then
            call Damage_Spell(u, m, dmg)
        endif
        set u = null
        set m = null
        return false
    }

    private destructable createDest(real x, real y){
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", x, y))
        return CreateDestructable(DESTRUCTABLE_ID, x, y, 0, 6, 1)
    }

    private void onCast(){

       local unit u = GetTriggerUnit()
        local unit array U
        local integer Ui = 0
        local player p = GetTriggerPlayer()
        
        local real X = GetSpellTargetX()
        local real Y = GetSpellTargetY()
        
        local real ux 
        local real uy 
        local integer n = 0
        
        local real array XX
        local real array YY
        local integer Xi = 0
        
        local rect r = Rect(X-250,Y-250,X+250,Y+250)
        call GroupEnumUnitsInRect(ENUM,r,Filter(function doDamage))
        call RemoveRect(r)
        set r = null
        
        set X = X-240
        set Y = Y+240
        set ux = X
        set uy = Y
        
        loop
            exitwhen n>7
            set XX[Xi] = ux
            set YY[Xi] = uy
            set U[Ui] = CreateUnit(p,'h01C',ux,uy,270)
            call CreateLargeWalkabilityBlocker(XX[Xi],YY[Xi],false)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",ux,uy))
            set Ui = Ui+1
            set Xi = Xi+1
            set XX[Xi] = ux
            set YY[Xi] = uy-480
            set U[Ui] = CreateUnit(p,'h01C',ux,uy-480,270)
            call CreateLargeWalkabilityBlocker(XX[Xi],YY[Xi],false)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",ux,uy-480))
            set Ui = Ui+1
            set Xi = Xi+1
            set ux = ux + 60
            set n = n+1
        endloop
        set ux = X
        set uy = Y
        set n = 0
        loop
            exitwhen n>7
            set XX[Xi] = ux
            set YY[Xi] = uy
            set U[Ui] = CreateUnit(p,'h01C',ux,uy,270)
            call CreateLargeWalkabilityBlocker(XX[Xi],YY[Xi],false)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",ux,uy))
            set Ui = Ui+1
            set Xi = Xi+1
            set XX[Xi] = ux+480
            set YY[Xi] = uy
            set U[Ui] = CreateUnit(p,'h01C',ux+480,uy,270)
            call CreateLargeWalkabilityBlocker(XX[Xi],YY[Xi],false)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",ux+480,uy))
            set Ui = Ui+1
            set Xi = Xi + 1
            set uy = uy - 60
            set n = n+1
        endloop
        set U[Ui] = CreateUnit(p,'h01C',ux+480,Y-480,270)
        set XX[Xi] = ux+480
        set YY[Xi] = uy-480
        call CreateLargeWalkabilityBlocker(XX[Xi],YY[Xi],false)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",ux+480,uy))
        set Ui = Ui+1
        set Xi = Xi+1
        call TriggerSleepAction(1.5+GetUnitAbilityLevel(u,'A0AI'))
        set n = Ui
        loop
            set Ui = Ui-1
            exitwhen Ui<0
            call KillUnit(U[Ui])
        endloop
        call TriggerSleepAction(0.25)
        loop
            exitwhen Xi<0
            call CreateLargeWalkabilityBlocker(XX[Xi],YY[Xi],true)
            set Xi=Xi-1
        endloop
        call TriggerSleepAction(1)
        loop
            set n=n-1
            exitwhen n<0
            call RemoveUnit(U[n])
            set U[n] = null
        endloop
        set u = null

    }

    private bool conditions(){
        return GetSpellAbilityId() == SPELL_ID
    }

    public void Init(){
        trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( t, Condition( function conditions ) )
        call TriggerAddAction( t, function onCast )
    }

}