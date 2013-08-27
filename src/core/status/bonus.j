library Bonus initializer init requires TimerUtils,AbilityPreload

    globals
        private constant integer ABIL_DAMAGE = 'A5B@'
        private constant integer LEVELS_DAMAGE=15
        private constant integer ABIL_ARMOR='A5A@'
        private constant integer LEVELS_ARMOR = 10
        private constant integer ABIL_ATTACK_SPEED='A5F@'
        private constant integer LEVELS_ATTACK_SPEED=9
        private constant integer ABIL_MANA='A5H@'
        private constant integer LEVELS_MANA=15
        
        private integer array twoPow
        constant integer BONUS_TYPE_DAMAGE = 1
        constant integer BONUS_TYPE_ARMOR = 2
        constant integer BONUS_TYPE_ATTACKSPEED = 3
        constant integer BONUS_TYPE_MANA = 4
        
        private constant string DAMAGE="Status|DamageBonus"
        private constant string ARMOR="Status|ArmorBonus"
        private constant string MANA="Status|ManaBonus"
        private constant string ATTACKSPEED="Status|AttackSpeedBonus"
    endglobals
    
    private function init takes nothing returns nothing
        local integer i=0
        local integer val=1
        local integer abil
            //! textmacro Status__PreloadBonus takes BONUS
                set abil=ABIL_$BONUS$+LEVELS_$BONUS$
                loop
                    call AbilityPreload(abil)
                    exitwhen abil==ABIL_$BONUS$
                    set abil=abil-1
                endloop
            //! endtextmacro
            //! runtextmacro Status__PreloadBonus("ARMOR")
            //! runtextmacro Status__PreloadBonus("DAMAGE")
            //! runtextmacro Status__PreloadBonus("ATTACK_SPEED")
            //! runtextmacro Status__PreloadBonus("MANA")
        loop
            set twoPow[i]=val
            exitwhen i==30
            set i=i+1
            set val=val*2
        endloop
    endfunction

//! textmacro Status__CreateAbilities
		//! externalblock extension=lua ObjectMerger $FILENAME$
                //! i setobjecttype("abilities")
                //! i myChar={}
                //! i myChar[1]="A"
                //! i myChar[2]="B"
                //! i myChar[3]="C"
                //! i myChar[4]="D"
                //! i myChar[5]="E"
                //! i myChar[6]="F"
                //! i myChar[7]="G"
                //! i myChar[8]="H"
                //! i myChar[9]="I"
                //! i myChar[10]="J"
                //! i myChar[11]="K"
                //! i myChar[12]="L"
                //! i myChar[13]="M"
                //! i myChar[14]="N"
                //! i myChar[15]="O"
                //! i myChar[16]="P"
                //! i myChar[17]="Q"
                //! i myChar[18]="R"
                //! i myChar[19]="S"
                //! i myChar[20]="T"
                //! i myChar[21]="U"
                //! i myChar[22]="V"
                //! i myChar[23]="W"
                //! i myChar[24]="X"
                //! i myChar[25]="Y"
                //! i myChar[26]="Z"
                //! i myBin={}
                //! i myBin[1]=1
                //! i myBin[2]=2
                //! i myBin[3]=4
                //! i myBin[4]=8
                //! i myBin[5]=16
                //! i myBin[6]=32
                //! i myBin[7]=64
                //! i myBin[8]=128
                //! i myBin[9]=256
                //! i myBin[10]=512
                //! i myBin[11]=1024
                //! i myBin[12]=2048
                //! i myBin[13]=4096
                //! i myBin[14]=8192
                //! i myBin[15]=16384
                //! i myBin[16]=32768
                //! i myBin[17]=65536
                //! i myBin[18]=131072
                //! i myBin[19]=262144
                //! i myBin[20]=524288
                //! i myBin[21]=1048576
                //! i myBin[22]=2097152
                //! i myBin[23]=4194304
                //! i myBin[24]=8388608
                //! i myBin[25]=16777216
                //! i myBin[26]=33554432
                // Armor (10 = 1023 max)
                //! i for i=1,10 do
                    //! i createobject("AId1","A5A"..myChar[i])
                    //! i makechange(current,"Idef",1,myBin[i])
                    //! i makechange(current,"anam","Armor Bonus")
                    //! i makechange(current,"ansf","(Status System)")
                //! i end
                //! i createobject("AId1","A5A@")
                //! i makechange(current,"Idef",1,-myBin[11])
                //! i makechange(current,"anam","Armor Bonus")
                //! i makechange(current,"ansf","(Status System)")
                // Damage (15 = 32767 max)
                //! i for i=1,15 do
                    //! i createobject("AItg","A5B"..myChar[i])
                    //! i makechange(current,"Iatt",1,myBin[i])
                    //! i makechange(current,"anam","Damage Bonus")
                    //! i makechange(current,"ansf","(Status System)")
                //! i end
                //! i createobject("AItg","A5B@")
                //! i makechange(current,"Iatt",1,-myBin[16])
                //! i makechange(current,"anam","Damage Bonus")
                //! i makechange(current,"ansf","(Status System)")
                // Attack Speed (9 = 511% max)
                //! i for i=1,9 do
                    //! i createobject("AIsx","A5F"..myChar[i])
                    //! i makechange(current,"Isx1",1,myBin[i]*0.01)
                    //! i makechange(current,"anam","Attack Speed Bonus")
                    //! i makechange(current,"ansf","(Status System)")
                //! i end
                //! i createobject("AIsx","A5F@")
                //! i makechange(current,"Isx1",1,-myBin[10]*0.01)
                //! i makechange(current,"anam","Attack Speed Bonus")
                //! i makechange(current,"ansf","(Status System)")
                // Mana (15 = 32767 max)
                //! i for i=1,15 do
                    //! i createobject("AImz","A5H"..myChar[i])
                    //! i makechange(current,"Iman",1,myBin[i])
                    //! i makechange(current,"anam","Mana Bonus")
                    //! i makechange(current,"ansf","(Status System)")
                //! i end
                //! i createobject("AImz","A5H@")
                //! i makechange(current,"Iman",1,-myBin[21])
                //! i makechange(current,"anam","Mana Bonus")
                //! i makechange(current,"ansf","(Status System)")
        //! endexternalblock
