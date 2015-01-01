library HeroPick initializer Init requires TimerUtils

    globals
        private boolean array triggersEnabled // verifica si un heroe fue guardado ya o no
    endglobals

    function TurnOnOffHeroTriggers takes unit u, boolean On returns nothing
        local integer UnitType = GetUnitTypeId(u)
        local integer index = GetUnitPointValue(u)
        if triggersEnabled[index] then
            return
        endif
        if UnitType==ANKO then//***ANKO***
            call EnableTrigger( gg_trg_Hook )
            call ExecuteFunc("SnakeProtection_Init")
            call ExecuteFunc("Venom_Init")
            call ExecuteFunc("TwinSnakes_Init")
            debug call BJDebugMsg("++anko")
        elseif UnitType==ASUMA then//***ASUMA***
            call EnableTrigger( gg_trg_AsumaCall )
            call EnableTrigger( gg_trg_Asuma_Katon )
            call ExecuteFunc("HeinLearn_Init")
            call ExecuteFunc("AsumaKaton_Init")
            call ExecuteFunc("DSHein_Init")
            call ExecuteFunc("WillOfFire_Init")
            debug call BJDebugMsg("++asuma")
        elseif UnitType==CHOUJI then//***CHOUYI***
            call EnableTrigger( gg_trg_Chouji_Slam )
            call EnableTrigger( gg_trg_Crater )
    //      call EnableTrigger( gg_trg_Chouyi_Baika_No_Jutsu )
            call EnableTrigger( gg_trg_Return )
            call EnableTrigger( gg_trg_Chouyi_Ultimate )
        elseif UnitType==DANZO then//***DANZO***
            call ExecuteFunc("Cruel_Init")
            call ExecuteFunc("Izanagi_Init")
            call ExecuteFunc("Vacuum_Init")
            call ExecuteFunc("Baku_Init")
        elseif UnitType==DEIDARA then//***DEIDARA***
            call EnableTrigger( gg_trg_SummonClaySpiders )
            call EnableTrigger( gg_trg_Detonate )
            //call EnableTrigger( gg_trg_C3 )
            call ExecuteFunc("C3_Init")
            call EnableTrigger( gg_trg_FireFly )
        elseif UnitType==GAARA then//***GAARA***
            call EnableTrigger( gg_trg_Avalanche )
            call EnableTrigger( gg_trg_Earthquake )
            call ExecuteFunc("Ataud_Init")
        elseif UnitType==GUY then//***GUY***
            call ExecuteFunc("DynamicEntry_Init")
            call EnableTrigger( gg_trg_Gai_Fervor )
            call EnableTrigger( gg_trg_Gai_Fervor_Attacked )
            call EnableTrigger( gg_trg_Gai_Ultimate )
            call ExecuteFunc("DSGuy_Init")
        elseif UnitType==HAKU then//***HAKU***
            call ExecuteFunc("HakuBlizzard_Init")
            call ExecuteFunc("HakuSembon_Init")
        elseif UnitType==HINATA then//***HINATA***
            call ExecuteFunc("DSJyuken_Init")
            call ExecuteFunc("DSByakugan_Init")
            call ExecuteFunc("HinataUltimate_Init")
            call ExecuteFunc("TwinLions_Init")
            call ExecuteFunc("HinataByakugan_Init")
            call EnableTrigger( gg_trg_Hinata_Ultimate )
        elseif UnitType==INO then//***INO***
            call ExecuteFunc("InoHold_Init")
            call EnableTrigger( gg_trg_Ino_Ninpou )
            call EnableTrigger( gg_trg_Ino_Ultimate )
            call EnableTrigger( gg_trg_Ino_Ultimate_Learn )
        elseif UnitType==ITACHI then//***ITACHI***
            call EnableTrigger( gg_trg_Itachi_Blink )
            call EnableTrigger( gg_trg_Amateratsu )
            call ExecuteFunc("AmateratsuLearn_Init")
            call ExecuteFunc("ItachiMangekyu_Init")
            call ExecuteFunc("ItachiSharingan_Init")
        elseif UnitType==JIRAIYA then//***JIRAYA***
            call ExecuteFunc("Katon_Init")
            call ExecuteFunc("SonicWave_Init")
            call ExecuteFunc("HariJizo_Init")
            call EnableTrigger( gg_trg_Odama_Rasengan )
        elseif UnitType==JIROBOU then//***JIROBO***
            call EnableTrigger( gg_trg_Fissure )
            call EnableTrigger( gg_trg_Aftershock )
            call EnableTrigger( gg_trg_EchoSlam )
            call ExecuteFunc("DSRakaken_Init")
        elseif UnitType==JUUGO then//***JUUGO***
            call EnableTrigger( gg_trg_JumpSlam )
            call EnableTrigger( gg_trg_Enrage_Cast )
            call EnableTrigger( gg_trg_Enrage_Hp_Boost )
            call EnableTrigger( gg_trg_Consume )
            call ExecuteFunc("DSEnrage_Init")
        elseif UnitType==KABUTO then//***KABUTO***
            call EnableTrigger( gg_trg_Scalpels )
            call EnableTrigger( gg_trg_Regeneration )
            call EnableTrigger( gg_trg_SleepAOE )
            call EnableTrigger( gg_trg_SleepAOE_Awake )
            call ExecuteFunc("DSScalpels_Init")
        elseif UnitType==KAKASHI then//***KAKASHI***
            call ExecuteFunc("Dogs_Init")
            call ExecuteFunc("Chidori_Init")
            call ExecuteFunc("SharinganLearn_Init")
            call ExecuteFunc("SharinganCopyCast_Init")
            call ExecuteFunc("SharinganCastCopied_Init")
            call ExecuteFunc("CopiedPoisonCloud_Init")
            call ExecuteFunc("LightningCloneCast_Init")
            call ExecuteFunc("ChidoriLearn_Init")
        elseif UnitType==KAKUZU then//***KAKUZU***
            call EnableTrigger( gg_trg_FirePath )
            call EnableTrigger( gg_trg_LigthningBolt )
            call EnableTrigger( gg_trg_WaterWall )
            call EnableTrigger( gg_trg_Jiongu )
            call EnableTrigger( gg_trg_DarkForm )
            call ExecuteFunc("DarkFormLearn_Init")
            debug call BJDebugMsg("++kakuzu")
        elseif UnitType==KANKURO then//***KANKURO***
            call EnableTrigger( gg_trg_Kuroari )
            call EnableTrigger( gg_trg_Karasu )
            call EnableTrigger( gg_trg_Poison_Cloud )
            call ExecuteFunc("Sanshouuo_Init")
            call ExecuteFunc("DSUltimateDefence_Init")
        elseif UnitType==KIBA then//***KIBA***
            call EnableTrigger( gg_trg_Gatsuga )
            call EnableTrigger( gg_trg_Summon_Akamaru )
            call EnableTrigger( gg_trg_Kiba_Ulti )
            call ExecuteFunc("Shikakyu_Init")
        elseif UnitType == KIDOMARU then//***KIDOUMARU***
            call EnableTrigger( gg_trg_Kido_Web )
            call ExecuteFunc("KidomaruSeal_Init")
            call ExecuteFunc("KidoUlti_Init")
            call ExecuteFunc("KidoArrow_Init")
            call EnableTrigger( gg_trg_Kido_Ulti_Learn )
        elseif UnitType==KIMIMARO then//***KIMI***
            call EnableTrigger( gg_trg_Kimi_Bone_Cast )
            call EnableTrigger( gg_trg_Kimi_Sawarami )
            call EnableTrigger( gg_trg_Kimi_Sawarani_Dead )
        elseif UnitType==KISAME then//***KISAME***
            call ExecuteFunc("Shark_Init")
            call ExecuteFunc("SymbioticRelationship_Init")
            call EnableTrigger( gg_trg_Kisame_Ultimate_Slow_Aura)
            call ExecuteFunc("WaterBubble_Init")
            call ExecuteFunc("DSManaSuck_Init")
            call ExecuteFunc("SamehadaFeasts_Init")
        elseif UnitType==ROCKLEE then//***LEE/***
            call EnableTrigger( gg_trg_Omote_Renge )
            call EnableTrigger( gg_trg_Lee_Damage_Attacked )
            call EnableTrigger( gg_trg_Lee_Ultimate )
            call ExecuteFunc("LeeMiss_Init")
            call ExecuteFunc("DSLee_Init")
            debug call BJDebugMsg("++rocklee")
        elseif UnitType==MADARA then//***MADARA/***
            call ExecuteFunc("MadaraKaton_Init")
            call ExecuteFunc("Eternal_Init")
            call ExecuteFunc("MadaraRinnegan_Init")
            call ExecuteFunc("GodPower_Init")
        elseif UnitType==MIZUKAGE then//***MIZUKAGE/***
            call ExecuteFunc("FireBall_Init")
            call ExecuteFunc("LavaRelease_Init")
            call ExecuteFunc("Cloud_Init")
            call ExecuteFunc("Perseverance_Init")
        elseif UnitType==NARUTO then//***NARUTO***
            call EnableTrigger( gg_trg_CloneJutsus )
            call EnableTrigger( gg_trg_CloneBlink )
            call EnableTrigger( gg_trg_Naruto_Ultimate )
            call EnableTrigger( gg_trg_Rasenshuriken_Learn )
        elseif UnitType==NEJI then//***NEJI***
            call ExecuteFunc("Kaiten_Init")
            call ExecuteFunc("InternalBleeding_Init")
            call ExecuteFunc("ByakuganTrueSight_Init")
            call ExecuteFunc("NejiUlti_Init")
        elseif UnitType==NIDAIME then//***NIDAIME***
            call EnableTrigger( gg_trg_Splash )
            call EnableTrigger( gg_trg_Nidaime_Darkness )
            call ExecuteFunc("Waveform_Init")
        elseif UnitType==ONOKI then//***ONOKI***
            call ExecuteFunc("DustRelease_Init")
            call ExecuteFunc("Stalagmite_Init")
            call ExecuteFunc("OnokiUlti_Init")
            call ExecuteFunc("DSStalagmiteArmor_Init")
        elseif UnitType==OROCHIMARU then//***OROCHIMARU***
            call EnableTrigger( gg_trg_Orochimaru_Bite )
            call EnableTrigger( gg_trg_Sunder )
            call ExecuteFunc("KusanagiStrike_Init")
            call ExecuteFunc("SunderLearn_Init")
            call ExecuteFunc("LearnKusanagi_Init")
        elseif UnitType==PEIN then//***PEIN***
            call ExecuteFunc("PeinRinnegan_Init")
            call ExecuteFunc("BanshoTenin_Init")
            call ExecuteFunc("ShinraTensei_Init")
            call ExecuteFunc("ChibakuTentei_Init")
        elseif UnitType==RAIKAGE then//***RAIKAGE***
            call ExecuteFunc("RaikageUltimate_Init")
            call ExecuteFunc("RaikageSegundo_Init")
            call ExecuteFunc("RaikagePasive_Init")
            call ExecuteFunc("RaikagePrimero_Init")
            call ExecuteFunc("DSRaikagePassive_Init")
        elseif UnitType==SAKON then//***SAKON***
            call EnableTrigger( gg_trg_Charge )
            call EnableTrigger( gg_trg_Sakon_Curse )
            call ExecuteFunc("SakonCurse_Init")
            call EnableTrigger( gg_trg_Summon_Ukon )
            call EnableTrigger( gg_trg_Sakon_Ulti_Remove_Ukon )
        elseif UnitType==SAKURA then//***SAKURA***
            call ExecuteFunc("SakuraStomp_Init")
            call ExecuteFunc("Cha_Init")
            call ExecuteFunc("DSSakura_Init")
            call ExecuteFunc("BurstFx_Init")
        elseif UnitType==SARUTOBI then//***SARUTOBI***
            call EnableTrigger( gg_trg_Sarutobi_Katon )
            call EnableTrigger( gg_trg_Shurikens )
            call EnableTrigger( gg_trg_Sarutobi_Ultimate_Start )
            call EnableTrigger( gg_trg_Sarutobi_Ultimate_Learn )
        elseif UnitType==SASUKE then//***SASUKE***
            call EnableTrigger( gg_trg_Chidori_Nagashi )
            call EnableTrigger( gg_trg_Chidori_Enzo )
            call EnableTrigger( gg_trg_Chokuto_FX )
            call EnableTrigger( gg_trg_Kirin )
            call ExecuteFunc("DSChokuto_Init")
        elseif UnitType==SHIKAMARU then//***SHIKAMARU
            call ExecuteFunc("KageMane_Init")
            call ExecuteFunc("ExplosionKunai_Init")
            call ExecuteFunc("Meditation_Init")
            debug call BJDebugMsg("++shikamaru")
        elseif UnitType==SHINO then//***SHINO***
            call ExecuteFunc("Release_Init")
            call ExecuteFunc("BugShieldStart_Init")
        elseif UnitType==SHODAIME then//***SHODAIME***
            call EnableTrigger( gg_trg_Sprout )
            call EnableTrigger( gg_trg_Living_Tree )
            call EnableTrigger( gg_trg_Forest )
        elseif UnitType==SUIGETSU then//***SUIGETSU***
            call ExecuteFunc("DSSuigetsuSuika_Init")
            call ExecuteFunc("SuikaLearn_Init")
            call ExecuteFunc("Demon_Init")
            call ExecuteFunc("Torrent_Init")
        elseif UnitType==TAYUYA then//***TAYUYA***
            call EnableTrigger( gg_trg_Mateki )
            call EnableTrigger( gg_trg_Tayuya_Cursed_Seal )
            call EnableTrigger( gg_trg_Doki_Summon )
            call EnableTrigger( gg_trg_Doki_UnSummon_If_Tayuya_Died )
            call EnableTrigger( gg_trg_Doki_Die )
            call ExecuteFunc("Song_Init")
            debug call BJDebugMsg("++tayuya")
        elseif UnitType==TENTEN then//***TENTEN***
            call EnableTrigger( gg_trg_Tenten_Change_Form )
            call ExecuteFunc("Dagger_Init")
            call ExecuteFunc("TentenUlti_Init")
        elseif UnitType==TEMARI then//***TEMARI***
            call ExecuteFunc("Gust_Init")
            call EnableTrigger( gg_trg_Tornado )
            call EnableTrigger( gg_trg_Gran_Tornado )
            call EnableTrigger( gg_trg_Sheer_Wind )
        elseif UnitType==TSUNADE then//***TSUNADE***
            call ExecuteFunc("Repel_Init")
            call ExecuteFunc("MassHeal_Init")
            call ExecuteFunc("EarthSlam_Init")
            call ExecuteFunc("HealTarget_Init")
        elseif UnitType==YAMATO then//***YAMATO***
            call EnableTrigger( gg_trg_Caja )
            call EnableTrigger( gg_trg_Yamato_Ulti_FX )
            call ExecuteFunc("YamatoClone_Init")
        elseif UnitType==YUGITO then//***YUGITO***
            call EnableTrigger( gg_trg_Fuuma_Shuriken )
            call EnableTrigger( gg_trg_Seal_Place )
            call EnableTrigger( gg_trg_Seal_Explote )
            call EnableTrigger( gg_trg_Yugito_Heal )
            call EnableTrigger( gg_trg_NibiForm_Learn )
            call EnableTrigger( gg_trg_NibiForm_Start )
            call EnableTrigger( gg_trg_Claw )
            call EnableTrigger( gg_trg_Pounce )
            call EnableTrigger( gg_trg_FireBreath )
            call ExecuteFunc("NibiFormLearn_Init")
            call ExecuteFunc("DSNiiClaw_Init")
            debug call BJDebugMsg("yugito++")
        elseif UnitType==MINATO then//***YONDAIME***
            call EnableTrigger( gg_trg_DashStrike )
            call EnableTrigger( gg_trg_Rasengan_Cast )
            call EnableTrigger( gg_trg_Rasengan_Animation )
            call EnableTrigger( gg_trg_Agile_Movement )
            call EnableTrigger( gg_trg_Omnislash )
            call EnableTrigger( gg_trg_Omnislash_Learn )
            call ExecuteFunc("DSRasengan_Init")
        elseif UnitType==ZABUZA then//***ZABUZA***
            call ExecuteFunc("TimedCritical_Init")
            call ExecuteFunc("DSTimedCritical_Init")
            call ExecuteFunc("TrackSlow_Init")
            call ExecuteFunc("SmokeScreen_Init")
            call EnableTrigger( gg_trg_Blink_Strike )
            call EnableTrigger( gg_trg_Track_Learn )
        elseif UnitType==OBITO
            ExecuteFunc("ChakraChains_Init")
            ExecuteFunc("FlameBattle_Init")
            ExecuteFunc("BranchArmor_Init")
            ExecuteFunc("Kamui_Init")
            //BJDebugMsg("obito..")
        endif
        set triggersEnabled[index]=true
    endfunction

    function RegisterHeroToPlayer takes unit u, player p returns nothing
        local integer PlayerId = GetPlayerId(p)+1
        local integer UnitType = GetUnitTypeId(u)
        local integer UnitIndex = GetUnitPointValue(u)
        local integer i
        // UN SOLO HEROE
        call SetPlayerTechMaxAllowed(p, 'HERO', 0)
        // REGISTER HEROE FOR PLAYER
        set udg_PlayerHero[ PlayerId ] = u
        // MAKE BUYED HEROE UNAVAILABLE FOR REPICK / RANDOM
        set udg_HeroIsAvailable[UnitIndex] = false
        // SET MULTIBOARD HERO ICON
        call MultiboardSetItemIconBJ( bj_lastCreatedMultiboard, 1, udg_Multiboard_Row_For_Player[PlayerId], udg_HeroIcon[UnitIndex] )
        // MAKE BUYED HEROE UNAVAILABLE FOR PURCHASE
        set i = 1
        loop
            exitwhen i > 11
            call SetPlayerTechMaxAllowed(Player(i), UnitType, 0)
            set i = i + 1
        endloop
        // TURN ON THE HERO SPELL TRIGGERS
        call TurnOnOffHeroTriggers(u,true)
        // CAMBIAR NOMBRE AL PLAYER
        call SetPlayerName(p,udg_PlayerRealName[GetPlayerId(p)]+" ("+HeroeName[UnitIndex]+") ")
    endfunction

    function UnregisterHeroToPlayer takes unit u, player p returns nothing
        local integer PlayerId = GetPlayerId(p)+1
        local integer UnitType = GetUnitTypeId(u)
        local integer UnitIndex = GetUnitPointValue(u)
        local integer i

        // UNREGISTER HEROE FOR PLAYER
        set udg_PlayerHero[ PlayerId ] = null
        // SET MULTIBOARD NOHERO ICON
        call MultiboardSetItemIconBJ( bj_lastCreatedMultiboard, 1, udg_Multiboard_Row_For_Player[PlayerId], "ReplaceableTextures\\WorldEditUI\\Editor-Random-Unit.blp" )
        // MAKE BUYED HEROE AVAILABLE FOR REPICK / RANDOM
        set udg_HeroIsAvailable[UnitIndex] = true
        // MAKE BUYED HEROE AVAILABLE FOR PURCHASE
        set i = 1
        loop
            exitwhen i > 11
            call SetPlayerTechMaxAllowed(Player(i), UnitType, -1)
            set i = i + 1
        endloop
        // TURN OFF THE HERO SPELL TRIGGERS
        call TurnOnOffHeroTriggers(u,false)
        call SetPlayerName(p,udg_PlayerRealName[PlayerId-1])
    endfunction

    function ChoseRandomHero takes integer MainStat returns integer
        local integer i
        local integer j
        local integer array AvailableHeroes

        set i = 1
        set j = 0
        loop
           exitwhen i > udg_HeroAmount
            if udg_HeroIsAvailable[i] == true and (MainStat==0 or MainStat==udg_HeroMainStat[i]) then
               set j = j + 1
               set AvailableHeroes[j] = i
            endif
            set i = i + 1
        endloop

        set i = AvailableHeroes[GetRandomInt(1,j)]
        set udg_HeroIsAvailable[i] = false
        return udg_Hero[i]
    endfunction
    
    globals
        private real randomTime = 0.5
    endglobals
    
    private function Expire takes nothing returns nothing
        local unit Unit
        local real X
        local real Y
        local timer t=GetExpiredTimer()
        local integer id=GetHandleId(t)
        local player p=LoadPlayerHandle(HT,id,0)
        local integer PlayerId=GetPlayerId(p)+1
        if udg_PlayerHero[PlayerId]==null then
           if PlayerId < 7 then
              set X = GetRectCenterX(gg_rct_Konoha_Hero_Spawn)
              set Y = GetRectCenterY(gg_rct_Konoha_Hero_Spawn)
           else
              set X = GetRectCenterX(gg_rct_Shinobi_Hero_Spawn)
              set Y = GetRectCenterY(gg_rct_Shinobi_Hero_Spawn)
           endif
           set Unit = CreateUnit(p,ChoseRandomHero(0), X,Y, 0)
           call DisplayTimedTextToForce(bj_FORCE_ALL_PLAYERS, 10, "A player has randomed "+GetUnitName(Unit))
           call RegisterHeroToPlayer(Unit,p)
           if GetLocalPlayer() == p then
              call PanCameraToTimed(X,Y, 0)
           endif
           set Unit = null
        endif
        call ReleaseTimer(t)
        set t=null
        set p=null
    endfunction

    function RandomHerosForAllPlayers takes nothing returns nothing
        local timer t
        if udg_observer1!=GetEnumPlayer() and udg_observer2!=GetEnumPlayer() then
            set t=NewTimer()
            call SavePlayerHandle(HT,GetHandleId(t),0,GetEnumPlayer())
            call TimerStart(t,randomTime,false,function Expire)
            set randomTime=randomTime+2.0
            set t=null
        endif
    endfunction

    function Trig_Hero_Pick_Actions takes nothing returns nothing
        local unit Unit
        local unit OldUnit
        local real X
        local real Y
        local integer PlayerId
        local player p

        //********* PICK *********
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELL then
           set Unit = GetSoldUnit()
           set p = GetOwningPlayer(Unit)
           set PlayerId = GetPlayerId(p)+1
           if IsUnitType(Unit, UNIT_TYPE_HERO)==true then
              //Remove Chooser Filler abilities of SD mode
              call UnitRemoveAbility( GetSellingUnit(), 'A00F' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0EP' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0DP' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0DO' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0DN' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0DM' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0CW' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0ER' )
              call UnitRemoveAbility( GetSellingUnit(), 'A0D6' )

              call DisplayTimedTextToForce( GetPlayersAll(), 10, "A player has chosen "+GetUnitName(Unit) )
              call RegisterHeroToPlayer(Unit,p)

              if PlayerId < 7 then
                 set X = GetRectCenterX(gg_rct_Konoha_Hero_Spawn)
                 set Y = GetRectCenterY(gg_rct_Konoha_Hero_Spawn)
              else
                 set X = GetRectCenterX(gg_rct_Shinobi_Hero_Spawn)
                 set Y = GetRectCenterY(gg_rct_Shinobi_Hero_Spawn)
              endif
              call SetUnitX(Unit, X)
              call SetUnitY(Unit, Y)
              if GetLocalPlayer() == p then
                 call PanCameraToTimed(X,Y, 0)
              endif
           endif
           set Unit = null
        //********* REPICK *********
        elseif GetEventPlayerChatString()=="-repick" then
           set p = GetTriggerPlayer()
           set PlayerId = GetPlayerId(p)+1
           if udg_PlayerHero[PlayerId]!=null then
              if TimerGetElapsed(udg_Game_Timer)>85 then
                 call DisplayTimedTextToPlayer(p,0,0,2.00,"|cffffcc00Repick time has ended.|r")
              elseif udg_PlayerRepick[PlayerId]==true then
                 call DisplayTimedTextToPlayer(p,0,0,2.00,"|cffffcc00No more repicks.|r")
              else
                 set OldUnit = udg_PlayerHero[PlayerId]

                 if udg_GameMode == 2 then //Game Random
                    if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= 250 then
                       set udg_PlayerRepick[PlayerId] = true
                       call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - 250)

                       set Unit = ReplaceUnitBJ(OldUnit, ChoseRandomHero(0), bj_UNIT_STATE_METHOD_RELATIVE )

                       call UnregisterHeroToPlayer(OldUnit,p)

                       call DisplayTimedTextToForce( GetPlayersAll(), 10, "A player has repicked "+GetUnitName(Unit) )
                       call RegisterHeroToPlayer(Unit,p)
                       if GetLocalPlayer() == p then
                          call PanCameraToTimed(GetUnitX(Unit),GetUnitY(Unit), 0)
                       endif
                       set Unit = null
                    else
                       call DisplayTimedTextToPlayer(p,0.5,0,2.00,"|cffffcc00Not enough gold.|r")
                    endif
                 elseif udg_GameMode == 1 then //Game AllPick
                    set udg_PlayerRepick[PlayerId] = true
                    call UnregisterHeroToPlayer( OldUnit,p )
                    call UnitRemoveItemFromSlot( OldUnit,0 )
                    call UnitRemoveItemFromSlot( OldUnit,1 )
                    call UnitRemoveItemFromSlot( OldUnit,2 )
                    call UnitRemoveItemFromSlot( OldUnit,3 )
                    call UnitRemoveItemFromSlot( OldUnit,4 )
                    call UnitRemoveItemFromSlot( OldUnit,5 )
                    call RemoveUnit(OldUnit)
     //               call SetPlayerTechMaxAllowed(p, 'HERO', 1)
    //                call SetPlayerTechMaxAllowed(p, 'HERO', GetPlayerTechCount(p, 'HERO', true)+1)
                    call SetPlayerTechMaxAllowed(p, 'HERO', 10)

                    if GetLocalPlayer() == p then
                       call PanCameraToTimed(14335,1469, 0)
                    endif
                 endif
                 set OldUnit = null
                 set Unit = null
              endif
           endif
        //********* RANDOM *********
        elseif GetEventPlayerChatString()=="-random" then
           set p = GetTriggerPlayer()
           set PlayerId = GetPlayerId(p)+1
           if udg_GameMode==1 and udg_PlayerRepick[PlayerId]==false then
              if udg_PlayerHero[PlayerId]==null then
                 if TimerGetElapsed(udg_Game_Timer)>85 then
                    call DisplayTimedTextToPlayer(p,0,0,2.00,"|cffffcc00Random pick time has ended.|r")
                 else
                    if PlayerId < 7 then
                       set X = GetRectCenterX(gg_rct_Konoha_Hero_Spawn)
                       set Y = GetRectCenterY(gg_rct_Konoha_Hero_Spawn)
                    else
                       set X = GetRectCenterX(gg_rct_Shinobi_Hero_Spawn)
                       set Y = GetRectCenterY(gg_rct_Shinobi_Hero_Spawn)
                    endif
                    set Unit = CreateUnit(p,ChoseRandomHero(0), X,Y, 0)

                    call DisplayTimedTextToForce( GetPlayersAll(), 10, "A player has randomed "+GetUnitName(Unit) )
                    call RegisterHeroToPlayer(Unit,p)
                    if GetLocalPlayer() == p then
                       call PanCameraToTimed(X,Y, 0)
                    endif
                    set Unit = null
                 endif
              endif
           endif
        //********* ANY AR MODE *********
    //    else
    //       call ForForce( GetPlayersAll(), function RandomHerosForAllPlayers )
        endif
    endfunction

    private function Init takes nothing returns nothing
        local integer index = 0
        local player p
        trigger t = CreateTrigger()
        loop
            set p = Player(index)
            call TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_SELL, null)
            call TriggerRegisterPlayerChatEvent(t, p, "-repick", true )
            call TriggerRegisterPlayerChatEvent(t, p, "-random", true )
            set index = index + 1
            exitwhen index == bj_MAX_PLAYER_SLOTS
        endloop
        call TriggerAddAction( t, function Trig_Hero_Pick_Actions )
        set p = null
    endfunction
    
endlibrary