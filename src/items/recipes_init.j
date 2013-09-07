library ItemStartLib{    
    globals
        Table Shareable
        Table Parcial
    endglobals
}

scope ItemStart initializer Init

    define{
        ITEM_SHINOBI_CLAWS = 'I00L'
        ITEM_RUNNING_SHOES = 'I00E'
        ITEM_LEATHER_GLOVES = 'I00D'
        ITEM_AXE_OF_STR = 'I00R'
        ITEM_BLADE_OF_AGI = 'I06J'
        ITEM_STAFF_OF_FAITH = 'I00T'
        ITEM_IDATE_SANDALS_RECIPE = 'I026'
        ITEM_IDATE_SALDALS = 'I02G'
        ITEM_SHINOBI_TRENDS_STR = 'I02I'
        ITEM_SHINOBI_TRENDS_AGI = 'I058'
        ITEM_SHINOBI_TRENDS_INT = 'I059'
        ITEM_SAKURA_GLOVES = 'I02L'
        ITEM_CELESTIAL_SHIELD = 'I02J'
        ITEM_SPARK_OF_AGILITY = 'I02M'
        ITEM_SILVER_WATCH = 'I01G'
        ITEM_RING_OF_HEALTH = 'I01H'
        ITEM_REMI = 'I04E'
        ITEM_SHIN_GUARDS = 'I00M'
        ITEM_BELT_OF_STR = 'I06I'
        ITEM_SNAKE_SKIN = 'I00S'
        ITEM_ANBU_CLOAK = 'I06K'
    }

    private function Init takes nothing returns nothing
//SHAREABLES--------------------------------------------------------------------
        set Shareable = Table.create()
        set Shareable['I013'] = 1 // Sand Eyes
        set Shareable['I012'] = 1 // Soldier Pill
        set Shareable['I06P'] = 1 // Sand Eyes Improved
        set Shareable['I015'] = 1 // Food Supply
        set Shareable['I011'] = 1 // Medicine
        set Shareable['I016'] = 1 // Scroll of Town Portal
        set Shareable['I06O'] = 1 // Dust of Appareance
        set Shareable['I01R'] = 1 // Kyuubi Escence
        set Shareable['I00Y'] = 1 // Gem of True Sign
        set Shareable['I014'] = 1 // Animal Courier
        set Shareable['I06R'] = 1 // Flying Courier
        set Shareable['I06Q'] = 1 // Flying Courier Recipe
        set Parcial = Table.create()
        set Parcial[ITEM_RING_OF_HEALTH] = 1 // Ring of Health
        set Parcial['I00C'] = 1 // Ring of Reg
        set Parcial[ITEM_SILVER_WATCH] = 1 // Silver Watch
        set Parcial['I00H'] = 1 // Ambu
        set Parcial['I01N'] = 1 // Amplified
        set Parcial['I066'] = 1 // HW
        set Parcial['I068'] = 1 // HW 1/3
        set Parcial['I067'] = 1 // HW 2/3
        set Parcial['I069'] = 1 // HW DD
        set Parcial['I022'] = 1 // HW FULL
        set Parcial['I06C'] = 1 // HW HASTE 
        set Parcial['I06D'] = 1 // HW ILU
        set Parcial['I06B'] = 1 // HW INVI
        set Parcial['I06A'] = 1 // HW REG
