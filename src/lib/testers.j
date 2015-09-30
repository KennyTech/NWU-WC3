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
        testers[21] = "H20"
        testers[22] = "Milotic"
        testers[23] = "Seven-Tails-Fu"
        testers[24] = "GhostRidder"
        testers[25] = "UnMi"
        testers[26] = "Hyakuei"
        testers[27] = "Ace"
        testers[28] = "34preist34"
        testers[29] = "chlamydia"
        testers[30] = "Miss[t]Nin"
        testers[31] = "Mew"
        testers[32] = "milan84"
        testers[33] = "Borngolden"
        testers[34] = "HelionPrime"
        testers[35] = "Crabdancerking"
        testers[36] = "dar_end"
        testers[37] = "coolhopper"
        testers[38] = "matdas"
        testers[39] = "a_dam_god"
        testers[40] = "Souseiseki"
        testers[41] = "rob_eats_noobs"
        testers[42] = "MashiroMuritaka"
        testers[43] = "SonofOdin"
        testers[44] = "Montana"
        testers[45] = "Axell"
        testers[46] = "aphotik"
        testers[47] = "Colgrim"
        testers[48] = "S.Holmes"
        testers[49] = "gon-"
        testers[50] = "Ryus"
        testers[51] = "Miecio777"
        testers[52] = "Amaterasu"
        testers[53] = "Lucifer."
        testers[54] = "anakin94"
        testers[55] = "GhostBusters2"
        testers[56] = "bq."
        testers[57] = "sawczenqo."
        testers[58] = "the_karma"
        testers[59] = "Hunterfire"
        testers[60] = "Ka1n"
        
        int TESTERS_LENGTH = 60

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
