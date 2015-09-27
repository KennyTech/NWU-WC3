library HeroPreload /*
************************************************************************************
*
*   udg_Hero --> rawcodes
*   udg_HeroIcon --> path for BTN icons
*   udg_HeroMainStat --> primary hero attribute (STR = 1, AGI = 2 INT = 3)
*   udg_HeroIsAvailable --> availability for selection (repick, sd)
*   HeroeName --> name of the hero (used for chat)
*
************************************************************************************/

    globals
        string array HeroeName[51]
    endglobals

    define
        private STR_HERO = 1
        private AGI_HERO = 2
        private INT_HERO = 3
    enddefine

    public function init takes nothing returns nothing
        // Initializing Hero Models
        set udg_Hero[1] = SHODAIME
        set udg_HeroIcon[1] = "ReplaceableTextures\\CommandButtons\\BTNShoda.blp"
        set udg_HeroMainStat[1] = STR_HERO
        set udg_HeroIsAvailable[1] = true
        set HeroeName[1] = "Shodaime"
        // ==========
        set udg_Hero[2] = NIDAIME
        set udg_HeroIcon[2] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Nidaime.blp"
        set udg_HeroMainStat[2] = AGI_HERO
        set udg_HeroIsAvailable[2] = true
        set HeroeName[2] = "Nidaime"
        // ==========
        set udg_Hero[3] = SAKURA
        set udg_HeroIcon[3] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Sakura.blp"
        set udg_HeroMainStat[3] = STR_HERO
        set udg_HeroIsAvailable[3] = true
        set HeroeName[3] = "Sakura"
        // ==========
        set udg_Hero[4] = GAARA
        set udg_HeroIcon[4] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Garaa.blp"
        set udg_HeroMainStat[4] = INT_HERO
        set udg_HeroIsAvailable[4] = true
        set HeroeName[4] = "Gaara"
        // ==========
        set udg_Hero[5] = SARUTOBI
        set udg_HeroIcon[5] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Sarutobi.blp"
        set udg_HeroMainStat[5] = INT_HERO
        set udg_HeroIsAvailable[5] = true
        set HeroeName[5] = "Sarutobi"
        // ==========
        set udg_Hero[6] = ITACHI
        set udg_HeroIcon[6] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Itachi.blp"
        set udg_HeroMainStat[6] = AGI_HERO
        set udg_HeroIsAvailable[6] = true
        set HeroeName[6] = "Itachi"
        // ==========
        set udg_Hero[7] = MINATO
        set udg_HeroIcon[7] = "ReplaceableTextures\\CommandButtons\\BTNMinato.blp"
        set udg_HeroMainStat[7] = AGI_HERO
        set udg_HeroIsAvailable[7] = true
        set HeroeName[7] = "Minato"
        // ==========
        set udg_Hero[8] = TSUNADE
        set udg_HeroIcon[8] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Tsunade.blp"
        set udg_HeroMainStat[8] = STR_HERO
        set udg_HeroIsAvailable[8] = true
        set HeroeName[8] = "Tsunade"
        // ==========
        set udg_Hero[9] = HINATA
        set udg_HeroIcon[9] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Hinata.blp"
        set udg_HeroMainStat[9] = AGI_HERO
        set udg_HeroIsAvailable[9] = true
        set HeroeName[9] = "Hinata"
        // ==========
        set udg_Hero[10] = TAYUYA
        set udg_HeroIcon[10] = "ReplaceableTextures\\CommandButtons\\BTNTayu.blp"
        set udg_HeroMainStat[10] = INT_HERO
        set udg_HeroIsAvailable[10] = true
        set HeroeName[10] = "Tayuya"
        // ==========
        set udg_Hero[11] = JIRAIYA
        set udg_HeroIcon[11] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Jiraya.blp"
        set udg_HeroMainStat[11] = STR_HERO
        set udg_HeroIsAvailable[11] = true
        set HeroeName[11] = "Jiraiya"
        // ==========
        set udg_Hero[12] = SHINO
        set udg_HeroIcon[12] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Shino.blp"
        set udg_HeroMainStat[12] = INT_HERO
        set udg_HeroIsAvailable[12] = true
        set HeroeName[12] = "Shino"
        // ==========
        set udg_Hero[13] = KISAME
        set udg_HeroIcon[13] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kisame.blp"
        set udg_HeroMainStat[13] = STR_HERO
        set udg_HeroIsAvailable[13] = true
        set HeroeName[13] = "Kisame"
        // ==========
        set udg_Hero[14] = ZABUZA
        set udg_HeroIcon[14] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Zabuza.blp"
        set udg_HeroMainStat[14] = AGI_HERO
        set udg_HeroIsAvailable[14] = true
        set HeroeName[14] = "Zabuza"
        // ==========
        set udg_Hero[15] = YAMATO
        set udg_HeroIcon[15] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Yamato.blp"
        set udg_HeroMainStat[15] = STR_HERO
        set udg_HeroIsAvailable[15] = true
        set HeroeName[15] = "Yamato"
        // ==========
        set udg_Hero[16] = OROCHIMARU
        set udg_HeroIcon[16] = "ReplaceableTextures\\CommandButtons\\BTNOro.blp"
        set udg_HeroMainStat[16] = AGI_HERO
        set udg_HeroIsAvailable[16] = true
        set HeroeName[16] = "Orochimaru"
        // ==========
        set udg_Hero[17] = SHIKAMARU
        set udg_HeroIcon[17] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Shikamaru.blp"
        set udg_HeroMainStat[17] = INT_HERO
        set udg_HeroIsAvailable[17] = true
        set HeroeName[17] = "Shikamaru"
        // ==========
        set udg_Hero[18] = NEJI
        set udg_HeroIcon[18] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Neji.blp"
        set udg_HeroMainStat[18] = AGI_HERO
        set udg_HeroIsAvailable[18] = true
        set HeroeName[18] = "Neji"
        // ==========
        set udg_Hero[19] = KAKASHI
        set udg_HeroIcon[19] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kakashi.blp"
        set udg_HeroMainStat[19] = STR_HERO
        set udg_HeroIsAvailable[19] = true
        set HeroeName[19] = "Kakashi"
        // ==========
        set udg_Hero[20] = GUY
        set udg_HeroIcon[20] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Gai.blp"
        set udg_HeroMainStat[20] = AGI_HERO
        set udg_HeroIsAvailable[20] = true
        set HeroeName[20] = "Guy"
        // ==========
        set udg_Hero[21] = JIROBOU
        set udg_HeroIcon[21] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Jirobo.blp"
        set udg_HeroMainStat[21] = STR_HERO
        set udg_HeroIsAvailable[21] = true
        set HeroeName[21] = "Jirobou"
        // ==========
        set udg_Hero[22] = ROCKLEE
        set udg_HeroIcon[22] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Lee.blp"
        set udg_HeroMainStat[22] = AGI_HERO
        set udg_HeroIsAvailable[22] = true
        set HeroeName[22] = "RockLee"
        // ==========
        set udg_Hero[23] = SAKON
        set udg_HeroIcon[23] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Sakon.blp"
        set udg_HeroMainStat[23] = STR_HERO
        set udg_HeroIsAvailable[23] = true
        set HeroeName[23] = "Sakon"
        // ==========
        set udg_Hero[24] = HAKU
        set udg_HeroIcon[24] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Haku.blp"
        set udg_HeroMainStat[24] = INT_HERO
        set udg_HeroIsAvailable[24] = true
        set HeroeName[24] = "Haku"
        // ==========
        set udg_Hero[25] = INO
        set udg_HeroIcon[25] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Ino.blp"
        set udg_HeroMainStat[25] = INT_HERO
        set udg_HeroIsAvailable[25] = false
        set HeroeName[25] = "Ino"
        // ==========
        set udg_Hero[26] = CHOUJI
        set udg_HeroIcon[26] = "ReplaceableTextures\\CommandButtons\\BTNCho.blp"
        set udg_HeroMainStat[26] = STR_HERO
        set udg_HeroIsAvailable[26] = true
        set HeroeName[26] = "Chouji"
        // ==========
        set udg_Hero[27] = KABUTO
        set udg_HeroIcon[27] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kabuto.blp"
        set udg_HeroMainStat[27] = AGI_HERO
        set udg_HeroIsAvailable[27] = true
        set HeroeName[27] = "Kabuto"
        // ==========
        set udg_Hero[28] = KANKURO
        set udg_HeroIcon[28] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kankuro.blp"
        set udg_HeroMainStat[28] = INT_HERO
        set udg_HeroIsAvailable[28] = true
        set HeroeName[28] = "Kankuro"
        // ==========
        set udg_Hero[29] =  KIDOMARU
        set udg_HeroIcon[29] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kidoumaru.blp"
        set udg_HeroMainStat[29] = INT_HERO
        set udg_HeroIsAvailable[29] = true
        set HeroeName[29] = "Kidomaru"
        // ==========
        set udg_Hero[30] = TENTEN
        set udg_HeroIcon[30] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Tenten.blp"
        set udg_HeroMainStat[30] = AGI_HERO
        set udg_HeroIsAvailable[30] = true
        set HeroeName[30] = "Tenten"
        // ==========
        set udg_Hero[31] = TEMARI
        set udg_HeroIcon[31] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Temari.blp"
        set udg_HeroMainStat[31] = INT_HERO
        set udg_HeroIsAvailable[31] = true
        set HeroeName[31] = "Temari"
        // ==========
        set udg_Hero[32] = DEIDARA
        set udg_HeroIcon[32] = "ReplaceableTextures\\CommandButtons\\BTNDeida.blp"
        set udg_HeroMainStat[32] = INT_HERO
        set udg_HeroIsAvailable[32] = false
        set HeroeName[32] = "Deidara"
        // ==========
        set udg_Hero[33] = KIMIMARO
        set udg_HeroIcon[33] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kimimaro.blp"
        set udg_HeroMainStat[33] = AGI_HERO
        set udg_HeroIsAvailable[33] = true
        set HeroeName[33] = "Kimimaro"
        // ==========
        set udg_Hero[34] = NARUTO
        set udg_HeroIcon[34] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Naruto.blp"
        set udg_HeroMainStat[34] = STR_HERO
        set udg_HeroIsAvailable[34] = true
        set HeroeName[34] = "Naruto"
        // ==========
        set udg_Hero[35] = KIBA
        set udg_HeroIcon[35] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kiba.blp"
        set udg_HeroMainStat[35] = AGI_HERO
        set udg_HeroIsAvailable[35] = true
        set HeroeName[35] = "Kiba"
        // ==========
        set udg_Hero[36] = SASUKE
        set udg_HeroIcon[36] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Sasuke.blp"
        set udg_HeroMainStat[36] = INT_HERO
        set udg_HeroIsAvailable[36] = true
        set HeroeName[36] = "Sasuke"
        // ==========
        set udg_Hero[37] = ASUMA
        set udg_HeroIcon[37] = "ReplaceableTextures\\CommandButtons\\BTNAsuma.blp"
        set udg_HeroMainStat[37] = STR_HERO
        set udg_HeroIsAvailable[37] = true
        set HeroeName[37] = "Asuma"
        // ==========
        set udg_Hero[38] = KAKUZU
        set udg_HeroIcon[38] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Kakuzu.blp"
        set udg_HeroMainStat[38] = INT_HERO
        set udg_HeroIsAvailable[38] = true
        set HeroeName[38] = "Kakuzu"
        // ==========
        set udg_Hero[39] = YUGITO
        set udg_HeroIcon[39] = "ReplaceableTextures\\CommandButtons\\BTNYugito.blp"
        set udg_HeroMainStat[39] = AGI_HERO
        set udg_HeroIsAvailable[39] = true
        set HeroeName[39] = "Yugito"
        // ==========
        set udg_Hero[40] = ANKO
        set udg_HeroIcon[40] = "ReplaceableTextures\\CommandButtons\\BTNIcon-Anko.blp"
        set udg_HeroMainStat[40] = STR_HERO
        set udg_HeroIsAvailable[40] = true
        set HeroeName[40] = "Anko"
        // ==========
        set udg_Hero[41] = JUUGO
        set udg_HeroIcon[41] = "ReplaceableTextures\\CommandButtons\\BTNJuugo.blp"
        set udg_HeroMainStat[41] = STR_HERO
        set udg_HeroIsAvailable[41] = true
        set HeroeName[41] = "Juugo"
        // ==========
        set udg_Hero[42] = SUIGETSU
        set udg_HeroIcon[42] = "ReplaceableTextures\\CommandButtons\\BTNSuigetsu.blp"
        set udg_HeroMainStat[42] = STR_HERO
        set udg_HeroIsAvailable[42] = true
        set HeroeName[42] = "Suigetsu"
        // ==========
        set udg_Hero[43] = MIZUKAGE
        set udg_HeroIcon[43] = "ReplaceableTextures\\CommandButtons\\BTNMizukage.blp"
        set udg_HeroMainStat[43] = INT_HERO
        set udg_HeroIsAvailable[43] = true
        set HeroeName[43] = "Mizukage"
        // ==========
        set udg_Hero[44] = RAIKAGE
        set udg_HeroIcon[44] = "ReplaceableTextures\\CommandButtons\\BTNRaikage.blp"
        set udg_HeroMainStat[44] = STR_HERO
        set udg_HeroIsAvailable[44] = true
        set HeroeName[44] = "Raikage"
        // ==========
        set udg_Hero[45] = ONOKI
        set udg_HeroIcon[45] = "ReplaceableTextures\\CommandButtons\\BTNTsuchikage.blp"
        set udg_HeroMainStat[45] = STR_HERO
        set udg_HeroIsAvailable[45] = true
        set HeroeName[45] = "Tsuchikage"
        // ==========
        set udg_Hero[46] = DANZO
        set udg_HeroIcon[46] = "ReplaceableTextures\\CommandButtons\\BTN_Danzo.blp"
        set udg_HeroMainStat[46] = AGI_HERO
        set udg_HeroIsAvailable[46] = true
        set HeroeName[46] = "Danzo"
        // ==========
        set udg_Hero[47] = PEIN
        set udg_HeroIcon[47] = "ReplaceableTextures\\CommandButtons\\BTNPein.blp"
        set udg_HeroMainStat[47] = INT_HERO
        set udg_HeroIsAvailable[47] = true
        set HeroeName[47] = "Pain"
        // ==========
        set udg_Hero[48] = MADARA
        set udg_HeroIcon[48] = "ReplaceableTextures\\CommandButtons\\BTNMadara.blp"
        set udg_HeroMainStat[48] = STR_HERO
        set udg_HeroIsAvailable[48] = true
        set HeroeName[48] = "Madara"
        // ==========
        set udg_Hero[49] = OBITO
        set udg_HeroIcon[49] = "ReplaceableTextures\\CommandButtons\\BTNObito.blp"
        set udg_HeroMainStat[49] = STR_HERO
        set udg_HeroIsAvailable[49] = true
        set HeroeName[49] = "Obito"
        // ==========
        set udg_Hero[50] = KILLER_BEE
        set udg_HeroIcon[50] = "ReplaceableTextures\\CommandButtons\\BTNKillerBee.blp"
        set udg_HeroMainStat[50] = AGI_HERO
        set udg_HeroIsAvailable[50] = true
        set HeroeName[50] = "Killer Bee"
        // ==========
        set udg_Hero[51] = SAI
        set udg_HeroIcon[51] = "ReplaceableTextures\\CommandButtons\\BTNSai.blp"
        set udg_HeroMainStat[51] = INT_HERO
        set udg_HeroIsAvailable[51] = true
        set HeroeName[51] = "Sai"
        // ===========
        set udg_Hero[52] = HAN
        set udg_HeroIcon[52] = "ReplaceableTextures\\CommandButtons\\BTNHan.blp"
        set udg_HeroMainStat[52] = STR_HERO
        set udg_HeroIsAvailable[52] = false
        set HeroeName[52] = "Han"
        // ===========
        set udg_Hero[53] = KARIN
        set udg_HeroIcon[53] = "ReplaceableTextures\\CommandButtons\\BTNKarin.blp"
        set udg_HeroMainStat[53] = STR_HERO
        set udg_HeroIsAvailable[53] = false
        set HeroeName[53] = "Karin"
        // ===========
        set udg_HeroAmount = 53
    endfunction

endlibrary