//Combinaciones-----------------------------------------------------------------
        set RecipeSYS_PRELOAD_UNIT=CreateUnit(Player(15),'Hpal',4300,-4300,0)
        //****** RECIPES 1 ******
        call AddRecipe('I03T',ITEM_RUNNING_SHOES,0,0,0,0,'I03U')  //THE FOURTH'S LEGACY
        call AddRecipe(ITEM_RUNNING_SHOES,ITEM_SHINOBI_CLAWS,ITEM_SHINOBI_CLAWS,0,0,0,ITEM_IDATE_SALDALS)  //IDATE'S SANDALS
        call AddRecipe(ITEM_RUNNING_SHOES,ITEM_LEATHER_GLOVES,ITEM_BELT_OF_STR,0,0,0,ITEM_SHINOBI_TRENDS_STR)  //SHINOBI TRENDS OF STRENGTH
        call AddRecipe(ITEM_RUNNING_SHOES,ITEM_LEATHER_GLOVES,ITEM_SNAKE_SKIN,0,0,0,ITEM_SHINOBI_TRENDS_AGI)  //SHINOBI TRENDS OF AGILITY
        call AddRecipe(ITEM_RUNNING_SHOES,ITEM_LEATHER_GLOVES,ITEM_ANBU_CLOAK,0,0,0,ITEM_SHINOBI_TRENDS_INT)  //SHINOBI TRENDS OF INTELIGENCE
        call AddRecipe('I04Y',ITEM_LEATHER_GLOVES,     0,0,0,0,'I01T')  //TRANSMUTATION GLOVES
        call AddRecipe('I02A',ITEM_LEATHER_GLOVES,     0,0,0,0,'I02K')  //GAI'S FIST OF MIGHT
        call AddRecipe(ITEM_SILVER_WATCH,ITEM_RING_OF_HEALTH,     0,0,0,0,'I01N')  //AMPLIFIED SILVER WATCH
        call AddRecipe('I02B','I00N','I009',0,0,0,ITEM_SAKURA_GLOVES)  //SAKURA'S FIGHTING GLOVES
        call AddRecipe('I029','I00P','I009',0,0,0,ITEM_CELESTIAL_SHIELD)  //CELESTIAL SHIELD
        call AddRecipe('I02C','I00O','I009',0,0,0,ITEM_SPARK_OF_AGILITY)  //THE SPARK OF AGILITY
        
        call AddRecipe('I00Z',ITEM_LEATHER_GLOVES,ITEM_SHINOBI_CLAWS,ITEM_SPARK_OF_AGILITY,0,0,'I00V') // SEAL OF speed
        call AddRecipe('I019',ITEM_SILVER_WATCH,ITEM_SHINOBI_CLAWS,ITEM_CELESTIAL_SHIELD,0,0,'I00X') // SEAL OF chakra
        call AddRecipe('I010',ITEM_RING_OF_HEALTH,ITEM_SHINOBI_CLAWS,ITEM_SAKURA_GLOVES,0,0,'I00W') // SEAL OF power
    
        
        //****** RECIPES 2 ******
        call AddRecipe('I024','I04M','I03J',     0,0,0,'I02E')  //FIRST HOKAGE'S HECKLACE
        call AddRecipe('I04P','I00C','I02F','I00G',0,0,'I04Q')  //TOBI'S MASK
        call AddRecipe(ITEM_RUNNING_SHOES,'I01L',     0,     0,0,0,'I04S')  //JIRAYA'S SANDALS
        call AddRecipe('I06Q','I014',     0,     0,0,0,'I06R')  //FLYING COURIER
        call AddRecipe('I03Q','I00K','I06H',     0,0,0,'I03J')  //RETRACTABLE SHIELD
        call AddRecipe('I00H','I00Q',     0,     0,0,0,'I02F')  //AKATSUKI RING
        call AddRecipe('I02Y','I00A','I00H',     0,0,0,'I038')  //BINGO BOOK
        call AddRecipe('I004','I038','I01N',     0,0,0,'I042')  //KONGOU NYOI
        call AddRecipe('I04L','I00C','I06H',     0,0,0,'I04M')  //MAGATAMA AMULET
        //****** RECIPES 3 ******
        call AddRecipe('I01D',ITEM_SILVER_WATCH,'I00A',     0,     0,0,'I05G')  //SAGE SCROLL
        call AddRecipe('I060','I01E',ITEM_SILVER_WATCH,ITEM_STAFF_OF_FAITH,ITEM_LEATHER_GLOVES,0,'I05F')  //THE TOTSUKA
        call AddRecipe('I02W',ITEM_SILVER_WATCH,ITEM_STAFF_OF_FAITH,     0,     0,0,'I037')  //RENGEKI
        call AddRecipe('I03I',ITEM_SILVER_WATCH,'I00H',ITEM_STAFF_OF_FAITH,     0,0,'I03B')  //GIANT IRON FAN
        call AddRecipe('I047',ITEM_STAFF_OF_FAITH,ITEM_SHINOBI_CLAWS,     0,     0,0,'I04A')  //KARITES TOUCH LVL1
        call AddRecipe('I047','I04A',     0,     0,     0,0,'I005')  //KARITES TOUCH LVL2
        call AddRecipe('I047','I005',     0,     0,     0,0,'I006')  //KARITES TOUCH LVL3
        call AddRecipe('I047','I006',     0,     0,     0,0,'I007')  //KARITES TOUCH LVL4
        call AddRecipe('I03G','I01N','I01E',     0,     0,0,'I03O')  //HEXAGONAL CRYSTAL
        call AddRecipe('I01D','I037',  0,   0,     0,0,'I04C')  //HOSHIKAGE'S STAR
        //****** RECIPES 4 ******
        call AddRecipe('I02N','I00K','I06L','I02K',0,0,'I06M')  //HOKAGE ARMOR
        call AddRecipe('I01C',ITEM_RING_OF_HEALTH,'I01J',     0,0,0,'I01P')  //ONBU'S PAWN
        call AddRecipe('I03V',ITEM_AXE_OF_STR,'I008',     0,0,0,'I01M')  //GELEL STONE
        call AddRecipe('I04J','I01D','I06L',     0,0,0,'I04K')  //HAKU'S OVERCOAT
        call AddRecipe('I01O','I01N',     0,     0,0,0,'I03Z')  //DEMON BOOSTER
        call AddRecipe('I03F','I01N','I00A',     0,0,0,'I03N')  //CHAKRA ARMOR
        call AddRecipe(ITEM_SHIN_GUARDS,ITEM_RING_OF_HEALTH,'I01J',     0,0,0,ITEM_REMI)  //REMINISCE
        call AddRecipe('I00K','I00J','I06K',     0,0,0,'I03R')  //KAGUYA ARMOR
        call AddRecipe('I01K','I01J','I01L',     0,0,0,'I01O')  //TRINITY BOOSTER
        call AddRecipe(ITEM_RING_OF_HEALTH,'I00I','I04V',     0,0,0,'I04W')  //FLAK JACKET
        //****** RECIPES 5 ******
        call AddRecipe('I034','I033',     0,     0,     0,0,'I03P')  //TWIN-FANGS OF ABYSS
        call AddRecipe('I05A','I01C','I06F',     0,     0,0,'I057')  //JASHIN'S AMULET
        call AddRecipe('I062','I01U','I02K',     0,     0,0,'I061')  //IKAZUCHI
        call AddRecipe('I043','I01I','I00A',     0,     0,0,'I045')  //LUNAR SWORD
        call AddRecipe('I02T','I06I',ITEM_AXE_OF_STR,     0,     0,0,'I034')  //TRI-BLADES
        call AddRecipe('I00G','I06E',     0,     0,     0,0,'I06F')  //SARUTOBI'S HELM
        call AddRecipe('I03D','I00J',ITEM_LEATHER_GLOVES,     0,     0,0,'I01U')  //RAIJIN
        call AddRecipe('I008','I008','I03E',     0,     0,0,'I03M')  //KUSANAGI
        call AddRecipe('I02S','I00S',ITEM_BLADE_OF_AGI,     0,     0,0,'I033')  //SHUKO
        call AddRecipe('I027','I00G',     0,     0,     0,0,'I02H')  //NIDAIME'S HELM
        call AddRecipe(ITEM_BLADE_OF_AGI,ITEM_BLADE_OF_AGI,'I06K','I03K',0,0,'I03S')  //CHAKRA SMASHER
        call AddRecipe('I04H','I00F',     0,     0,     0,0,'I04I')  //POISON GAUNTLETS
        //****** RECIPES 6 ******
        call AddRecipe('I01F','I01E',     0,0,0,0,'I04X')  //AMENONUHOKO
        call AddRecipe('I06N','I06N','I01E',0,0,0,'I02D')  //CONCH SHELL MACE
        call AddRecipe('I044','I01F',     0,0,0,0,'I046')  //SOLAR BLADE
        call AddRecipe('I048','I01B','I00F',0,0,0,'I04B')  //GOOD GUY'S SUIT
        call AddRecipe('I03W','I032','I01E',0,0,0,'I03X')  //RAGNOROK
        call AddRecipe('I02P','I06I','I06N',0,0,0,'I030')  //IRON CROW
        call AddRecipe('I01N','I00J','I00B',0,0,0,'I01S')  //SILVER HANDS
        call AddRecipe('I039','I033','I00A',0,0,0,'I03C')  //PROBAGATION
        call AddRecipe('I02R','I00J',ITEM_SHINOBI_CLAWS,0,0,0,'I032')  //GALE BLADE
        call AddRecipe('I04T','I00B','I00F',0,0,0,'I04U')  //ASSASSIN'S CLOAK
        call RemoveUnit(RecipeSYS_PRELOAD_UNIT)
        set RecipeSYS_PRELOAD_UNIT=null
    endfunction
endscope