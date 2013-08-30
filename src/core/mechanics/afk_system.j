scope AfkSystem

    globals
        /**
         *  Stores the last action time of a player
         *
         *  @private
         *  @type real[]
         */
        private real array LastActionTime

        /**
         *  Stores the player who used the afk command
         *
         *  @private
         *  @type player[]
         */
        private player array stackPlayer

        /**
         *  When a players uses the afk command, stackLevel is incremented by 1
         *
         *  @private
         *  @type integer
         */
        private integer stackLevel = 0

        /**
         *  Used when a player uses the afk command
         *
         *  @private
         *  @type timer
         */
        private timer stackTimer = CreateTimer()

        /**
         *
         *  @private
         *  @type boolean[]
         */
        private boolean array seAviso
    endglobals
    
    /**
     *  Returns the last action time of a player
     *
     *  @private
     *  @param player
     *  @return real
     */
    private function GetLastActionTime takes player p returns real
        return LastActionTime[GetPlayerId(p)]
    endfunction

    /**
     *  Updates the last action time of a player to the current.
     *  Also, <<<<<<<<<<<<<<<<<<<<<< COMPLETE HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<
     *
     *  @private
     *  @param player
     */
    private function SetLastActionTime takes player p returns nothing
        set seAviso[GetPlayerId(p)] = false
        set LastActionTime[GetPlayerId(p)] = TimerGetElapsed(udg_Game_Timer)
    endfunction

    /**
     *  Colorizes a message
     *
     *  @private
     *  @param string
     *  @return string
     */
    private function Colorizar takes string msg returns string
        return "|cff99b4d1"+msg+"|r"
    endfunction
    
    /**
     *  Whenever a player makes an action, his last action time gets updated.
     *  This function is executed by trigger (unit order, point order, etc.).
     *
     *  @private
     *  @return boolean
     */
    private function onAction takes nothing returns boolean
        call SetLastActionTime(GetTriggerPlayer())
        return false
    endfunction
    
    /**
     *  Parses a message saying how many time a player has been afk (in minutes)
     *
     *  @param player
     *  @return string
     */
    private function HasBeenAfk takes player whichPlayer returns string
        return GetPlayerNameColored(whichPlayer) + "|cff99b4d1 has been |r|cffff0000afk |r|cff99b4d1for |r"+"|cff4169e1"+R2S((GetGameTime()-GetLastActionTime(whichPlayer)-13)/60)+"|r |cff99b4d1minutes. |r"
    endfunction
    
    /**
     *  
     *
     *  @private
     *  @param integer
     *  @return string
     */
    private function inTeamId takes integer id returns string
        if id > 6 then
            return I2S(id-6)
        endif
        return I2S(id)
    endfunction

    /**
     *  This function is executed after a player uses the afk command and tells him
     *  for how many times his allies have been afk. Also tells him how to kick them.
     *  
     *  @private
     */
    private function Main takes nothing returns nothing
        local real time
        local player forLoopPlayer
        local string extra = ""
        local string display = ""
        local integer i
        loop
            exitwhen stackLevel < 1
            set i = 1
            loop
                if i != 6 then
                    set forLoopPlayer = Player(i)
                    if (forLoopPlayer!=stackPlayer[stackLevel]) and (IsHeroReviving(forLoopPlayer)==false) and (IsPlayerHuman(forLoopPlayer)) and (IsPlayerLeaver(forLoopPlayer)==false) then
                        set time = GetGameTime() - GetLastActionTime(forLoopPlayer)
                        if time > 13 then
                            set display =  display + "\n" + HasBeenAfk(forLoopPlayer)
                            if time >= 313 and IsPlayerAlly(stackPlayer[stackLevel],forLoopPlayer) then
                                if extra != "" then
                                    set extra = extra + ", -kick "+ GetPlayerStringColored(forLoopPlayer,inTeamId(i))
                                else
                                    set extra = " -kick " + GetPlayerStringColored(forLoopPlayer,inTeamId(i))
                                endif
                            endif 
                        endif
                    endif
                endif
                set i = i + 1
                exitwhen i>11
            endloop
            if display == "" then
                set display = "|cff99b4d1No|r |cff99b4d1afk players.|r"
            else
                if extra != "" then
                    set extra = "\n|cff99b4d1 You may kick one of them using:|r " + extra
                endif
            endif
            call DisplayTimedTextToPlayer( stackPlayer[stackLevel], 0, 0, 10, display + extra)
            set stackLevel = stackLevel - 1
        endloop
    endfunction
    
    /**
     *  This function is executed when a players uses the afk command.
     *  Returns false only to safisfice the trigger.
     *
     *  @private
     *  @return boolean
     */
    private function onAfkCommand takes nothing returns boolean
        set stackLevel = stackLevel + 1
        set stackPlayer[stackLevel] = GetTriggerPlayer()
        call ResumeTimer(stackTimer)
        return false
    endfunction

    /**
     *  This function is executed when a player uses the kick command.
     *  Returns false only to safisfice the trigger.
     *
     *  If the accused player (kick <accused player>) is a leaver or bot, only
     *  a message will be displayed; if not, we will see his afk time. If the
     *  afk time is bigger than 5 minutes, then kick, otherwise just a message.
     *
     *  @private
     *  @return boolean
     */
    private function kick takes nothing returns boolean
        local player target
        local integer targetId=S2I(SubString(GetEventPlayerChatString(),6,7))
        //***OBTENER TARGET***
        if IsPlayerAlly(udg_team1[0],GetTriggerPlayer()) then
            set target=udg_team1[targetId]
        else
            set target=udg_team2[targetId]
        endif
        //***SOLO VALIDOS***
        if IsPlayerHuman(target)==false or IsPlayerLeaver(target) then
            call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 10,GetPlayerNameColored(target)+ Colorizar(" is not playing!"))
        else
            if GetGameTime()-GetLastActionTime(target)>313 then
                call DropPlayer(target,false)
                call Defeat(target)
            else
                call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 10,GetPlayerNameColored(target)+"|r can't be kicked yet.")
            endif
        endif
        set target = null
        return false
    endfunction
    
    /**
     *  
     *
     *  @private
     *  @param player
     *  @param string
     */
    private function MostrarAfk takes player alliance,string msg returns nothing
        if IsPlayerAlly(GetLocalPlayer(),alliance) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10,msg)
        endif
    endfunction
    
    /**
     *  
     *
     *  @private
     */
    private function AvisarAfk takes nothing returns nothing
        local integer i=1
        loop
            // Konoha: Humano y Jugando
            if (IsPlayerHuman(udg_team1[i])) and (IsPlayerLeaver(udg_team1[i])==false) and seAviso[i]==false then
                // Si Más de 5 minutos AFK entonces mostrar mensaje al equipo.
                if GetGameTime()-GetLastActionTime(udg_team1[i])>313 then
                    set seAviso[i] = true
                    call MostrarAfk(udg_team1[0],HasBeenAfk(udg_team1[i])+ "\nYou may type |cff99b4d1-kick "+I2S(i)+"|r to boot this player from game.")
                endif
            endif
            if (IsPlayerHuman(udg_team2[i])) and (IsPlayerLeaver(udg_team2[i])==false) and seAviso[i+6]==false then
                if GetGameTime()-GetLastActionTime(udg_team2[i])>313 then
                    set seAviso[i+6] = true
                    call MostrarAfk(udg_team2[0],HasBeenAfk(udg_team2[i])+ "\nYou may type |cff99b4d1-kick "+I2S(i)+"|r to boot this player from game.")
                endif
            endif
            set i = i + 1
            exitwhen i>4
        endloop
    endfunction

    /**
     *  Executed in map init.
     *  Creates the triggers who listen for "-afk" and "-kick <n>" commands.
     *  <<<<<<<<<<<< COMPLETE HERE <<<<<<<<<<<<
     */
    function StartTrigger_Afk_System takes nothing returns nothing
        local integer i=1
        local trigger t1=CreateTrigger()
        local trigger t2=CreateTrigger()
        loop
            call TriggerRegisterPlayerChatEvent(t1,udg_team1[i],"-afk",false)
            call TriggerRegisterPlayerChatEvent(t1,udg_team2[i],"-afk",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team1[i],"-kick 1",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team1[i],"-kick 2",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team1[i],"-kick 3",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team1[i],"-kick 4",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team1[i],"-kick 5",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team2[i],"-kick 1",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team2[i],"-kick 2",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team2[i],"-kick 3",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team2[i],"-kick 4",false)
            call TriggerRegisterPlayerChatEvent(t2,udg_team2[i],"-kick 5",false)
            set i=i+1
            exitwhen i>5
        endloop
		call TriggerAddAction(t1,function onAfkCommand)
        call TriggerAddAction(t2,function kick)
        call TimerStart(stackTimer,0,false,function Main)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ISSUED_ORDER,function onAction)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER,function onAction)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER,function onAction)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER,function onAction)
        loop
            if i != 6 then
                call SetLastActionTime(Player(i))
                call SetHeroReviving(Player(i),false)
            endif
            set i = i + 1
            exitwhen i>11
        endloop
        call TimerStart(CreateTimer(),2,true,function AvisarAfk)
    endfunction

endscope