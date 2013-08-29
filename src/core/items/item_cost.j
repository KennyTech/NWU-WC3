library GetItemGoldCost initializer Init requires Table 

    globals
        private Table GoldPrice = 0
        private player BuyerPlayer = Player(15)
        private unit Buyer
        private unit Shop
    endglobals

    private function GetItemCostById_Filter takes nothing returns boolean
        call RemoveItem(GetFilterItem())
        return false
    endfunction

    private function GetItemCostById takes integer id returns integer
        local integer gold
        if GoldPrice.exists(id) then
            set gold = GoldPrice[id]
        else
            call SetPlayerState(BuyerPlayer, PLAYER_STATE_RESOURCE_GOLD,   50000)
            call AddItemToStock(Shop, id, 1, 1)
            call IssueNeutralImmediateOrderById(BuyerPlayer, Shop, id)
            call RemoveItem(UnitItemInSlot(Buyer, 0))
            call RemoveItemFromStock(Shop, id)
            set gold   = 50000 - GetPlayerState(Player(15), PLAYER_STATE_RESOURCE_GOLD)
            set GoldPrice[id] = gold
        endif
        return gold
    endfunction

    function GetItemGoldCost takes item i returns integer
        return GetItemCostById(GetItemTypeId(i))
    endfunction
    
    private function Remove takes nothing returns nothing
        call RemoveItem(GetEnumItem())
    endfunction
    
    private function RemoveSold takes nothing returns nothing
        call EnumItemsInRect(gg_rct_Taverns,null,function Remove)
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local real x = GetRectCenterX(gg_rct_GetItemGoldCost)
        local real y = GetRectCenterY(gg_rct_GetItemGoldCost)
        set Buyer = CreateUnit(BuyerPlayer, 'Hpal', x, y, 0)   
        set Shop  = CreateUnit(BuyerPlayer, 'nshe', x, y, 0)
        call UnitAddAbility(Shop, 'Asid')
        call UnitRemoveAbility(Shop, 'Awan')
        call UnitAddAbility(Shop, 'Aloc')
        set GoldPrice = Table.create()
        call TimerStart(CreateTimer(),1,true,function RemoveSold)
    endfunction
endlibrary