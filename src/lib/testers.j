scope Testers{

    globals
        private boolean array isTester
        private boolean array registered
    endglobals

    define
        private PLAYERS_LENGTH = 11
    enddefine

    private boolean IsMapMaker(player p){
        return GetRealPlayerName(p) == "muZk"
    }

    private boolean IsHeroChoosen(int heroId){

        int i = 0

        while(i <= 11){
            unit u = GetPlayerHero(Player(i))
            if(u != null and GetUnitTypeId(u) == heroId){
                return true
            }
            i++
        }

        return false
    }

    private int command2heroId(string command){
        if (command == "-han"){
            return HAN
        } elseif (command == "-dei"){
            return DEIDARA
        } elseif (command == "-ino"){
            return INO
        } elseif (command == "-karin"){
            return KARIN
        }
        return 0
    }

    private void onCommand(){

        player p = GetTriggerPlayer()
        string name = GetPlayerName(p)
        string command = StringCase(GetEventPlayerChatString(), false)
        real x
        real y

        if(GetPlayerHero(p) != null){
            return
        }

        if(GetPlayerId(p) < 7){
            x = GetRectCenterX(gg_rct_Konoha_Hero_Spawn)
            y = GetRectCenterY(gg_rct_Konoha_Hero_Spawn)
        } else {
            x = GetRectCenterX(gg_rct_Shinobi_Hero_Spawn)
            y = GetRectCenterY(gg_rct_Shinobi_Hero_Spawn)
        }

        int heroId = command2heroId(command)

        if(heroId>0){
            if(IsHeroChoosen(heroId)){
                call DisplayTimedTextToPlayer(p, 0, 0, 8, GetObjectName('e01L'))
            } else {
                call RegisterHeroToPlayer(CreateUnit(p, heroId, x, y, 0), p)
                call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)-250)
            }
        }

    }

    private void Delayed(){

        string array testers
        testers[0] = "muZk"
        testers[1] = "Nurarihyon"
        testers[2] = "Masamune"
        testers[3] = "reborn2956"
        testers[4] = "Gemini"
        testers[5] = "Black.Widow"
        testers[6] = "Cherrywater"
        testers[7] = "frankshotsauce"
        testers[8] = "MashiroMuritaka"
        testers[9] = "WorldEdit"
        testers[10] = "ArOuNDThaWOrLD" 
        testers[11] = "pronoob" 
        testers[12] = "XkreshSWx"
        testers[13] = "Azog(" 
        testers[14] = "Profe"
        testers[15] = "Nuts)"
        testers[16] = "SSJGOKU"
        testers[17] = "GhostBusters2"
        testers[18] = "6th.kakashi"
        testers[19] = "GumGumNo"
        testers[20] = "kaze"
        int TESTERS_LENGTH = 20

        // Register commands ONLY for testers

        trigger t = CreateTrigger()
        int playerId = 0
        int testerId = 0

        while(playerId <= PLAYERS_LENGTH){

            testerId = 0
            
            while(testerId <= TESTERS_LENGTH){
                if(!isTester[playerId] and testers[testerId] == GetRealPlayerName(Player(playerId))){
                    isTester[playerId] = true
                }
                testerId++
            }
            
            if(isTester[playerId]){
                call TriggerRegisterPlayerChatEvent(t, Player(playerId), "-", false)
                call DisplayTimedTextToPlayer(Player(playerId), 0, 0, 8, GetObjectName('e01K')+"\n-ino\n-han\n-karin\n-dei|r")
            }

            playerId++
        }

        call TriggerAddAction(t, function onCommand)
    }

    void StartTrigger_Testers(){
        call TimerStart(NewTimer(), 5, false, function Delayed)
    }

}