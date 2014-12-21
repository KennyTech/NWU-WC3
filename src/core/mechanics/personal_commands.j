scope Personal

    private function ms_forgroup takes nothing returns boolean
        local unit u=GetFilterUnit()
        if IsUnitSelected(u, GetOwningPlayer(u)) and IsUnitType(u,UNIT_TYPE_HERO) then
            call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 5, ( "Current Speed of " + ( GetUnitName(u) + ( " is " + I2S(R2I(GetUnitMoveSpeed(u))) ) ) ) )
        endif
        set u=null
        return false
    endfunction

    private function ms takes nothing returns nothing
        call GroupEnumUnitsOfPlayer(ENUM,GetTriggerPlayer(),Filter(function ms_forgroup))
    endfunction
    
    private function mr_forgroup takes nothing returns boolean
        if IsUnitSelected(GetFilterUnit(), GetOwningPlayer(GetFilterUnit())) and IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO) then
            call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 5, ( "Current Magic Resistance of " + ( GetUnitName(GetFilterUnit())) + ( " is " + I2S(R2I(100*(GetMagicResistance(GetFilterUnit())))) + "%") ) ) 
        endif
        return false
    endfunction

    private function mr takes nothing returns nothing
        call GroupEnumUnitsOfPlayer(ENUM,GetTriggerPlayer(),Filter(function mr_forgroup))
    endfunction
    
    private function clear takes nothing returns nothing
        if GetLocalPlayer()==GetTriggerPlayer() then
           call ClearTextMessages()
        endif
    endfunction
    
    private function msg takes string s returns nothing
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,-10,20,"|cff0066cc"+s)
    endfunction
    
    private function gameinfo takes nothing returns nothing
        if HOST_HAS_SELECTED_MODE then
            if AP then
                call msg("All Pick"+"|r:   "+GetObjectName('e00S'))
            endif
            if AR then
                call msg("All Random"+"|r:   "+GetObjectName('e00T'))
            endif
            if SD then
                call msg("Single Draft"+"|r:   "+GetObjectName('e00U'))
            endif
            if SM then
                call msg("Short Mode"+"|r:   "+GetObjectName('e00V'))
            endif
            if PM then
                call msg("Pro Mode"+"|r:   "+GetObjectName('e00W'))
            endif
            if NR then
                call msg("No Runes"+"|r:   "+GetObjectName('e00X'))
            endif
            if OM then
                call msg("Only Mid"+"|r:   "+GetObjectName('e00Y'))
            endif
            if NB then
                call msg("No Bot"+"|r:   "+GetObjectName('e00Z'))
            endif
            if NT then
                call msg("No Top"+"|r:   "+GetObjectName('e010'))
            endif
            if NM then
                call msg("No Mid"+"|r:   "+GetObjectName('e011'))
            endif
        else
            call msg("Normal Mode"+"|r:   "+GetObjectName('e012'))
        endif
    endfunction

    private function ma_forgroup takes nothing returns nothing
        local player p=GetEnumPlayer()
        if GetPlayerHero(p)!=null and IsPlayerEnemy(p,GetTriggerPlayer())==true then
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,10,GetPlayerNameColored(p)+" controls "+GetUnitName(GetPlayerHero(p)))
        endif
        set p=null
    endfunction
    
    private function ma takes nothing returns nothing
        call ForForce(bj_FORCE_ALL_PLAYERS,function ma_forgroup)
    endfunction
    
    
    private function courier_forgroup takes nothing returns boolean
        set enumUnit=GetFilterUnit()
        if UnitTypeCourier(enumUnit) and GetWidgetLife(enumUnit)>0.405 then
            if IsUnitType(enumUnit,UNIT_TYPE_PEON)==true then
                call UnitRemoveType(enumUnit,UNIT_TYPE_PEON)
            else
                call UnitAddType(enumUnit,UNIT_TYPE_PEON)
            endif
        endif
        return false
    endfunction
    
    private function courier takes nothing returns nothing
        call GroupEnumUnitsOfPlayer(ENUM,GetTriggerPlayer(),Filter(function courier_forgroup))
    endfunction
    
    private function onCommand takes nothing returns nothing
        local string command=StringCase(GetEventPlayerChatString(),false)
        if command=="-ma" then
            call ma()
        elseif command=="-gameinfo" then
            call gameinfo()
        elseif command=="-clear" then
            call clear()
        elseif command=="-mr" then
            call mr()
        elseif command=="-ms" then
            call ms()
        elseif command=="-courier" then
            call courier()
        endif
    endfunction
    
    //---------------------- SINGLE PLAYER ---------------------------
    private function RefillFilter takes nothing returns boolean
        local unit m = GetFilterUnit()
        if GetOwningPlayer(m)==GetTriggerPlayer() then
            call SetWidgetLife(m,GetUnitState(m,UNIT_STATE_MAX_LIFE))
            call SetUnitState(m,UNIT_STATE_MANA,GetUnitState(m,UNIT_STATE_MAX_MANA))
            call UnitResetCooldown(m)
        endif
        set m = null
        return false
    endfunction
    
    private function Refill takes nothing returns nothing
        call GroupEnumUnitsSelected(udg_GROUP, GetTriggerPlayer(),Condition(function RefillFilter))
    endfunction
    
    private function test takes nothing returns nothing
        local integer i = 1
        local unit hero
        local rect r = gg_rct_TestZone1
        local player p = GetTriggerPlayer()
        if GetPlayerId(p)>6 then
            set r = gg_rct_TestZone2
        endif
        loop
            exitwhen i>udg_HeroAmount
            set hero = CreateUnit(p,udg_Hero[i],GetRectCenterX(r),GetRectCenterY(r),270)
            call SetHeroLevel(hero,6,false)
            call TurnOnOffHeroTriggers(hero,true)
            set i = i + 1
        endloop
        set r = null
        set p = null
    endfunction
    
    private function lvlup takes nothing returns boolean
        local integer level=S2I(SubString(GetEventPlayerChatString(),7,StringLength(GetEventPlayerChatString())))
        call GroupEnumUnitsSelected(ENUM,GetTriggerPlayer(),null)
        set enumUnit = FirstOfGroup(ENUM)
        loop
            exitwhen enumUnit==null
            call GroupRemoveUnit(ENUM,enumUnit)
            call SetHeroLevel(enumUnit,level,true)
        endloop
        call GroupClear(ENUM)
        return false
    endfunction

    private function dummy takes nothing returns nothing
        if IsPlayerAlly(GetTriggerPlayer(),udg_team1[0]) then
            call SetHeroLevel(CreateUnit(Player(GetRandomInt(7,11)),udg_Hero[GetRandomInt(1,udg_HeroAmount)],5000,-5000,0),10,false)
        else
            call SetHeroLevel(CreateUnit(Player(GetRandomInt(1,5)),udg_Hero[GetRandomInt(1,udg_HeroAmount)],4200,-4200,0),10,false)
        endif
    endfunction
    
    private function gold takes nothing returns boolean
        call SetPlayerState(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_GOLD)+1000000)
        return false
    endfunction
    
    private function onSinglePlayerCommand takes nothing returns nothing
        local string command=StringCase(GetEventPlayerChatString(),false)
        if command=="-test" then
            call test()
        elseif command=="-dummy" then
            call dummy()
        elseif command=="-gold" then
            call gold()
        elseif command=="-spawn" then
            call SpawnCreeps()
        elseif SubString(command,0,6)=="-lvlup" then
            call lvlup()
        endif
    endfunction
    
    function StartTrigger_Personal_Commands takes nothing returns nothing
        local trigger t=CreateTrigger()
        local integer i=0
        loop
            call TriggerRegisterPlayerChatEvent(t,udg_team1[i],"-",false)
            call TriggerRegisterPlayerChatEvent(t,udg_team2[i],"-",false)
            set i=i+1
            exitwhen i>5
        endloop
		call TriggerAddAction(t,function onCommand)
        if udg_SingleMode==true then
            set t=CreateTrigger()
            set i=2
            loop
                exitwhen i>25
                call TriggerRegisterPlayerChatEvent(t,udg_Host,"-lvlup "+I2S(i),false)
                set i=i+1
            endloop
            call TriggerRegisterPlayerChatEvent(t,udg_Host,"-",false)
            call TriggerAddAction(t,function onSinglePlayerCommand)
            set t = CreateTrigger()
            call TriggerRegisterPlayerEvent(t,udg_Host, EVENT_PLAYER_END_CINEMATIC)
            call TriggerAddAction(t,function Refill)
        endif
        static if TEST_MODE then
            // ALLOWS LEVELUP IN TEST_MODE FOR FASTER TESTS
            BJDebugMsg("TEST_MODE: You can type -lvlup X to level up your Hero")
            int playerId = 0
            loop
                exitwhen i > 25
                loop
                    exitwhen playerId > 12
                    call TriggerRegisterPlayerChatEvent(t, Player(playerId), "-lvlup "+I2S(i), false)
                endloop
                set i = i + 1 
            endloop
        endif
        set t=null
    endfunction

endscope