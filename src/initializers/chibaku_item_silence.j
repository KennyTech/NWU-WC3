scope ChibakuItemSilence initializer Init{

    private boolean CancelOrder(){

        int id = GetIssuedOrderId()

        if(id >= ORDER_useslot1 and id <= ORDER_useslot6){
            call AbortOrder(GetTriggerUnit())
            debug call BJDebugMsg("USANDO ITEM CTM")
        }

        return false
    }

    private void Init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER, function CancelOrder)
    }

}