//! endtextmacro

////! runtextmacro Status__CreateAbilities()

        private function setBonus takes unit u, integer abil, integer levels, integer amount returns nothing
            local boolean addNeg=false
            if amount<0 then
                set addNeg=true
                set amount=amount+twoPow[levels]
            else
                call UnitMakeAbilityPermanent(u,false,abil)
                call UnitRemoveAbility(u,abil)
            endif
            
            set abil=abil+levels
            set levels=twoPow[levels]
            loop
                set levels=levels/2
                if amount>=levels then
                    call UnitAddAbility(u,abil)
                    call UnitMakeAbilityPermanent(u,true,abil)
                    set amount=amount-levels
                else
                    call UnitMakeAbilityPermanent(u,false,abil)
                    call UnitRemoveAbility(u,abil)
                endif
                set abil=abil-1
                exitwhen levels==1
            endloop
            if addNeg then
                call UnitAddAbility(u,abil)
                call UnitMakeAbilityPermanent(u,true,abil)
            endif
        endfunction
        
        globals//locals
            private integer AMOUNT=0
            private integer ID=0
        endglobals
        
        function DamageBonus takes unit whichUnit,integer amount returns nothing
            set ID=GetHandleId(whichUnit)
            set AMOUNT=GetHandleInt(ID,"Status|DamageBonus")+amount
            call SetHandleInt(ID,"Status|DamageBonus",AMOUNT)
            call setBonus(whichUnit,ABIL_DAMAGE,LEVELS_DAMAGE,AMOUNT)
        endfunction
        
        function ArmorBonus takes unit whichUnit,integer amount returns nothing
            set ID=GetHandleId(whichUnit)
            set AMOUNT=GetHandleInt(ID,"Status|ArmorBonus")+amount
            call SetHandleInt(ID,"Status|ArmorBonus",AMOUNT)
            call setBonus(whichUnit,ABIL_ARMOR,LEVELS_DAMAGE,AMOUNT)
        endfunction
        
        function AttackSpeedBonus takes unit whichUnit,integer amount returns nothing
            set ID=GetHandleId(whichUnit)
            set AMOUNT=GetHandleInt(ID,"Status|AttackSpeedBonus")+amount
            call SetHandleInt(ID,"Status|AttackSpeedBonus",AMOUNT)
            call setBonus(whichUnit,ABIL_ATTACK_SPEED,LEVELS_ATTACK_SPEED,AMOUNT)
        endfunction
        
        function ManaBonus takes unit whichUnit,integer amount returns nothing
            set ID=GetHandleId(whichUnit)
            set AMOUNT=GetHandleInt(ID,"Status|Mana")+amount
            call SetHandleInt(ID,"Status|Mana",AMOUNT)
            call setBonus(whichUnit,ABIL_MANA,LEVELS_MANA,AMOUNT)
        endfunction
        
        function GetAttackSpeedBonus takes unit whichUnit returns integer
            return GetHandleInt(GetHandleId(whichUnit),"Status|AttackSpeedBonus")
        endfunction
        
        //! textmacro BONUS_TIMED_DATA_ADD takes TYPE,NAME
            if bonusType == BONUS_TYPE_$TYPE$ then
                call $NAME$Bonus(whichUnit,bonus)
            endif
        //! endtextmacro
        
        //! textmacro BONUS_TIMED_DATA_REMOVE takes TYPE,NAME
            if bonusType == BONUS_TYPE_$TYPE$ then
                call $NAME$Bonus(GetHandleUnit(id,"StatusData|whichUnit"),-GetHandleInt(id,"StatusData|Bonus"))
            endif
        //! endtextmacro
        
        private function endBonus takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            local integer bonusType=GetHandleInt(id,"StatusData|BonusType")
            //! runtextmacro BONUS_TIMED_DATA_REMOVE("DAMAGE","Damage")
            //! runtextmacro BONUS_TIMED_DATA_REMOVE("ARMOR","Armor")
            //! runtextmacro BONUS_TIMED_DATA_REMOVE("ATTACKSPEED","AttackSpeed")
            call ReleaseTimer(t)
            set t = null
        endfunction
        
        function AddBonusTimed takes unit whichUnit,integer bonusType,integer bonus,integer time returns nothing
            local timer t=NewTimer()
            local integer id=GetHandleId(t)
            call SetHandleHandle(id,"StatusData|whichUnit",whichUnit)
            call SetHandleInt(id,"StatusData|BonusType",bonusType)
            call SetHandleInt(id,"StatusData|Bonus",bonus)
            //! runtextmacro BONUS_TIMED_DATA_ADD("DAMAGE","Damage")
            //! runtextmacro BONUS_TIMED_DATA_ADD("ARMOR","Armor")
            //! runtextmacro BONUS_TIMED_DATA_ADD("ATTACKSPEED","AttackSpeed")
            //! runtextmacro BONUS_TIMED_DATA_ADD("MANA","Mana")
            call TimerStart(t,time,false,function endBonus)
            set t = null
        endfunction
        
endlibrary