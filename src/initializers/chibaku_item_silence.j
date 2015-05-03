scope ChibakuItemSilence initializer Init{

    private boolean CancelOrder(){
        if(GetUnitAbilityLevel(GetTriggerUnit(), 'B00X') > 0){
            AbortOrder(GetTriggerUnit())
        }
        return false
    }

    public void Init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_SPELL_CAST, function CancelOrder)
    }

}