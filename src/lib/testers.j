scope Testers{

    globals
        private boolean array isTester
        private boolean array registered
    endglobals

    define
        private TESTERS_LENGTH = 9
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

    private void onCommand(){

        player p = GetTriggerPlayer()
        string name = GetPlayerName(p)
        string command=StringCase(GetEventPlayerChatString(), false)
        int heroId
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

        if(command == "-killerbee"){
            heroId = KILLER_BEE
        }

        if(IsHeroChoosen(heroId)){
            call DisplayTimedTextToPlayer(p, 0, 0, 8, GetObjectName('e01L'))
        } else {
            call RegisterHeroToPlayer(CreateUnit(p, KILLER_BEE, x, y, 0), p)
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
        testers[9] = "WorldEdit" // I have to test somehow eh :P

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
                call DisplayTimedTextToPlayer(Player(playerId), 0, 0, 8, GetObjectName('e01K'))
            }

            playerId++
        }

        call TriggerAddAction(t, function onCommand)
    }

    void StartTrigger_Testers(){
        call TimerStart(NewTimer(), 5, false, function Delayed)
    }

}