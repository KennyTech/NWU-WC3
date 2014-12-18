library ItemSystem initializer Init requires ItemData,RecipeSYS,PlayerCore

// Functiones necesarias ---------------------------------------------------------------

    globals
        region KonohaRegion//fuente
        region AkatsukiRegion//fuente
        region KonohaTerritory//todo base
        region AkatsukiTerritory//todo base
    endglobals
    
    private function Init takes nothing returns nothing
        set KonohaRegion=CreateRegion()
        set AkatsukiRegion=CreateRegion()
        set KonohaTerritory=CreateRegion()
        set AkatsukiTerritory=CreateRegion()
        call RegionAddRect(KonohaRegion,gg_rct_Base1)
        call RegionAddRect(AkatsukiRegion,gg_rct_Base2)
        call RegionAddRect(KonohaTerritory,gg_rct_Konoha)
        call RegionAddRect(AkatsukiTerritory,gg_rct_Akatsuki)
    endfunction

// Funciones de Region ---------------------------------------------------------------

    function GetUnitBase takes unit u returns rect
        if IsUnitAlly(u,udg_team1[0]) then
            return gg_rct_Base1
        else
            return gg_rct_Base2
        endif
    endfunction
    
    function IsUnitInBase takes unit u returns boolean
        if IsUnitAlly(u,udg_team1[0]) then
            return IsUnitInRegion(KonohaRegion,u)
        else
            return IsUnitInRegion(AkatsukiRegion,u)
        endif
    endfunction
    
    function IsUnitInEnemyTerritory takes unit u returns boolean
        if IsUnitAlly(u,udg_team2[0]) then
            return IsUnitInRegion(KonohaTerritory,u)
        else
            return IsUnitInRegion(AkatsukiTerritory,u)
        endif
    endfunction
    
// Funciones Courier ---------------------------------------------------------------
   // function PlayerCanTradeTo takes player from,player to takes nothing returns nothing
     //   return GetPlayerAlliance(GetOwningPlayer(GetFilterUnit()), enumPlayer, ALLIANCE_SHARED_CONTROL)
    //endfunction

    function UnitTypeCourier takes unit u returns boolean
        local integer id = GetUnitTypeId(u)
        return (id=='n003' or id=='n01G' or id=='n004' or id=='n01E') and IsUnitIllusion(u)==false
    endfunction
    
    private function Loot takes nothing returns nothing
        local item Item=GetEnumItem()
        if GetItemPlayer(Item)==enumPlayer then
            if UnitAddItem(enumUnit,Item)==false then
                call SetItemPosition(Item,GetUnitX(enumUnit),GetUnitY(enumUnit))
            endif
        endif
        set Item=null
    endfunction
    
    function LootItemsOfPlayerInRange takes unit u,player p,real range returns nothing
        local rect r=Rect(GetUnitX(u)-range,GetUnitY(u)-range,GetUnitX(u)+range,GetUnitY(u)+range)
        set enumPlayer=p
        set enumUnit=u
        call EnumItemsInRect(r,null,function Loot)
        call RemoveRect(r)
        set r=null
    endfunction
    
    function ItemTransfer takes unit courier,unit target returns nothing
        local integer i = 0
        local item itemInSlot
        loop
            set itemInSlot = UnitItemInSlot(courier,i)
            if itemInSlot != null and GetItemPlayer(itemInSlot)==GetOwningPlayer(target) then
                if IsUnitInventoryFull(target)==false then
                    call UnitRemoveItem(courier,itemInSlot)
                    call UnitAddItem(target,itemInSlot)
                else
                    if Combine(itemInSlot,target) == true then
                        set i = -1
                    endif
                endif
            endif
            set i = i + 1
            exitwhen i == 6
        endloop
        call LootItemsOfPlayerInRange(courier,GetOwningPlayer(target),400)
    endfunction
    
    private function GetCourierOfPlayerInBase_Filter takes nothing returns boolean
        return UnitTypeCourier(GetFilterUnit()) and GetWidgetLife(GetFilterUnit())>0.405 and IsUnitInBase(GetFilterUnit())
    endfunction
    
    private function GetCourierInBase_Filter takes nothing returns boolean
        return UnitTypeCourier(GetFilterUnit()) and GetWidgetLife(GetFilterUnit())>0.405 and IsUnitAlly(GetFilterUnit(),enumPlayer) and GetPlayerAlliance(GetOwningPlayer(GetFilterUnit()),enumPlayer,ALLIANCE_SHARED_CONTROL)
    endfunction
    
    function GetCourierInRange takes unit artisan,real range,player ally returns unit
        set enumPlayer=ally
        call GroupEnumUnitsInRange(ENUM,GetUnitX(artisan),GetUnitY(artisan),range,Filter(function GetCourierInBase_Filter))
        set enumUnit=FirstOfGroup(ENUM)
        call GroupClear(ENUM)
        return enumUnit
    endfunction
    
    function GetCourierOfPlayerInBase takes player whichPlayer returns unit
        call GroupEnumUnitsOfPlayer(ENUM,whichPlayer,Filter(function GetCourierOfPlayerInBase_Filter))
        set enumUnit=FirstOfGroup(ENUM)
        call GroupClear(ENUM)
        return enumUnit
    endfunction
    
    function GetCourierInBase takes player whichPlayer returns unit
        set enumUnit = GetCourierOfPlayerInBase(whichPlayer)
        if enumUnit==null then
            debug call BJDebugMsg("GetCourierOfPlayerInBase FALSE")
            set enumPlayer=whichPlayer
            if IsPlayerAlly(whichPlayer,udg_team1[0]) then
                call GroupEnumUnitsInRect(ENUM,gg_rct_Base1,Filter(function GetCourierInBase_Filter))
            else
                call GroupEnumUnitsInRect(ENUM,gg_rct_Base2,Filter(function GetCourierInBase_Filter))
            endif
            set enumUnit=FirstOfGroup(ENUM)
            call GroupClear(ENUM)
        endif
        return enumUnit
    endfunction
    
    function UnitDropItems takes unit u returns nothing
        local integer index=0
        local boolean base=IsUnitInBase(u)
        local item Item
        loop
            exitwhen index==UnitInventorySize(u)
            set Item = UnitItemInSlot(u,index)
            if  Item != null then
                call UnitRemoveItem(u,Item)
                if base then
                    call SetItemPosition(Item,GetUnitX(GetPlayerCircle(GetItemPlayer(Item))),GetUnitY(GetPlayerCircle(GetItemPlayer(Item))))
                endif
            endif
            set index = index+1
        endloop
        set u = null
        set Item = null
    endfunction

