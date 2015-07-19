scope ChibakuItemSilence initializer Init{

    private boolean CancelOrder(){

        int id = GetIssuedOrderId()

        if(id >= ORDER_useslot1 and id <= ORDER_useslot6 and GetUnitAbilityLevel(GetTriggerUnit(), 'B00X') > 0){
            call AbortOrder(GetTriggerUnit())
        }

        return false
    }

    private void Init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER, function CancelOrder)
    }

}