// Funciones de item---------------------------------------------------------------

    globals
        private item ReplacedItem
    endglobals

    function ReplaceItem takes unit Caster, item ReplacedItem, integer NewItemType returns item
        local integer index = 0
        local player owner = GetItemPlayer(ReplacedItem)
        local item temp
        local item array m
        local integer k = 0
        local integer max = UnitInventorySize(Caster)-1
        loop
            exitwhen index==max
            if UnitItemInSlot(Caster,index)==null then
                call DisableTrigger(gg_trg_Item_Pick)
                set m[k] = UnitAddItemById(Caster,'I01V')
                call EnableTrigger(gg_trg_Item_Pick)
                set k = k + 1
            endif
            set index = index + 1
        endloop 
        call RemoveItem(ReplacedItem)
        set ReplacedItem = CreateItem(NewItemType,0,0)
        call SetItemPlayer(ReplacedItem,owner,false)
        call UnitAddItem(Caster,ReplacedItem)
        loop
            set k = k - 1
            exitwhen k<0
            call RemoveItem(m[k])
            set m[k] = null
        endloop
        set temp = null
        return ReplacedItem
    endfunction

    function UnitCountItemsOfType takes unit u,integer which returns integer
        local integer index = 0
        local integer count = 0
        loop
            if GetItemTypeId(UnitItemInSlot(u,index))==which then
                set count = count + 1
            endif
            set index = index + 1
            exitwhen index==UnitInventorySize(u)
        endloop
        return count 
    endfunction
    
    function CombineCharges takes unit u, item Item returns boolean
        local integer NCharges = GetItemCharges(Item)
        local integer MaxSlots
        local integer s = 0
        local integer id
        local item TempI

        if NCharges > 0 then
           set MaxSlots = UnitInventorySize( u )
              set id = GetItemTypeId(Item)
              //Chekeo que no sea Rengeki, Animal Courier, Dust of Appearance
              if id=='I035' or id=='I014' or id=='I06O' or id=='I037' or id=='I06R' then
                 return false
              endif
              loop
                  exitwhen s >= MaxSlots
                  set TempI = UnitItemInSlot(u, s)
                  if TempI!=Item and GetItemTypeId(TempI)==id then
                     call SetItemCharges( TempI, NCharges + GetItemCharges(TempI) )
                     call RemoveItem(Item)
                     return true
                  endif
                  set s = s + 1
              endloop
           endif
        return false
    endfunction

endlibrary